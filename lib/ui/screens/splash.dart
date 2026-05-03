import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import 'package:frontend_seladaku/providers/auth_provider.dart'; // Tambahkan ini
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  // Buat fungsi navigasi yang lebih cerdas
  void _startNavigation() {
    Timer(const Duration(seconds: 3), () {
      // Pastikan widget masih ada di tree (tidak di-close saat timer berjalan)
      if (!mounted) return;

      // Ambil data auth dari provider
      final auth = Provider.of<AuthProvider>(context, listen: false);

      // CEK LOGIKA DI SINI:
      // Jika user ada (karena fetchUser di main.dart berhasil), ke Main.
      // Jika tidak ada, baru ke Login.
      if (auth.user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/logo_seladaku.png",
              width: 300,
              // Tambahkan errorBuilder agar tidak merah kalau file aset belum ada
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.eco, size: 100, color: Colors.white),
            ),
          ),
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
