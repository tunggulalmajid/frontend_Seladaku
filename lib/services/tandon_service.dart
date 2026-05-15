// import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:frontend_seladaku/models/tandon_model.dart';
import 'api_service.dart';

class TandonService extends ApiService {
  Future<List<TandonModel>> fetchTandonByArea(int idArea) async {
    try {
      final response = await dio.get("/tandon/area/$idArea");
      if (response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((e) => TandonModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Tambah area baru
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

  // Update area (Nama atau Status)
  Future<bool> updateTandon(
    int idTandon,
    Map<String, dynamic> dataPerubahan,
  ) async {
    try {
      log("masuk ke service ");
      final response = await dio.patch(
        "/tandon/$idTandon",
        data:
            dataPerubahan, // Kirim map yang berisi kolom yang ingin diubah saja
      );
      log(response.toString());
      return response.data['success'] == true;
    } catch (e) {
      log("error : $e");
      return false;
    }
  }

  // --- TAMBAHAN ENDPOINT PAIRING DEVICE ---
  Future<bool> pairDevice(int idTandon, String deviceId) async {
    try {
      log("Menghubungkan device ke Tandon ID: $idTandon");

      // Method diganti POST, URL disesuaikan dengan Swagger: /tandon/pair-device/{id}
      final response = await dio.post(
        "/tandon/pair-device/$idTandon",
        data: {
          "device_id": deviceId, // Sesuai dengan Example Value Request Body
        },
      );

      log("Respon server: ${response.data}");
      return response.data['success'] == true;
    } catch (e) {
      log("Error pairDevice Service: $e");
      return false;
    }
  }

  // Hapus area
  Future<bool> deleteTandon(int idTandon) async {
    try {
      final response = await dio.delete("/tandon/$idTandon");
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
