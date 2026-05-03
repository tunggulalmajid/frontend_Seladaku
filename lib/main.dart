import 'dart:developer';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/providers/auth_provider.dart';
import 'package:frontend_seladaku/services/area_service.dart';
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

  // 1. Inisialisasi semua objek
  final authProvider = AuthProvider();
  final authService = AuthService();
  final areaProvider = AreaProvider();
  final areaService = AreaService();

  // 2. Pasang Interceptor ke masing-masing Dio instance
  // AreaService juga wajib dipasangi agar bisa mengakses endpoint privat /area
  authService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: authService.dio),
  );
  areaService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: areaService.dio),
  );

  // 3. Hubungkan Service ke Provider masing-masing
  authProvider.updateService(authService);
  areaProvider.updateService(areaService);

  // 4. Cek login user
  await authProvider.fetchUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: areaProvider), // Daftar di sini
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
