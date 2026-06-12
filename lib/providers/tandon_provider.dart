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

  
  void updateService(TandonService service) {
    _tandonService = service;
  }

  
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

  
  
  Future<bool> updateTandon(
    int idTandon,
    Map<String, dynamic> dataPerubahan,
  ) async {
    log("masuk ke provider");
    bool success = await _tandonService.updateTandon(idTandon, dataPerubahan);
    log(success.toString());

    if (success) {
      
      final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
      if (index != -1) {
        
        await getTandonByArea(_listTandon[index].idArea);
      }
    }
    return success;
  }

  void updateTandonFromSocket(int idTandon, Map<String, dynamic> newData) {
    final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
    if (index != -1) {
      
      _listTandon[index] = _listTandon[index].copyWith(
        ph: newData['ph']?.toDouble(),
        ppm: newData['ppm']?.toDouble(),
        volume: newData['volume_air']?.toDouble(),
        isHujan: newData['is_hujan'] == 1 || newData['is_hujan'] == true,
        statusS1: newData['status_s1'],
        statusS2: newData['status_s2'],
        statusPompa: newData['status_pompa'],
        modeOtomatis: newData['mode_otomatis'] != null
            ? (newData['mode_otomatis'] == 1 ||
                  newData['mode_otomatis'] == true)
            : null,
        lastSeen: DateTime.now(),
      );

      notifyListeners(); 
      log("Provider: Data updated for Tandon $idTandon");
    }
  }

  Future<bool> connectDevice(int idTandon, String deviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _tandonService.pairDevice(idTandon, deviceId);
      if (success) {
        
        final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
        if (index != -1) {
          _listTandon[index] = _listTandon[index].copyWith(deviceId: deviceId);
        }
      }
      return success;
    } catch (e) {
      log("Error connectDevice Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> removeTandon(int idTandon) async {
    bool success = await _tandonService.deleteTandon(idTandon);
    if (success) {
      _listTandon.removeWhere((t) => t.idTandon == idTandon);
      notifyListeners();
    }
    return success;
  }

  
  Future<bool> simpanFcmTokenKeBackend(String token, int idTandon) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      bool tokenSuccess = await _tandonService.registerFcmToken(
        idTandon,
        token,
      );

      if (tokenSuccess) {
        
        await _tandonService.updateTandon(idTandon, {
          'is_notif_aktif':
              1, 
        });

        
        final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
        if (index != -1) {
          _listTandon[index] = _listTandon[index].copyWith(
            isNotifAktif: true,
            fcmToken: token,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      log("Error simpanFcmTokenKeBackend Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> hapusFcmTokenDariBackend(int idTandon) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      bool tokenSuccess = await _tandonService.unregisterFcmToken(idTandon);

      if (tokenSuccess) {
        
        await _tandonService.updateTandon(idTandon, {
          'is_notif_aktif': 0, 
        });

        
        final index = _listTandon.indexWhere((t) => t.idTandon == idTandon);
        if (index != -1) {
          _listTandon[index] = _listTandon[index].copyWith(
            isNotifAktif: false,
            fcmToken: null,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      log("Error hapusFcmTokenDariBackend Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
