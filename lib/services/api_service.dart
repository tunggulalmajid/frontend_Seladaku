import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://seladaku.kodetalma.my.id/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  void addInterceptor(Interceptor interceptor) {
    // Pastikan ini barisnya benar
    dio.interceptors.add(interceptor);
    log("ApiService: Interceptor berhasil ditambahkan ke Dio!");
  }
}
