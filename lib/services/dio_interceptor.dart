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

    if (path.contains('/login') || path.contains('/register')) {
      log("ℹ️ Interceptor: Mengabaikan error di path publik ($path)");
      return handler.next(err);
    }

    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        err.requestOptions.extra['isRetry'] != true) {
      log("🚨 Interceptor: Mendeteksi 401/403. Memulai proses Refresh...");

      err.requestOptions.extra['isRetry'] = true;

      bool isRefreshed = await authProvider.handleRefreshToken();

      if (isRefreshed) {
        log("✅ Interceptor: Refresh Berhasil! Mencoba ulang request asli...");

        String? newToken = await _storage.read(key: "accessToken");

        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

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

    return handler.next(err);
  }
}
