import 'package:dio/dio.dart';
import 'package:frontend_ambilin/dto/edit_profile_dto.dart';
import '../dto/login_request.dart';
import '../dto/register_request.dart';
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
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateProfile(EditProfileDTO dto, String token) async {
    // Siapkan Map data teks
    Map<String, dynamic> dataMap = {
      "nama": dto.nama,
      "email": dto.email,
      "nomorTelepon": dto.nomorTelepon,
      "alamat": dto.alamat,
      "idTelegram": dto.idTelegram,
      "lat": dto.lat,
      "lon": dto.lon,
    };

    FormData formData = FormData.fromMap(dataMap);

    // Tambahkan file foto kalau ada
    if (dto.fotoFile != null) {
      formData.files.add(
        MapEntry(
          "foto",
          await MultipartFile.fromFile(
            dto.fotoFile!.path,
            filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
          ),
        ),
      );
    }

    return await dio.put(
      "/auth/update-profile",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Logout (Backend)
  Future<Response> logout(String token) async {
    return await dio.post(
      '/auth/logout',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
