import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WSettingTile extends StatelessWidget {
  final String title;
  final String buttonText;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;
  final VoidCallback onPressed;

  const WSettingTile({
    super.key,
    required this.title,
    required this.buttonText,
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
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WText(isi: title, fw: FontWeight.bold, ukuranFont: 18),
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeThumbColor: Colors.white,
                activeTrackColor:
                    AppColor.primary, // Sesuaikan dengan warna tema Anda
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: switchValue
                  ? onPressed
                  : null, // Disable jika switch off
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: WText(
                isi: buttonText,
                color: AppColor.text80,
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
