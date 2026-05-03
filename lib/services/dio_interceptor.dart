import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/auth_provider.dart';

class DioInterceptor extends Interceptor {
  final AuthProvider authProvider;
  final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioInterceptor({required this.authProvider, required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token = await _storage.read(key: "accessToken");
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Cek apakah response dari server memang 401
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      log(
        "🚨 Interceptor: Mendeteksi 401 (Akses ditolak). Memulai proses Refresh...",
      );

      // Jalankan fungsi tukar token
      bool isRefreshed = await authProvider.handleRefreshToken();

      if (isRefreshed) {
        log("✅ Interceptor: Refresh Berhasil! Mencoba ulang request asli...");

        // Ambil token baru yang sudah disimpan handleRefreshToken
        String? newToken = await _storage.read(key: "accessToken");

        // Update header request yang gagal tadi dengan token baru
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        // Eksekusi ulang request asli
        try {
          final response = await dio.fetch(options);
          return handler.resolve(
            response,
          ); // Berikan hasil sukses ke AuthProvider
        } catch (e) {
          log("❌ Interceptor: Gagal saat mencoba ulang request: $e");
        }
      } else {
        log("❌ Interceptor: Refresh Token gagal atau expired. Memaksa Logout.");
        authProvider.logoutLocally();
      }
    }
    // Jika bukan 401, biarkan error lanjut ke UI
    return handler.next(err);
  }
}
