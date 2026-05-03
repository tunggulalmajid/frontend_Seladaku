import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;

  const WButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Membuat button full width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColor.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation:
              0, // Opsional: hilangkan bayangan agar terlihat flat/modern
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: textSize ?? 20,
            color: textColor ?? AppColor.background,
          ),
        ),
      ),
    );
  }
}
