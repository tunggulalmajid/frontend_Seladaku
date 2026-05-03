import 'package:dio/dio.dart';
import 'package:frontend_seladaku/dto/edit_profile_dto.dart';
import '../dto/login_request.dart';
import '../dto/register_request.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  // Login & Register: Tidak butuh token, Interceptor akan kirim header kosong otomatis
  Future<Response> login(LoginRequest data) async {
    return await dio.post('/auth/login', data: data.toJson());
  }

  Future<Response> register(RegisterRequest data) async {
    return await dio.post('/auth/register', data: data.toJson());
  }

  // Get Me: SEKARANG BERSIH! Tidak perlu oper parameter String token lagi
  Future<Response> getMe() async {
    // Interceptor otomatis nambahin Bearer Token di sini
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

    // Tidak perlu lagi: options: Options(headers: {"Authorization": "Bearer $token"})
    return await dio.put("/auth/update-profile", data: formData);
  }

  Future<Response> refresh(String refreshToken) async {
    // Endpoint refresh biasanya tidak butuh Bearer token lama, cuma butuh body ini
    return await dio.post('/auth/refresh', data: {'token': refreshToken});
  }

  Future<Response> logout() async {
    // Interceptor yang akan masukin tokennya
    return await dio.post('/auth/logout');
  }
}
