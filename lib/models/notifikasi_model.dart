class NotifikasiModel {
  final int idNotifikasi;
  final int? idTandon;
  final String judul;
  final String pesan;
  final String tipe; 
  bool isRead;
  final DateTime createdAt;

  NotifikasiModel({
    required this.idNotifikasi,
    this.idTandon,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.isRead,
    required this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      idNotifikasi: json['id_notifikasi'] ?? json['id'] ?? 0,
      idTandon: json['id_tandon'],
      judul: json['judul'] ?? json['tipe'],
      pesan: json['pesan'] ?? '',
      tipe: json['tipe'] ?? 'INFO',
      
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
