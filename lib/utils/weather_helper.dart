import 'package:flutter/material.dart';

class WeatherHelper {
  static String getInfoCuaca(int code) {
    switch (code) {
      case 0:
        return "Cerah";
      case 1:
      case 2:
      case 3:
        return "Cerah Berawan";
      case 45:
      case 48:
        return "Berkabut";
      case 51:
      case 53:
      case 55:
        return "Gerimis";
      case 56:
      case 57:
        return "Gerimis Beku";
      case 61:
        return "Hujan Ringan";
      case 63:
        return "Hujan Sedang";
      case 65:
        return "Hujan Lebat";
      case 66:
      case 67:
        return "Hujan Beku";
      case 71:
      case 73:
      case 75:
      case 77:
        return "Hujan Salju";
      case 80:
      case 81:
      case 82:
        return "Hujan Mandi (Showers)";
      case 85:
      case 86:
        return "Hujan Salju Lebat";
      case 95:
      case 96:
      case 97:
        return "Badai Petir";
      default:
        return "Berawan";
    }
  }

  static IconData getIkonCuaca(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
      case 2:
      case 3:
        return Icons.cloud_queue_rounded;
      case 45:
      case 48:
        return Icons.waves_rounded;
      case 51:
      case 53:
      case 55:
        return Icons.cloudy_snowing;
      case 61:
      case 63:
        return Icons.water_drop_rounded;
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm_rounded;
      case 95:
      case 96:
      case 97:
        return Icons.bolt_rounded;
      default:
        return Icons.cloud_rounded;
    }
  }
}
