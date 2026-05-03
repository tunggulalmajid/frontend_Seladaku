class AreaModel {
  final int idArea;
  final String nama;
  final bool status;
  final int totalTandon;
  final DateTime? createdAt;

  AreaModel({
    required this.idArea,
    required this.nama,
    required this.status,
    this.totalTandon = 0,
    this.createdAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      idArea: json['id_area'],
      nama: json['nama'] ?? '',
      // Konversi status: MySQL (int 1/0) ke Flutter (bool)
      status: json['status'] is int
          ? json['status'] == 1
          : (json['status'] ?? true),
      totalTandon: json['total_tandon'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
