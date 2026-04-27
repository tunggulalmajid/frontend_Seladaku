import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WFailedDialog extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  const WFailedDialog({
    super.key,
    required this.message,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Sesuai konten
          children: [
            // Icon Berhasil (Circle dengan Check)
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color:
                    AppColor.redLightStatus, // Latar belakang lingkaran tipis
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColor.redStatus,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gagal!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            // Tombol OK
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.redStatus,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: onOkPressed,
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
