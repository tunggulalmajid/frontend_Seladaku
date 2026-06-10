import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/area_model.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/providers/riwayat_provider.dart';
import 'package:frontend_seladaku/ui/widgets/w_sensor_chart.dart';
import 'package:frontend_seladaku/ui/widgets/w_notification_tile.dart';
import 'package:provider/provider.dart';

import 'package:frontend_seladaku/models/tandon_model.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:frontend_seladaku/services/socket_service.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_data_tandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_setting_tile.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';

class DetailTandon extends StatefulWidget {
  const DetailTandon({super.key});

  @override
  State<DetailTandon> createState() => _DetailTandonState();
}

class _DetailTandonState extends State<DetailTandon> {
  final SocketService _socketService = SocketService();
  TandonModel? initialData;
  String? namaArea;

  RiwayatProvider? _riwayatProvider;

  @override
  void initState() {
    super.initState();
    _socketService.connect();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialData != null) {
        _socketService.listenToSensor(initialData!.idTandon, (data) {
          if (mounted) {
            context.read<TandonProvider>().updateTandonFromSocket(
              initialData!.idTandon,
              data,
            );
          }
        });

        context.read<RiwayatProvider>().fetchRiwayatGrafik(
          initialData!.idTandon,
          "harian",
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _riwayatProvider = Provider.of<RiwayatProvider>(context, listen: false);

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && initialData == null) {
      setState(() {
        initialData = args["tandon"];
        namaArea = args["namaArea"];
      });
    }
  }

  @override
  void dispose() {
    if (initialData != null) {
      _socketService.stopListening(initialData!.idTandon);
    }
    _socketService.dispose();

    _riwayatProvider?.clearData();

    super.dispose();
  }

  void _handleDelete(int idTandon) async {
    final tandonProv = Provider.of<TandonProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => WConfirmationDeleteDialog(
        title: "Hapus Tandon?",
        message:
            "Semua riwayat dan data sensor pada tandon ini akan dihapus permanen.",
        onConfirm: () async {
          Navigator.pop(dialogCtx);

          bool sukses = await tandonProv.removeTandon(idTandon);

          if (sukses && mounted) {
            Navigator.pop(context);

            if (initialData != null) {
              await tandonProv.getTandonByArea(initialData!.idArea);
            }

            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (successCtx) => WSuccessDialog(
                  message: "Tandon berhasil dihapus",
                  onOkPressed: () {
                    Navigator.pop(successCtx);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _sendManualAction(TandonModel tandon, String target, bool val) {
    if (tandon.deviceId == null) return;

    context.read<TandonProvider>().updateTandonFromSocket(tandon.idTandon, {
      if (target == "s1") 'status_s1': val ? 'ON' : 'OFF',
      if (target == "s2") 'status_s2': val ? 'ON' : 'OFF',
      if (target == "pompa") 'status_pompa': val ? 'ON' : 'OFF',
    });

    _socketService.sendControl(
      deviceId: tandon.deviceId!,
      target: target,
      command: val ? "on" : "off",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    String namaAreaTerbaru = namaArea ?? '-';
    try {
      final areaProv = context.watch<AreaProvider>();
      if (initialData != null) {
        final kebunCocok = areaProv.areas.firstWhere(
          (a) => a.nama == namaArea || a.idArea == initialData!.idArea,
          orElse: () => AreaModel(
            idArea: 0,
            nama: namaArea ?? '-',
            status: true,
            totalTandon: 0,
          ),
        );
        namaAreaTerbaru = kebunCocok.nama;
      }
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: const IconThemeData(color: AppColor.text),
        title: Consumer<TandonProvider>(
          builder: (context, prov, _) {
            final currentTandon = prov.listTandon.firstWhere(
              (t) => t.idTandon == initialData!.idTandon,
              orElse: () => initialData!,
            );
            return WText(
              isi: currentTandon.namaTandon,
              fw: FontWeight.bold,
              ukuranFont: 23,
            );
          },
        ),
        actions: [
          Consumer<TandonProvider>(
            builder: (context, prov, _) {
              final currentTandon = prov.listTandon.firstWhere(
                (t) => t.idTandon == initialData!.idTandon,
                orElse: () => initialData!,
              );
              return IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tandonCreate,
                    arguments: currentTandon,
                  );
                },
                icon: const Icon(Icons.edit, color: AppColor.text),
              );
            },
          ),
          IconButton(
            onPressed: () => _handleDelete(initialData!.idTandon),
            icon: const Icon(Icons.delete, color: AppColor.redStatus),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<TandonProvider>(
        builder: (context, prov, _) {
          final tandon = prov.listTandon.firstWhere(
            (t) => t.idTandon == initialData!.idTandon,
            orElse: () => initialData!,
          );

          bool isDeviceConnected =
              tandon.deviceId != null && tandon.deviceId!.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              WDataTandon(
                namaTandon: tandon.namaTandon,
                tanggalTanam: tandon.tanggalTanam,
              ),
              WTandonCard(namaKebun: namaAreaTerbaru, tandon: tandon),
              WSettingTile(
                key: ValueKey(
                  "${tandon.idTandon}_${tandon.statusPompa}_${tandon.modeOtomatis}_${tandon.statusS1}_${tandon.statusS2}",
                ),
                title: "Otomatisasi",
                isAuto: tandon.modeOtomatis,
                s1Value: tandon.statusS1 == 'ON',
                s2Value: tandon.statusS2 == 'ON',
                pompaValue: tandon.statusPompa == 'ON',
                onAutoChanged: (val) {
                  if (tandon.deviceId != null) {
                    prov.updateTandonFromSocket(tandon.idTandon, {
                      'mode_otomatis': val ? 1 : 0,
                      if (val) ...{
                        'status_s1': 'ON',
                        'status_s2': 'OFF',
                        'status_pompa': 'ON',
                      },
                    });

                    _socketService.sendControl(
                      deviceId: tandon.deviceId!,
                      target: "mode",
                      command: val ? "auto" : "manual",
                    );
                  }
                },
                onManualControl: (target, val) {
                  _sendManualAction(tandon, target, val);
                },
              ),
              WNotificationTile(
                switchValue: tandon.isNotifAktif,
                onSwitchChanged: (value) {
                  prov.updateTandonFromSocket(tandon.idTandon, {
                    'is_notif_aktif': value,
                  });
                  prov.updateTandon(tandon.idTandon, {
                    'is_notif_aktif': value ? 1 : 0,
                  });
                },
                onPressed: () {
                  log("Membuka pengaturan parameter threshold");
                },
              ),
              const SizedBox(height: 5),
              if (!isDeviceConnected) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: WButton(
                    text: "Hubungkan Perangkat IoT",
                    textSize: 15,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.createIot,
                        arguments: {
                          "idTandon": tandon.idTandon,
                          "tandon": null,
                        },
                      );
                    },
                  ),
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Consumer<RiwayatProvider>(
                    builder: (context, riwayatProv, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const WText(
                                isi: "Riwayat Sensor",
                                fw: FontWeight.bold,
                                ukuranFont: 19,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    children: ["harian", "mingguan", "bulanan"]
                                        .map((rangeType) {
                                          bool isSelected =
                                              riwayatProv.activeRange ==
                                              rangeType;
                                          return GestureDetector(
                                            onTap: () =>
                                                riwayatProv.fetchRiwayatGrafik(
                                                  tandon.idTandon,
                                                  rangeType,
                                                ),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                left: 6,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColor.primary
                                                    : Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: WText(
                                                isi: rangeType == "harian"
                                                    ? "Harian"
                                                    : (rangeType == "mingguan"
                                                          ? "Mingguan"
                                                          : "Bulanan"),
                                                ukuranFont: 11,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.grey.shade600,
                                                fw: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          if (riwayatProv.isLoading)
                            const SizedBox(
                              height: 250,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else ...[
                            const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 8,
                                ),
                                SizedBox(width: 6),
                                WText(
                                  isi: "Grafik pH",
                                  fw: FontWeight.bold,
                                  ukuranFont: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: WSensorChart(
                                data: riwayatProv.listDataGrafik,
                                jenisSensor: "ph",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(
                                color: Color(0xFFF5F5F5),
                                thickness: 1,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Color(0xFFFFB800),
                                  size: 8,
                                ),
                                SizedBox(width: 6),
                                WText(
                                  isi: "Grafik PPM",
                                  fw: FontWeight.bold,
                                  ukuranFont: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: WSensorChart(
                                data: riwayatProv.listDataGrafik,
                                jenisSensor: "ppm",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(
                                color: Color(0xFFF5F5F5),
                                thickness: 1,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.circle, color: Colors.blue, size: 8),
                                SizedBox(width: 6),
                                WText(
                                  isi: "Grafik Volume Air",
                                  fw: FontWeight.bold,
                                  ukuranFont: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: WSensorChart(
                                data: riwayatProv.listDataGrafik,
                                jenisSensor: "volume",
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
