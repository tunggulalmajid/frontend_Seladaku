import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seladaku/models/riwayat_grafik_model.dart';
import 'package:seladaku/services/riwayat_service.dart';

class RiwayatProvider with ChangeNotifier {
  late RiwayatService _riwayatService;

  List<RiwayatGrafikModel> _listDataGrafik = [];
  bool _isLoading = false;
  String _activeRange = "harian";

  List<RiwayatGrafikModel> get listDataGrafik => _listDataGrafik;
  bool get isLoading => _isLoading;
  String get activeRange => _activeRange;

  void updateService(RiwayatService service) {
    _riwayatService = service;
    log("RiwayatProvider: Service telah diperbarui dengan Interceptor!");
  }

  Future<void> fetchRiwayatGrafik(int idTandon, String range) async {
    _isLoading = true;
    _activeRange = range;
    _listDataGrafik = [];
    notifyListeners();

    try {
      final dataTerambil = await _riwayatService.getGrafikRiwayat(
        idTandon,
        range,
      );
      _listDataGrafik = dataTerambil;
    } catch (e) {
      log("RiwayatProvider Error: Gagal memproses data grafik -> $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _listDataGrafik = [];
    _activeRange = "harian";
  }
}
