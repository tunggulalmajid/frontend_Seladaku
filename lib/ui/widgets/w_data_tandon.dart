import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
// import 'package:frontend_ambilin/ui/widgets/w_text.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:intl/intl.dart';

class WDataTandon extends StatelessWidget {
  final String namaKebun;
  final String namaTandon;
  final DateTime tanggalTanam;

  const WDataTandon({
    super.key,
    required this.namaKebun,
    required this.namaTandon,
    required this.tanggalTanam,
  });

  @override
  Widget build(BuildContext context) {
    String tanggalFormatted = DateFormat('dd-MM-yyyy').format(tanggalTanam);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(isi: "Data Tandon", fw: .bold),
          SizedBox(height: 10),
          WText(isi: "Kebun : $namaKebun", ukuranFont: 15),
          SizedBox(height: 2),
          WText(isi: "Tandon : $namaTandon", ukuranFont: 15),
          SizedBox(height: 2),
          WText(isi: "Tanggal Tanam : $tanggalFormatted ", ukuranFont: 15),
        ],
      ),
    );
  }
}
