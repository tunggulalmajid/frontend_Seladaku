import 'dart:developer';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:seladaku/providers/notifikasi_provider.dart';
import 'package:seladaku/services/notifikasi_service.dart';
import 'package:seladaku/ui/screens/notif/notification_page.dart';
import 'package:seladaku/ui/screens/tandon/atur_parameter_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:seladaku/providers/area_provider.dart';
import 'package:seladaku/providers/auth_provider.dart';
import 'package:seladaku/providers/riwayat_provider.dart';
import 'package:seladaku/providers/tandon_provider.dart';
import 'package:seladaku/providers/weather_provider.dart';
import 'package:seladaku/services/area_service.dart';
import 'package:seladaku/services/auth_service.dart';
import 'package:seladaku/services/dio_interceptor.dart';
import 'package:seladaku/services/riwayat_service.dart';
import 'package:seladaku/services/tandon_service.dart';
import 'package:seladaku/ui/screens/cuaca/detail_cuaca.dart';
import 'package:seladaku/ui/screens/kebun/create_kebun.dart';
import 'package:seladaku/ui/screens/tandon/create_iot.dart';
import 'package:seladaku/ui/screens/tandon/create_tandon.dart';
import 'package:seladaku/ui/screens/tandon/detail_tandon.dart';
import 'package:seladaku/ui/screens/profile/edit_profile_page.dart';
import 'package:seladaku/ui/screens/main_page.dart';
import 'package:seladaku/ui/screens/auth/login_page.dart';
import 'package:seladaku/ui/screens/auth/register_page.dart';
import 'package:seladaku/ui/screens/splash.dart';
import 'package:seladaku/ui/screens/tandon/tandon_page.dart';
import 'package:seladaku/utils/app_routes.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("📩 [FCM Background] Notif Masuk: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  try {
    log("🔥 Memulai inisialisasi Firebase Core...");

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBwoP7tFwpmZYDTIznF2Bw-SCBKmY1vL-s",
        appId: "1:620249080867:android:721ab913112d8674253d96",
        messagingSenderId: "620249080867",
        projectId: "ppl-seladaku",
        storageBucket: "ppl-seladaku.firebasestorage.app",
      ),
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    log("✅ Firebase Engine Berhasil Dimuat Lewat Jalur Pintas!");
  } catch (e) {
    log("❌ CRITICAL ERROR FIREBASE: $e");
  }

  final authProvider = AuthProvider();
  final authService = AuthService();
  final areaProvider = AreaProvider();
  final areaService = AreaService();
  final tandonProvider = TandonProvider();
  final tandonService = TandonService();
  final riwayatProvider = RiwayatProvider();
  final riwayatService = RiwayatService();
  final weatherProvider = WeatherProvider();
  final notifikasiProvider = NotifikasiProvider();
  final notifikasiService = NotifikasiService();

  authService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: authService.dio),
  );
  areaService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: areaService.dio),
  );
  tandonService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: tandonService.dio),
  );
  riwayatService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: riwayatService.dio),
  );
  notifikasiService.addInterceptor(
    DioInterceptor(authProvider: authProvider, dio: notifikasiService.dio),
  );

  authProvider.updateService(authService);
  areaProvider.updateService(areaService);
  tandonProvider.updateService(tandonService);
  riwayatProvider.updateService(riwayatService);
  notifikasiProvider.updateService(notifikasiService);

  await authProvider.fetchUser();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('🔥 [FCM Foreground] Notif Masuk: ${message.notification?.title}');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: areaProvider),
        ChangeNotifierProvider.value(value: tandonProvider),
        ChangeNotifierProvider.value(value: riwayatProvider),
        ChangeNotifierProvider.value(value: notifikasiProvider),
        ChangeNotifierProvider(create: (_) => weatherProvider),
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
        AppRoutes.createIot: (context) => CreateIot(),
        AppRoutes.detailCuaca: (context) => DetailCuaca(),
        AppRoutes.notification: (context) => NotificationPage(),
        AppRoutes.aturParameter: (context) => AturParameterPage(),
      },
    );
  }
}
