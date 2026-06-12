import 'dart:developer';
import 'api_service.dart';
import '../models/notifikasi_model.dart';

class NotifikasiService extends ApiService {
  Future<List<NotifikasiModel>> getRiwayatNotifikasi() async {
    try {
      final response = await dio.get('/notifikasi');

      if (response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((e) => NotifikasiModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("Error getRiwayatNotifikasi Service: $e");
      rethrow;
    }
  }

  Future<bool> markAsRead(int id) async {
    try {
      final response = await dio.patch('/notifikasi/$id/read');
      return response.data['success'] == true;
    } catch (e) {
      log("Error markAsRead Service: $e");
      return false;
    }
  }

  Future<bool> deleteNotifikasi(int id) async {
    try {
      final response = await dio.delete('/notifikasi/$id');
      return response.data['success'] == true;
    } catch (e) {
      log("Error deleteNotifikasi Service: $e");
      return false;
    }
  }
}
