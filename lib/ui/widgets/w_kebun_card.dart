import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_status_component.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WKebunCard extends StatelessWidget {
  final String namaKebun;
  final int jumlahTandon;
  final bool isAktif;

  const WKebunCard({
    super.key,
    required this.namaKebun,
    this.jumlahTandon = 0,
    this.isAktif = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor.primary, width: 0.5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color(0xFFE0F2F1),
            ),
            child: Icon(Icons.air, size: 30),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                WText(isi: namaKebun, align: .start, ukuranFont: 18, fw: .bold),
                WText(
                  isi: "$jumlahTandon Tandon",
                  align: TextAlign.start,
                  ukuranFont: 14,
                ),
              ],
            ),
          ),
          WStatusComponent(text: "Aktif"),
        ],
      ),
    );
  }
}
