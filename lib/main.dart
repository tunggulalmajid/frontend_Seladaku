import 'dart:developer';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_seladaku/providers/auth_provider.dart';
import 'package:frontend_seladaku/services/auth_service.dart';
import 'package:frontend_seladaku/services/dio_interceptor.dart';
import 'package:frontend_seladaku/ui/screens/create_kebun.dart';
import 'package:frontend_seladaku/ui/screens/create_tandon.dart';
import 'package:frontend_seladaku/ui/screens/detail_tandon.dart';
import 'package:frontend_seladaku/ui/screens/edit_profile_page.dart';
import 'package:frontend_seladaku/ui/screens/main_page.dart';
import 'package:frontend_seladaku/ui/screens/login_page.dart';
import 'package:frontend_seladaku/ui/screens/register_page.dart';
import 'package:frontend_seladaku/ui/screens/splash.dart';
import 'package:frontend_seladaku/ui/screens/tandon_page.dart';

import 'package:frontend_seladaku/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Buat Provider & Service secara terpisah
  final authProvider = AuthProvider();
  final authService = AuthService();

  // 2. PASANG INTERCEPTOR KE SERVICE
  // Ini kunci utamanya. Kita pasang ke dio milik authService.
  authService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: authService.dio),
  );

  // 3. SUNTIKKAN SERVICE YANG SUDAH BER-INTERCEPTOR KE PROVIDER
  authProvider.updateService(authService);

  // 4. Baru jalankan fetchUser
  await authProvider.fetchUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        Provider.value(value: authService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seladaku',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.register: (context) => RegisterPage(),
        AppRoutes.editProfile: (context) => EditProfilePage(),
        AppRoutes.main: (context) => MainPage(),
        AppRoutes.tambahKebun: (context) => CreateKebun(),
        AppRoutes.tandonIndex: (context) => TandonPage(),
        AppRoutes.tandonCreate: (context) => CreateTandon(),
        AppRoutes.detailTandon: (context) => DetailTandon(),
      },
    );
  }
}
