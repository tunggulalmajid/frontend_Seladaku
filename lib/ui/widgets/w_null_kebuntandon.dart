import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WNullKebuntandon extends StatelessWidget {
  final String keterangan;
  final String deskripsi;
  final IconData icon;

  const WNullKebuntandon({
    super.key,
    required this.keterangan,
    required this.deskripsi,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(1, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFE0F2F1),
              radius: 40,
              child: Icon(icon, color: AppColor.primary, size: 40),
            ),
            SizedBox(height: 30),
            WText(isi: keterangan, fw: .w600, ukuranFont: 20),
            SizedBox(height: 10),
            WText(isi: deskripsi, fw: .w300, ukuranFont: 12),
          ],
        ),
      ),
    );
  }
}
