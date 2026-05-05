import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/tandon_model.dart';
import '../services/tandon_service.dart';

class TandonProvider with ChangeNotifier {
  late TandonService _tandonService;
  List<TandonModel> _listTandon = [];
  bool _isLoading = false;

  List<TandonModel> get listTandon => _listTandon;
  bool get isLoading => _isLoading;

  // Disuntikkan di main.dart melalui ChangeNotifierProxyProvider
  void updateService(TandonService service) {
    _tandonService = service;
  }

  // 1. Fetch Tandon berdasarkan Area
  Future<void> getTandonByArea(int idArea) async {
    _isLoading = true;
    notifyListeners();
    try {
      log("${_listTandon.length}");
      _listTandon = await _tandonService.fetchTandonByArea(idArea);
      log("${_listTandon.length}");
    } catch (e) {
      debugPrint("Error FetchTandonByArea: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Create Tandon Baru
  Future<bool> createTandon({
    required int idArea,
    required String nama,
    required DateTime tanggalTanam,
  }) async {
    try {
      log("Masuk Ke Func Creat TAndon di provider");
      bool success = await _tandonService.addTandon(
        idArea,
        nama,
        tanggalTanam.toIso8601String(),
      );
      log("data success : $success");
      if (success) {
        await getTandonByArea(idArea);
      }
      return success;
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  // 3. Update Modular (PATCH)
  // Digunakan untuk: Ganti nama, toggle pompa (ON/OFF), ganti parameter pH/PPM, dll.
  Future<bool> updateTandon(
    int idTandon,
    Map<String, dynamic> dataPerubahan,
  ) async {
    log("masuk ke provider");
    bool success = await _tandonService.updateTandon(idTandon, dataPerubahan);
    log(success.toString());

    if (success) {
      // Cari tandon yang diupdate di list local untuk mendapatkan idArea-nya
      final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
      if (index != -1) {
        // Refresh data dari server agar data sensor (pH, PPM, dll) ikut terupdate
        await getTandonByArea(_listTandon[index].idArea);
      }
    }
    return success;
  }

  // 4. Delete Tandon
  Future<bool> removeTandon(int idTandon) async {
    bool success = await _tandonService.deleteTandon(idTandon);
    if (success) {
      _listTandon.removeWhere((t) => t.idTandon == idTandon);
      notifyListeners();
    }
    return success;
  }
}
