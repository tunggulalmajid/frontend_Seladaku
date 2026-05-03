import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class WHomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final int notificationCount;
  final VoidCallback onNotificationTap;

  const WHomeHeader({
    super.key,
    required this.userName,
    this.greeting = "Selamat datang kembali!",
    this.notificationCount = 0,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WText(
                  isi: "Hello, $userName",
                  ukuranFont: 30,
                  fw: FontWeight.bold,
                ),
                WText(isi: greeting, ukuranFont: 16, fw: FontWeight.w500),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Badge(
            label: Text(notificationCount.toString()),
            isLabelVisible: notificationCount > 0,
            backgroundColor: Colors.red,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: onNotificationTap,
                icon: Icon(
                  Icons.notifications,
                  size: 28,
                  color: AppColor.background,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
