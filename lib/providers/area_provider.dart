import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/dashboard_area_model.dart';
import '../models/area_model.dart';
import '../services/area_service.dart';

class AreaProvider with ChangeNotifier {
  late AreaService _areaService;
  List<AreaModel> _areas = [];
  bool _isLoading = false;

  List<AreaModel> get areas => _areas;
  List<DashboardAreaModel> _listDashboard = [];
  List<DashboardAreaModel> get listDashboard => _listDashboard;

  bool _isDashboardLoading = false;
  bool get isDashboardLoading => _isDashboardLoading;
  bool get isLoading => _isLoading;

  // Dipanggil di main.dart untuk menyuntikkan service yang sudah siap
  void updateService(AreaService service) {
    _areaService = service;
  }

  // Get data area
  Future<void> fetchAreas() async {
    _isLoading = true;
    notifyListeners();
    try {
      _areas = await _areaService.fetchMyAreas();
    } catch (e) {
      debugPrint("Error FetchAreas: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboardData() async {
    _isDashboardLoading = true;
    notifyListeners();
    try {
      _listDashboard = await _areaService.getDashboardSummary();
      log("berhasil mengambil data");
    } catch (e) {
      log("Error fetchDashboardData Provider: $e");
    } finally {
      _isDashboardLoading = false;
      notifyListeners();
    }
  }

  // Create
  Future<bool> createArea(String nama) async {
    bool success = await _areaService.addArea(nama);
    if (success) await fetchAreas();
    return success;
  }

  // Update
  Future<bool> updateArea(int idArea, String nama, bool status) async {
    bool success = await _areaService.updateArea(idArea, nama, status);
    if (success) await fetchAreas();
    return success;
  }

  // Delete
  Future<bool> removeArea(int idArea) async {
    bool success = await _areaService.deleteArea(idArea);
    if (success) {
      _areas.removeWhere((a) => a.idArea == idArea);
      notifyListeners();
    }
    return success;
  }
}
