import 'dart:developer';

import 'package:seladaku/models/tandon_model.dart';
import 'api_service.dart';

class TandonService extends ApiService {
  Future<List<TandonModel>> fetchTandonByArea(int idArea) async {
    try {
      final response = await dio.get("/tandon/area/$idArea");
      if (response.data['success'] == true) {
        List data = response.data['data'];
        log(data.toString());
        return data.map((e) => TandonModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addTandon(int idArea, String nama, tanggalTanam) async {
    try {
      final response = await dio.post(
        "/tandon",
        data: {
          "nama_tandon": nama,
          "tanggal_tanam": tanggalTanam,
          "id_area": idArea,
        },
      );
      log("${response.data}");
      return response.data['success'] == true;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  Future<bool> updateTandon(
    int idTandon,
    Map<String, dynamic> dataPerubahan,
  ) async {
    try {
      log("masuk ke service ");
      final response = await dio.patch(
        "/tandon/$idTandon",
        data: dataPerubahan,
      );
      log(response.toString());
      return response.data['success'] == true;
    } catch (e) {
      log("error : $e");
      return false;
    }
  }

  Future<bool> pairDevice(int idTandon, String deviceId) async {
    try {
      log("Menghubungkan device ke Tandon ID: $idTandon");

      final response = await dio.post(
        "/tandon/pair-device/$idTandon",
        data: {"device_id": deviceId},
      );

      log("Respon server: ${response.data}");
      return response.data['success'] == true;
    } catch (e) {
      log("Error pairDevice Service: $e");
      return false;
    }
  }

  Future<bool> deleteTandon(int idTandon) async {
    try {
      final response = await dio.delete("/tandon/$idTandon");
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerFcmToken(int idTandon, String token) async {
    try {
      final response = await dio.post(
        "/tandon/$idTandon/fcm-token",
        data: {"fcm_token": token},
      );
      log("Respon registerFcmToken: ${response.data}");
      return response.data['success'] == true;
    } catch (e) {
      log("Error registerFcmToken Service: $e");
      return false;
    }
  }

  Future<bool> unregisterFcmToken(int idTandon) async {
    try {
      final response = await dio.delete("/tandon/$idTandon/fcm-token");
      log("Respon unregisterFcmToken: ${response.data}");
      return response.data['success'] == true;
    } catch (e) {
      log("Error unregisterFcmToken Service: $e");
      return false;
    }
  }
}
