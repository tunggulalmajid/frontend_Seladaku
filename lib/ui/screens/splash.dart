import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seladaku/providers/auth_provider.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/utils/app_routes.dart';

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

  void _startNavigation() {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final auth = Provider.of<AuthProvider>(context, listen: false);

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
