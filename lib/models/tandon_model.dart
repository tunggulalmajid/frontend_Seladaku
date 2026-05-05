class TandonModel {
  final int idTandon;
  final String namaTandon;
  final DateTime tanggalTanam;
  final int idArea;
  final String? deviceId;
  final bool modeOtomatis;
  final bool isNotifAktif;
  final String statusS1;
  final String statusS2;
  final String statusPompa;
  final double minPh;
  final double maxPh;
  final double minPpm;
  final double maxPpm;
  final double minVolume;
  final DateTime? lastSeen;
  final double? ph;
  final double? ppm;
  final double? volume;
  final bool? isHujan;

  TandonModel({
    required this.idTandon,
    required this.namaTandon,
    required this.tanggalTanam,
    this.deviceId,
    required this.modeOtomatis,
    required this.isNotifAktif,
    required this.statusS1,
    required this.statusS2,
    required this.statusPompa,
    required this.minPh,
    required this.maxPh,
    required this.minPpm,
    required this.maxPpm,
    required this.minVolume,
    this.lastSeen,
    this.ph,
    this.ppm,
    this.volume,
    this.isHujan,
    required this.idArea,
  });

  factory TandonModel.fromJson(Map<String, dynamic> json) {
    // Fungsi bantuan sakti agar int/double tidak error
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }

    bool toBool(dynamic value) => value == 1 || value == true;

    return TandonModel(
      idTandon: json['id_tandon'],
      namaTandon: json['nama_tandon'] ?? '',
      // Gunakan TryParse untuk tanggal agar lebih aman
      tanggalTanam: json['tanggal_tanam'] != null
          ? DateTime.parse(json['tanggal_tanam'].toString())
                .toLocal() // Tambahkan .toLocal()
          : DateTime.now(),
      idArea: json['id_area'],
      deviceId: json['device_id'],
      modeOtomatis: toBool(json['mode_otomatis']),
      isNotifAktif: toBool(json['is_notif_aktif']),
      statusS1: json['status_s1'] ?? 'OFF',
      statusS2: json['status_s2'] ?? 'OFF',
      statusPompa: json['status_pompa'] ?? 'OFF',
      // Gunakan toDouble untuk semua parameter ini
      minPh: toDouble(json['min_ph']),
      maxPh: toDouble(json['max_ph']),
      minPpm: toDouble(json['min_ppm']), // JSON kirim int 450
      maxPpm: toDouble(json['max_ppm']), // JSON kirim int 850
      minVolume: toDouble(json['min_volume']),
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null,
      ph: json['ph'] != null ? toDouble(json['ph']) : null,
      ppm: json['ppm'] != null ? toDouble(json['ppm']) : null,
      volume: json['volume_air'] != null ? toDouble(json['volume_air']) : null,
      isHujan: json['is_hujan'] != null ? toBool(json['is_hujan']) : null,
    );
  }
}
