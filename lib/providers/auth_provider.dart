import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_ambilin/models/register_request.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _dio = Dio(BaseOptions(baseUrl: "http://localhost:3000/api"));

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

Future<bool> register(RegisterRequest data) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kirim data langsung menggunakan .toJson()
      final response = await _dio.post('/auth/register', data: data.toJson());

      log("Response Register: ${response.data}");

      _isLoading = false;
      notifyListeners();

      if (response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      log("Error Register: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  // Fungsi Login
  Future<bool> login(LoginRequest data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _dio.post('/auth/login', data: data.toJson());
      if (response.data['success'] == true) {
        // Simpan Token
        log("response : ${response.data}");
        await _storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        await _storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );

        // Simpan data user (ambil dari key 'user' di response login kamu)
        // log("response : ${response.data}");
        _user = UserModel.fromJson(response.data['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        return false;
      }
    } catch (e) {
      log("response : $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fungsi Logout
  void logout() async {
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
}
