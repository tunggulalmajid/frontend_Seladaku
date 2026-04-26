import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WStatusComponent extends StatelessWidget {
  const WStatusComponent({
    super.key,
    required this.text,
    this.color = AppColor.success,
  });

  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: color,
      ),
      child: WText(
        isi: text,
        ukuranFont: 13,
        color: AppColor .primary,
        fw: .w600,
      ),
    );
  }
}
