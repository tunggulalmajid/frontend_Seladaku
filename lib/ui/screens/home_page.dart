import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_seladaku/providers/auth_provider.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/ui/widgets/w_home_header.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_weather_card.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CATATAN: initState dihapus total agar tidak terjadi double fetch data saat pertama kali aplikasi dibuka.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Berjalan otomatis saat pertama kali dibuka DAN setiap kali user kembali dari halaman lain
    context.read<AreaProvider>().fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        // FITUR PULL-TO-REFRESH: Tarik layar ke bawah untuk refresh paksa data dashboard
        onRefresh: () => context.read<AreaProvider>().fetchDashboardData(),
        child: SingleChildScrollView(
          // AlwaysScrollableScrollPhysics wajib ada agar RefreshIndicator tetap aktif meskipun isi list masih sedikit/kosong
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Bagian Header Pengguna (Halo, Yanto)
              Consumer<AuthProvider>(
                builder: (context, authProv, child) {
                  String name = authProv.user != null
                      ? authProv.user!.nama.split(" ")[0]
                      : "...";
                  return WHomeHeader(
                    userName: name,
                    onNotificationTap: () {},
                    notificationCount:
                        7, // Sesuai dengan mockup Figma badge merah angka '7'
                  );
                },
              ),

              const SizedBox(height: 25),
              WWeatherCard(hasLocation: true),
              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.only(left: 17, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const WText(
                      isi: "Kebun saya",
                      fw: FontWeight.bold,
                      ukuranFont: 26,
                    ),
                  ],
                ),
              ),

              // 2. Konten Dinamis Pembungkus Kebun dan Tandon Bersarang
              Consumer<AreaProvider>(
                builder: (context, areaProv, child) {
                  // State Loading Utama
                  if (areaProv.isDashboardLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // State Jika Belum Memiliki Kebun Sama Sekali
                  if (areaProv.listDashboard.isEmpty) {
                    return WNullKebuntandon(
                      keterangan: "Belum Ada Kebun",
                      deskripsi:
                          "Mulai pantau kebun Anda dengan menambahkan area pertama ",
                      icon: Icons.add,
                    );
                  }

                  // Render Kebun Bertingkat Maksimal 3 Kebun
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: areaProv.listDashboard.length,
                    itemBuilder: (context, indexArea) {
                      final kebun = areaProv.listDashboard[indexArea];

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        // Material + InkWell dipasang agar efek ripple/splash saat ditekan terlihat rapi mengikuti lengkungan border
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              // KLIK BLOK KEBUN: Menerbangkan user ke halaman list tandon (Detail Area)
                              Navigator.pushNamed(
                                context,
                                AppRoutes.tandonIndex,
                                arguments: {
                                  "idArea": kebun.idArea,
                                  "namaArea": kebun.namaArea,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Judul Nama Kebun
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      bottom: 10,
                                    ),
                                    child: WText(
                                      isi: kebun.namaArea,
                                      fw: FontWeight.bold,
                                      ukuranFont: 22,
                                    ),
                                  ),

                                  // Validasi Jika Kebun Terdaftar Namun Belum Ditambahkan Tandon di Dalamnya
                                  if (kebun.listTandon.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: WText(
                                        isi: "Belum ada tandon di area ini",
                                        color: Colors.grey,
                                        ukuranFont: 13,
                                      ),
                                    )
                                  else
                                    // Render List Tandon Maksimal 2 Buah per Kebun
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: kebun.listTandon.length,
                                      itemBuilder: (context, indexTandon) {
                                        final tandon =
                                            kebun.listTandon[indexTandon];
                                        log(
                                          "Log sensor realtime tandon ${tandon.namaTandon} -> pH: ${tandon.ph}, PPM: ${tandon.ppm}, Vol: ${tandon.volume}",
                                        );

                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.detailTandon,
                                              arguments: {
                                                "tandon": tandon,
                                                "namaArea": kebun.namaArea,
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            // WTandonCard bawaan proyekmu tanpa perlu dimodifikasi
                                            child: WTandonCard(
                                              tandon: tandon,
                                              namaKebun: kebun.namaArea,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
