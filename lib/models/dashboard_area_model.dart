import 'package:frontend_seladaku/models/tandon_model.dart';

class DashboardAreaModel {
  final int idArea;
  final String namaArea;
  final int statusArea;
  final List<TandonModel> listTandon;

  DashboardAreaModel({
    required this.idArea,
    required this.namaArea,
    required this.statusArea,
    required this.listTandon,
  });

  factory DashboardAreaModel.fromJson(Map<String, dynamic> json) {
    return DashboardAreaModel(
      // PROTEKSI: Jika dari database null, kasih angka default (0 atau 1)
      idArea: json['id_area'] ?? 0,
      namaArea: json['nama_area'] ?? 'Tanpa Nama',
      statusArea: json['status_area'] ?? 1,

      // Amankan parsing list tandon jika tandon di kebun itu kosong (null)
      listTandon: json['list_tandon'] != null
          ? List<TandonModel>.from(
              (json['list_tandon'] as List)
                  .map((x) {
                    // Tambahan proteksi jika isi objek di dalam array ada yang rusak/null
                    if (x == null) return null;
                    return TandonModel.fromJson(x);
                  })
                  .where((element) => element != null), // Buang data yang null
            )
          : [],
    );
  }
}
