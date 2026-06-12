import 'package:seladaku/models/tandon_model.dart';

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
      
      idArea: json['id_area'] ?? 0,
      namaArea: json['nama_area'] ?? 'Tanpa Nama',
      statusArea: json['status_area'] ?? 1,

      
      listTandon: json['list_tandon'] != null
          ? List<TandonModel>.from(
              (json['list_tandon'] as List)
                  .map((x) {
                    
                    if (x == null) return null;
                    return TandonModel.fromJson(x);
                  })
                  .where((element) => element != null), 
            )
          : [],
    );
  }
}
