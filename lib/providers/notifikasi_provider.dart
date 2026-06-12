import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/notifikasi_model.dart';
import '../services/notifikasi_service.dart';

class NotifikasiProvider with ChangeNotifier {
  late NotifikasiService _service;

  List<NotifikasiModel> _listNotif = [];
  bool _isLoading = false;

  List<NotifikasiModel> get listNotif => _listNotif;
  bool get isLoading => _isLoading;

  int get totalUnread => _listNotif.where((n) => !n.isRead).length;

  void updateService(NotifikasiService service) {
    _service = service;
    log("AuthProvider: Service telah diperbarui dengan Interceptor!");
  }

  List<NotifikasiModel> get listHariIni {
    final now = DateTime.now();
    return _listNotif.where((n) {
      return n.createdAt.year == now.year &&
          n.createdAt.month == now.month &&
          n.createdAt.day == now.day;
    }).toList();
  }

  List<NotifikasiModel> get listKemarin {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _listNotif.where((n) {
      final notifDate = DateTime(
        n.createdAt.year,
        n.createdAt.month,
        n.createdAt.day,
      );
      return notifDate.isBefore(today);
    }).toList();
  }

  Future<void> fetchNotifikasi() async {
    _isLoading = true;
    notifyListeners();
    try {
      _listNotif = await _service.getRiwayatNotifikasi();
    } catch (e) {
      debugPrint("❌ Error Fetch Notif: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bacaNotifikasi(int id) async {
    final index = _listNotif.indexWhere((n) => n.idNotifikasi == id);
    if (index != -1 && !_listNotif[index].isRead) {
      _listNotif[index].isRead = true;
      notifyListeners();
      try {
        await _service.markAsRead(id);
      } catch (e) {
        _listNotif[index].isRead = false;
        notifyListeners();
      }
    }
  }

  Future<void> hapusNotifikasi(int id) async {
    final penampungLokal = [..._listNotif];
    _listNotif.removeWhere((n) => n.idNotifikasi == id);
    notifyListeners();

    try {
      await _service.deleteNotifikasi(id);
    } catch (e) {
      _listNotif = penampungLokal;
      notifyListeners();
    }
  }
}
