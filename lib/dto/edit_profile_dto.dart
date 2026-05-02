import 'dart:io';

class EditProfileDTO {
  final String nama;
  final String email;
  final String? nomorTelepon;
  final String? alamat; // Alamat lengkap dari Geocoding
  final String? idTelegram; // Untuk alert notifikasi IoT
  final double? lat; // Koordinat latitude untuk API Cuaca
  final double? lon; // Koordinat longitude untuk API Cuaca
  final File? fotoFile; // File gambar dari ImagePicker

  EditProfileDTO({
    required this.nama,
    required this.email,
    this.nomorTelepon,
    this.alamat,
    this.idTelegram,
    this.lat,
    this.lon,
    this.fotoFile,
  });
}
