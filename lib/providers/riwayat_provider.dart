import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/riwayat_grafik_model.dart';
import 'package:frontend_seladaku/services/riwayat_service.dart';

class RiwayatProvider with ChangeNotifier {
  // Gunakan late agar sinkron disuntikkan dari main.dart setelah interceptor terpasang
  late RiwayatService _riwayatService;

  List<RiwayatGrafikModel> _listDataGrafik = [];
  bool _isLoading = false;
  String _activeRange = "harian";

  List<RiwayatGrafikModel> get listDataGrafik => _listDataGrafik;
  bool get isLoading => _isLoading;
  String get activeRange => _activeRange;

  // 1. Fungsi Injeksi Service (Penyelaras Cetakan Arsitektur 🛠️)
  void updateService(RiwayatService service) {
    _riwayatService = service;
    log("RiwayatProvider: Service telah diperbarui dengan Interceptor!");
  }

  // 2. Ambil data grafik dari service layer
  Future<void> fetchRiwayatGrafik(int idTandon, String range) async {
    _isLoading = true;
    _activeRange = range;
    _listDataGrafik =
        []; // Bersihkan data lama agar grafik tidak patah saat tab pindah
    notifyListeners();

    try {
      // Menembak endpoint via instance service yang sudah mengantongi token JWT
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

  // 3. Bersihkan memori penampungan saat halaman ditutup
  void clearData() {
    _listDataGrafik = [];
    _activeRange = "harian";
  }
}
