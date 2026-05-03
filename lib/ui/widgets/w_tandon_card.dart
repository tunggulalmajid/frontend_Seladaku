import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WTandonCard extends StatelessWidget {
  final String namaKebun;
  final String namaTandon;
  final String mode;
  final double ph;
  final double ppm;
  final String volume;

  const WTandonCard({
    super.key,
    required this.namaKebun,
    required this.namaTandon,
    required this.mode,
    required this.ph,
    required this.ppm,
    required this.volume,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  WText(
                    isi: namaKebun,
                    fw: FontWeight.w400,
                    ukuranFont: 14,
                    align: .start,
                  ),
                  WText(isi: namaTandon, fw: FontWeight.bold, ukuranFont: 24),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  backgroundColor: AppColor.greenStatus,
                  child: Icon(
                    Icons.power_settings_new,
                    color: AppColor.background,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColor.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColor.primary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: AppColor.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  mode,
                  style: GoogleFonts.poppins(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              _buildIndicator(Icons.science_outlined, "pH", "$ph"),
              const SizedBox(width: 10),
              _buildIndicator(Icons.speed_outlined, "PPM", "$ppm"),
              const SizedBox(width: 10),
              _buildIndicator(Icons.opacity_rounded, "Volume", volume),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColor.primary, size: 16),
                const SizedBox(width: 4),
                WText(isi: label, fw: FontWeight.normal, ukuranFont: 11),
              ],
            ),
            const SizedBox(height: 8),
            WText(isi: value, ukuranFont: 20, fw: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}
