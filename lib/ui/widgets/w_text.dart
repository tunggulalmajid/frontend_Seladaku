import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class WText extends StatelessWidget {
  const WText({
    super.key,
    required this.isi,
    this.fw = FontWeight.normal, // Default: Normal
    this.color = AppColor.text, // Default: Normal
    this.ukuranFont = 18,
    this.align,
  });
  final String isi;
  final FontWeight fw;
  final Color color;
  final double ukuranFont;
  final TextAlign? align;
  @override
  Widget build(BuildContext context) {
    return Text(
      isi,
      textAlign: align ?? TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: ukuranFont,
        color: color,
        fontWeight: fw,
      ),
    );
  }
}
