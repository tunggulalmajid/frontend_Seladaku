import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:frontend_ambilin/utils/app_colors.dart';

class WHeader extends StatelessWidget {
  final String judul;
  final String deskripsi;

  const WHeader({super.key, required this.judul, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WText(isi: judul, ukuranFont: 30, fw: FontWeight.bold),
                WText(isi: deskripsi, ukuranFont: 16, fw: FontWeight.w500),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
