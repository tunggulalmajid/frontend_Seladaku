import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WSettingTile extends StatelessWidget {
  final String title;
  final bool isAuto; // Nilai Otomatisasi
  final ValueChanged<bool> onAutoChanged;

  // Status Aktuator
  final bool s1Value;
  final bool s2Value;
  final bool pompaValue;

  // Callback untuk kontrol manual
  final Function(String target, bool value) onManualControl;

  const WSettingTile({
    super.key,
    required this.title,
    required this.isAuto,
    required this.onAutoChanged,
    required this.s1Value,
    required this.s2Value,
    required this.pompaValue,
    required this.onManualControl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Utama: Otomatisasi
          _buildSwitchRow(
            label: title,
            value: isAuto,
            onChanged: onAutoChanged,
            isBold: true,
          ),
          const SizedBox(height: 10),

          // Daftar Aktuator Manual (Read-only jika isAuto == true)
          _buildSwitchRow(
            label: "Solenoid Tandon",
            value: s1Value,
            onChanged: isAuto ? null : (val) => onManualControl("s1", val),
          ),
          _buildSwitchRow(
            label: "Solenoid Paralon",
            value: s2Value,
            onChanged: isAuto ? null : (val) => onManualControl("s2", val),
          ),
          _buildSwitchRow(
            label: "Pompa",
            value: pompaValue,
            onChanged: isAuto ? null : (val) => onManualControl("pompa", val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WText(
            isi: label,
            fw: isBold ? FontWeight.bold : FontWeight.w400,
            ukuranFont: 17,
            color: AppColor.text,
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColor.primary,
              activeThumbColor: Colors.white,
              inactiveTrackColor: AppColor.text60,
              inactiveThumbColor: AppColor.background,
              trackOutlineColor: WidgetStatePropertyAll(AppColor.background),
            ),
          ),
        ],
      ),
    );
  }
}
