class WeatherModel {
  final String namaKota;
  final double currentTemp;
  final int currentConditionCode;
  final double maxTemp;
  final double minTemp;
  final List<DailyForecast> forecast;

  WeatherModel({
    required this.namaKota,
    required this.currentTemp,
    required this.currentConditionCode,
    required this.maxTemp,
    required this.minTemp,
    required this.forecast,
  });

  factory WeatherModel.fromJson(String kota, Map<String, dynamic> json) {
    final current = json['current'];
    final daily = json['daily'];

    List<DailyForecast> tempForecast = [];
    for (int i = 0; i < (daily['time'] as List).length; i++) {
      tempForecast.add(
        DailyForecast(
          tanggal: daily['time'][i],
          conditionCode: daily['weather_code'][i],

          maxTemp: (daily['temperature_2m_max'][i] as num).toDouble(),
          minTemp: (daily['temperature_2m_min'][i] as num).toDouble(),
        ),
      );
    }

    return WeatherModel(
      namaKota: kota,
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      currentConditionCode: current['weather_code'] as int,
      maxTemp: (daily['temperature_2m_max'][0] as num).toDouble(),
      minTemp: (daily['temperature_2m_min'][0] as num).toDouble(),
      forecast: tempForecast,
    );
  }
}

class DailyForecast {
  final String tanggal;
  final int conditionCode;

  final double maxTemp;
  final double minTemp;

  DailyForecast({
    required this.tanggal,
    required this.conditionCode,
    required this.maxTemp,
    required this.minTemp,
  });
}
