import 'package:dio/dio.dart';
import 'package:seladaku/dto/edit_profile_dto.dart';
import '../dto/login_request.dart';
import '../dto/register_request.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  Future<Response> login(LoginRequest data) async {
    return await dio.post('/auth/login', data: data.toJson());
  }

  Future<Response> register(RegisterRequest data) async {
    return await dio.post('/auth/register', data: data.toJson());
  }

  Future<Response> getMe() async {
    return await dio.get('/auth/me');
  }

  Future<Response> updateProfile(EditProfileDTO dto) async {
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

    return await dio.put("/auth/update-profile", data: formData);
  }

  Future<Response> refresh(String refreshToken) async {
    return await dio.post('/auth/refresh', data: {'token': refreshToken});
  }

  Future<Response> logout() async {
    return await dio.delete('/auth/logout');
  }
}
