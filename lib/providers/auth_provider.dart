import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seladaku/dto/edit_profile_dto.dart';
import '../dto/login_request.dart';
import '../dto/register_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  late AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  void updateService(AuthService service) {
    _authService = service;
    log("AuthProvider: Service telah diperbarui dengan Interceptor!");
  }

  Future<void> fetchUser() async {
    _isLoading = true;
    try {
      String? accessToken = await _storage.read(key: "accessToken");

      if (accessToken == null) return;

      final response = await _authService.getMe();

      if (response.data['success'] == true) {
        _user = UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      log("Error Fetch User: $e");
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.register(data);
      return response.data['success'] == true;
    } catch (e) {
      log("Error Register: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

        final profile = await _authService.getMe();
        _user = UserModel.fromJson(profile.data['data']);

        return true;
      }
      return false;
    } catch (e) {
      log("Error Login: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(EditProfileDTO dto) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.updateProfile(dto);
      if (response.statusCode == 200) {
        await fetchUser();
        return true;
      }
      return false;
    } catch (e) {
      log("Error Update Profile: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleRefreshToken() async {
    try {
      String? refreshToken = await _storage.read(key: "refreshToken");
      log("Token : $refreshToken ");
      if (refreshToken == null) return false;

      final response = await _authService.refresh(refreshToken);

      if (response.data['success'] == true) {
        await _storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        log("newAccessToken : ${response.data['accessToken']}");
        return true;
      }
    } catch (e) {
      log("Error saat Refresh Token: $e");
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      log("error : $e");
    }
    await logoutLocally();
  }

  Future<void> logoutLocally() async {
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
}
