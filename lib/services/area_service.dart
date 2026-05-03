// import 'package:dio/dio.dart';
import '../models/area_model.dart';
import 'api_service.dart';

class AreaService extends ApiService {
  // Fungsi vital agar request ke /area menyertakan token dari AuthProvider

  // Ambil semua area (Halaman Kebunku)
  Future<List<AreaModel>> fetchMyAreas() async {
    try {
      final response = await dio.get("/area");
      if (response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((e) => AreaModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Tambah area baru
  Future<bool> addArea(String nama) async {
    try {
      final response = await dio.post("/area", data: {"nama": nama});
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Update area (Nama atau Status)
  Future<bool> updateArea(int idArea, String nama, bool status) async {
    try {
      final response = await dio.put(
        "/area/$idArea",
        data: {"nama": nama, "status": status},
      );
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Hapus area
  Future<bool> deleteArea(int idArea) async {
    try {
      final response = await dio.delete("/area/$idArea");
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
