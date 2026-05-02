class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final String? nomorTelepon;
  final String? alamat;
  final String? foto; // URL dari Cloudinary
  final String? idTelegram; // ID Numerik buat bot
  final double? latitude; // Untuk API Cuaca
  final double? longitude; // Untuk API Cuaca

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    this.nomorTelepon,
    this.alamat,
    this.foto,
    this.idTelegram,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? "",
      email: json['email'] ?? "",
      nomorTelepon: json['nomor_telepon'],
      alamat: json['alamat'],
      foto: json['foto'],
      idTelegram: json['id_telegram'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id_user": idUser,
      "nama": nama,
      "email": email,
      "nomor_telepon": nomorTelepon,
      "alamat": alamat,
      "foto": foto,
      "id_telegram": idTelegram,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
