class RiwayatGrafikModel {
  final String xLabel;
  final double ph;
  final int ppm;
  final int volume;

  RiwayatGrafikModel({
    required this.xLabel,
    required this.ph,
    required this.ppm,
    required this.volume,
  });

  factory RiwayatGrafikModel.fromJson(Map<String, dynamic> json) {
    return RiwayatGrafikModel(
      xLabel: json['x_label'] ?? '',
      ph: (json['ph'] ?? 0.0).toDouble(),
      ppm: json['ppm'] ?? 0,
      volume: json['volume'] ?? 0,
    );
  }
}

