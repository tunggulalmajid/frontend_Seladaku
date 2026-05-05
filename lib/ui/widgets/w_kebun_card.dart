import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_status_component.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WKebunCard extends StatelessWidget {
  final String namaKebun;
  final int jumlahTandon;

  const WKebunCard({super.key, required this.namaKebun, this.jumlahTandon = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: AppColor.primaryAccent,
            ),
            child: Icon(Icons.grass_sharp, size: 30, color: AppColor.primary),
          ),
          SizedBox(width: 15),
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
        ],
      ),
    );
  }
}
