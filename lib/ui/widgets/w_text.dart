import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class WText extends StatelessWidget {
  const WText({
    super.key,
    required this.isi,
    this.fw = FontWeight.normal, // Default: Normal
    this.ukuranFont = 18,
    this.style,
  });
  final String isi;
  final FontWeight fw;
  final double ukuranFont;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Text(
      isi,
      style: GoogleFonts.poppins(
        fontSize: ukuranFont,
        color: AppColor.text,
        fontWeight: fw,
      ),
    );
  }
}
