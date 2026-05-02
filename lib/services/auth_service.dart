import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  // Login
  Future<Response> login(LoginRequest data) async {
    return await dio.post('/auth/login', data: data.toJson());
  }

  // Register
  Future<Response> register(RegisterRequest data) async {
    return await dio.post('/auth/register', data: data.toJson());
  }

  // Get Me (Ambil Profil User)
  Future<Response> getMe(String token) async {
    return await dio.get(
      '/auth/me',
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
  }

  // Logout (Backend)
  Future<Response> logout(String token) async {
    return await dio.post(
      '/auth/logout',
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
  }
}