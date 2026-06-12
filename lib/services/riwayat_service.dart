import 'dart:developer';
import 'package:seladaku/models/riwayat_grafik_model.dart';
import 'package:seladaku/services/api_service.dart';

class RiwayatService extends ApiService {
  Future<List<RiwayatGrafikModel>> getGrafikRiwayat(
    int idTandon,
    String range,
  ) async {
    try {
      final response = await dio.get(
        "/riwayat/grafik/$idTandon",
        queryParameters: {"range": range},
      );

      if (response.data['success'] == true) {
        final List dataMentah = response.data['data'];
        return dataMentah.map((e) => RiwayatGrafikModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      log("Error pada RiwayatService (getGrafikRiwayat): $e");

      rethrow;
    }
  }
}
