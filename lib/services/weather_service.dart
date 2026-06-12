import 'package:dio/dio.dart';
import 'dart:developer';

class WeatherService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> getForecast(double lat, double lon) async {
    try {
      final String url =
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

      log("Menembak API Cuaca Open-Meteo: $url");
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      log("Dio Error saat mengambil cuaca: ${e.message}");
      return null;
    } catch (e) {
      log("Error tidak terduga di WeatherService: $e");
      return null;
    }
  }
}
