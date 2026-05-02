import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // 1. Ambil Data User Berdasarkan Token yang Tersimpan (Auto Login)
  Future<void> fetchUser() async {
    _isLoading = true;
    try {
      String? token = await _storage.read(key: "accessToken");
      if (token == null) {
        _user = null;
        return;
      }

      final response = await _authService.getMe(token);
      if (response.data['success'] == true) {
        _user = UserModel.fromJson(response.data['data']);
      } else {
        _user = null;
      }
    } catch (e) {
      log("Error Fetch User: $e");
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Registrasi
  Future<bool> register(RegisterRequest data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.register(data);
      _isLoading = false;
      notifyListeners();
      return response.data['success'] == true;
    } catch (e) {
      log("Error Register: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 3. Login
  Future<bool> login(LoginRequest data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.login(data);
      if (response.data['success'] == true) {
        await _storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        await _storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );

        final user = await _authService.getMe(response.data['accessToken']);
        _user = UserModel.fromJson(user.data['data']);
        log(_user!.nama);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      log("Error Login: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 4. Logout
  void logout() async {
    String? token = await _storage.read(key: "accessToken");
    if (token != null) {
      try {
        await _authService.logout(token);
      } catch (_) {}
    }
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
}
