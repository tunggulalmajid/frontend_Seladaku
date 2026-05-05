import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/tandon_model.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WTandonCard extends StatelessWidget {
  final TandonModel tandon;
  final String namaKebun;

  const WTandonCard({super.key, required this.tandon, required this.namaKebun});

  @override
  Widget build(BuildContext context) {
    // 1. Cek apakah ada device terhubung
    bool hasDevice = tandon.deviceId != null && tandon.deviceId!.isNotEmpty;

    // 2. Logika Warna Tombol Power (CircleAvatar)
    Color statusButtonColor;
    if (!hasDevice) {
      statusButtonColor =
          AppColor.text; // Abu-abu/Standar jika tidak ada device
    } else {
      // Hijau jika status sensor ON, Merah jika OFF
      statusButtonColor = (tandon.statusPompa == "ON")
          ? AppColor.greenStatus
          : AppColor.redStatus;
    }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WText(
                    isi: namaKebun,
                    fw: FontWeight.w400,
                    ukuranFont: 14,
                    align: TextAlign.start,
                  ),
                  WText(
                    isi: tandon.namaTandon,
                    fw: FontWeight.bold,
                    ukuranFont: 24,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: statusButtonColor,
                child: Icon(
                  Icons.power_settings_new,
                  color: AppColor.background,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Label Mode / Koneksi Device
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hasDevice
                  ? AppColor.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: hasDevice
                    ? AppColor.primary.withValues(alpha: 0.5)
                    : AppColor.text,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasDevice ? Icons.wb_sunny_outlined : Icons.link_off,
                  color: hasDevice ? AppColor.primary : AppColor.text,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  hasDevice
                      ? (tandon.modeOtomatis ? "Mode Otomatis" : "Mode Manual")
                      : "Device tidak terhubung",
                  style: GoogleFonts.poppins(
                    color: hasDevice ? AppColor.primary : AppColor.text,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Indikator Sensor
          Row(
            children: [
              _buildIndicator(
                Icons.science_outlined,
                "pH",
                "${tandon.ph ?? 0.0}",
              ),
              const SizedBox(width: 10),
              _buildIndicator(
                Icons.speed_outlined,
                "PPM",
                "${tandon.ppm ?? 0.0}",
              ),
              const SizedBox(width: 10),
              _buildIndicator(
                Icons.opacity_rounded,
                "Volume",
                "${tandon.volume?.toStringAsFixed(1) ?? "0"}",
              ),
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
