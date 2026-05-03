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
    final path = err.requestOptions.path;

    
    // 1. Abaikan path publik
    if (path.contains('/login') || path.contains('/register')) {
      log("ℹ️ Interceptor: Mengabaikan error di path publik ($path)");
      return handler.next(err);
    }

    // 2. Cek apakah error 401/403 DAN pastikan request ini BELUM pernah di-retry
    // Kita pakai extra['isRetry'] untuk membatasi agar tidak loop selamanya
    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        err.requestOptions.extra['isRetry'] != true) {
      log("🚨 Interceptor: Mendeteksi 401/403. Memulai proses Refresh...");

      // Tandai request ini sudah melakukan percobaan retry
      err.requestOptions.extra['isRetry'] = true;

      // Jalankan fungsi tukar token
      bool isRefreshed = await authProvider.handleRefreshToken();

      if (isRefreshed) {
        log("✅ Interceptor: Refresh Berhasil! Mencoba ulang request asli...");

        // Ambil token baru
        String? newToken = await _storage.read(key: "accessToken");

        // Update header request yang gagal tadi dengan token baru
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        // Eksekusi ulang request asli
        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          log("❌ Interceptor: Gagal saat mencoba ulang request: $e");
        }
      } else {
        log("❌ Interceptor: Refresh Token gagal atau expired. Memaksa Logout.");
        authProvider.logoutLocally();
      }
    }

    // Jika sudah pernah di-retry tapi tetap 401, atau memang error selain 401
    // Biarkan error lanjut ke UI agar tidak terjadi infinite loop
    return handler.next(err);
  }
}
