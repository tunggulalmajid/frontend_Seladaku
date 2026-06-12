import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seladaku/models/weather_model.dart';
import 'package:seladaku/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _namaLokasiAktif;
  String?
  _alamatLengkapAktif; 

  double? _lastLat;
  double? _lastLon;

  WeatherModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get namaLokasiAktif => _namaLokasiAktif;
  String? get alamatLengkapAktif =>
      _alamatLengkapAktif ?? "Mencari data wilayah...";
  bool get hasLocation => _namaLokasiAktif != null;

  
  Future<void> updateLokasiCuaca({
    required String namaKota,
    required double latitude,
    required double longitude,
    String?
    alamatDetail, 
  }) async {
    _namaLokasiAktif = namaKota;
    _lastLat = latitude;
    _lastLon = longitude;

    
    if (alamatDetail != null) {
      _alamatLengkapAktif = alamatDetail;
    } else if (_alamatLengkapAktif == null) {
      _alamatLengkapAktif = "Kabupaten Jember, Jawa Timur";
    }

    _isLoading = true;
    notifyListeners();

    final responseData = await _weatherService.getForecast(latitude, longitude);
    log("Response Open-Meteo: ${responseData.toString()}");

    if (responseData != null) {
      _weatherData = WeatherModel.fromJson(_namaLokasiAktif!, responseData);
    } else {
      _weatherData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  
  Future<void> refreshCuaca() async {
    if (hasLocation && _lastLat != null && _lastLon != null) {
      final responseData = await _weatherService.getForecast(
        _lastLat!,
        _lastLon!,
      );

      if (responseData != null) {
        _weatherData = WeatherModel.fromJson(_namaLokasiAktif!, responseData);
        log("Data cuaca berhasil diperbarui lewat refresh manual.");
      }
      notifyListeners();
    }
  }
}
