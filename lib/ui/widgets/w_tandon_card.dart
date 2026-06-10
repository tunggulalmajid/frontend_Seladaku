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

    // --- LOGIKA BARU: DETEKSI KONDISI SIAGA MODE HUJAN 🌧️ ---
    // Pastikan properti model tandon kamu sudah memetakan 'isHujan' (bool/int) dari backend
    bool kondisiHujan = tandon.isHujan == true || tandon.isHujan == 1;
    bool isModeHujan = hasDevice && tandon.modeOtomatis && kondisiHujan;
    // -------------------------------------------------------

    // 2. Logika Warna Tombol Power (CircleAvatar)
    Color statusButtonColor;
    if (!hasDevice) {
      statusButtonColor = AppColor.text; // Abu-abu jika tidak ada device
    } else {
      final selisih = DateTime.now().difference(tandon.lastSeen!);

      // Jika device mati (> 5 menit) -> Merah, jika Mode Hujan aktif -> Biru, jika normal aktif -> Hijau
      if (selisih.inMinutes > 5) {
        statusButtonColor = AppColor.redStatus;
      } else if (isModeHujan) {
        statusButtonColor =
            Colors.blue; // FIXED: Berubah biru saat siaga otomatisasi hujan
      } else {
        statusButtonColor = AppColor.greenStatus;
      }
    }

    // 3. Logika Teks & Warna Badge Kontainer Mode
    String teksMode = "Device tidak terhubung";
    Color warnaTemaBadge = AppColor.text;
    IconData ikonBadge = Icons.link_off;

    if (hasDevice) {
      if (isModeHujan) {
        teksMode = "Mode Hujan";
        warnaTemaBadge = Colors.blue; // FIXED: Tema badge ikut berubah biru
        ikonBadge = Icons.cloudy_snowing; // Ikon cuaca hujan reaktif
      } else {
        teksMode = tandon.modeOtomatis ? "Mode Otomatis" : "Mode Manual";
        warnaTemaBadge = AppColor.primary;
        ikonBadge = Icons.wb_sunny_outlined;
      }
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
            color: Colors.black.withValues(
              alpha: 0.1,
            ), // Dikurangi ke 0.1 agar tidak terlalu pekat mengotori card figma
            blurRadius: 10,
            offset: const Offset(0, 4),
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

          // Label Mode / Koneksi Device Reaktif
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hasDevice
                  ? warnaTemaBadge.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: hasDevice
                    ? warnaTemaBadge.withValues(alpha: 0.5)
                    : AppColor.text,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(ikonBadge, color: warnaTemaBadge, size: 16),
                const SizedBox(width: 6),
                Text(
                  teksMode,
                  style: GoogleFonts.poppins(
                    color: warnaTemaBadge,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Indikator Nilai Sensor
          Row(
            children: [
              _buildIndicator(
                Icons.science_outlined,
                "pH",
                tandon.ph?.toStringAsFixed(2) ?? "0.00",
              ),
              const SizedBox(width: 10),
              _buildIndicator(
                Icons.speed_outlined,
                "PPM",
                tandon.ppm?.toStringAsFixed(0) ?? "0",
              ),
              const SizedBox(width: 10),
              _buildIndicator(
                Icons.opacity_rounded,
                "Volume",
                "${tandon.volume?.toStringAsFixed(0) ?? 0} %",
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
