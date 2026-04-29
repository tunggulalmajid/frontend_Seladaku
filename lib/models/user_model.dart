class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final String? idTelegram;
  final String? nomorTelepon;
  final String? alamat;
  final String? foto;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    this.idTelegram,
    this.nomorTelepon,
    this.alamat,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      idTelegram: json['id_telegram'],
      nomorTelepon: json['nomor_telepon'],
      alamat: json['alamat'],
      foto: json['foto'],
    );
  }
}
