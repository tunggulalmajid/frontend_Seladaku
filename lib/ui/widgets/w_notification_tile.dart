import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WNotificationTile extends StatelessWidget {
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;
  final VoidCallback onPressed;

  const WNotificationTile({
    super.key,
    required this.switchValue,
    required this.onSwitchChanged,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ), // Melengkung halus sesuai gambar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row Atas: Label & Switch Notifikasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WText(
                isi: "Notifikasi",
                fw: FontWeight.bold,
                ukuranFont: 18,
                color: AppColor.text,
              ),
              Transform.scale(
                scale: 1.1,
                child: Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeTrackColor: AppColor.primary,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColor.text60,
                  inactiveThumbColor: AppColor.background,
                  trackOutlineColor: WidgetStatePropertyAll(
                    AppColor.background,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Tombol Bawah: Atur Parameter dan Peringatan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColor.primary, // Warna hijau toska tema Seladaku
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: WText(
                isi: "Atur Parameter dan Peringatan",
                color: Colors.white,
                fw: FontWeight.w500,
                ukuranFont: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
