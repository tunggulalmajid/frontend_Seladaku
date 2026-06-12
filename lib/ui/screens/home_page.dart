import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:seladaku/providers/auth_provider.dart';
import 'package:seladaku/providers/area_provider.dart';
import 'package:seladaku/providers/notifikasi_provider.dart'; 
import 'package:seladaku/ui/widgets/w_home_header.dart';
import 'package:seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:seladaku/ui/widgets/w_tandon_card.dart';
import 'package:seladaku/ui/widgets/w_text.dart';
import 'package:seladaku/ui/widgets/w_weather_card.dart';
import 'package:seladaku/utils/app_routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        
        context.read<AreaProvider>().fetchDashboardData();
        context
            .read<NotifikasiProvider>()
            .fetchNotifikasi(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        
        onRefresh: () async {
          await Future.wait([
            context.read<AreaProvider>().fetchDashboardData(),
            context.read<NotifikasiProvider>().fetchNotifikasi(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              
              Consumer2<AuthProvider, NotifikasiProvider>(
                builder: (context, authProv, notifProv, child) {
                  String name = authProv.user != null
                      ? authProv.user!.nama.split(" ")[0]
                      : "...";

                  return WHomeHeader(
                    userName: name,
                    onNotificationTap: () {
                      
                      Navigator.pushNamed(
                        context,
                        AppRoutes.notification,
                      ); 
                    },
                    
                    notificationCount: notifProv.totalUnread,
                  );
                },
              ),

              const SizedBox(height: 25),
              const WWeatherCard(),
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

              
              Consumer<AreaProvider>(
                builder: (context, areaProv, child) {
                  if (areaProv.isDashboardLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (areaProv.listDashboard.isEmpty) {
                    return WNullKebuntandon(
                      keterangan: "Belum Ada Kebun",
                      deskripsi:
                          "Mulai pantau kebun Anda dengan menambahkan area pertama ",
                      icon: Icons.add,
                    );
                  }

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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: kebun.listTandon.length,
                                      itemBuilder: (context, indexTandon) {
                                        final tandon =
                                            kebun.listTandon[indexTandon];
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
