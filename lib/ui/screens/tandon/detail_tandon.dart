import 'dart:developer';
import 'package:flutter/material.dart';
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
import 'package:frontend_seladaku/ui/widgets/w_button.dart'; // Dipakai lagi untuk tombol kondisional
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
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    super.dispose();
  }

  void _handleDelete(int idTandon) async {
    final tandonProv = Provider.of<TandonProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WConfirmationDeleteDialog(
        title: "Hapus Tandon?",
        message:
            "Semua riwayat dan data sensor pada tandon ini akan dihapus permanen.",
        onConfirm: () async {
          navigator.pop();

          bool sukses = await tandonProv.removeTandon(idTandon);

          if (sukses && mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (c) => WSuccessDialog(
                message: "Tandon berhasil dihapus",
                onOkPressed: () {
                  Navigator.pop(c);
                  navigator.pop();
                },
              ),
            );
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

    final currentTandon = context.watch<TandonProvider>().listTandon.firstWhere(
      (t) => t.idTandon == initialData!.idTandon,
      orElse: () => initialData!,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: const IconThemeData(color: AppColor.text),
        title: WText(
          isi: currentTandon.namaTandon,
          fw: FontWeight.bold,
          ukuranFont: 23,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.tandonCreate,
                arguments: currentTandon,
              );
            },
            icon: const Icon(Icons.edit, color: AppColor.text),
          ),
          IconButton(
            onPressed: () => _handleDelete(currentTandon.idTandon),
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

          // Boolean checker untuk mendeteksi keberadaan Device IoT
          bool isDeviceConnected =
              tandon.deviceId != null && tandon.deviceId!.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              // 1. Informasi Tandon
              WDataTandon(
                namaTandon: tandon.namaTandon,
                tanggalTanam: tandon.tanggalTanam,
              ),

              // 2. Card Status Sensor Saat Ini
              WTandonCard(namaKebun: namaArea ?? '-', tandon: tandon),

              // 3. Tile Kontrol Otomatisasi & Relay
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

              // 4. Tile Pengaturan Notifikasi
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

              const SizedBox(height: 15),

              // 5. --- LOGIKA KONDISIONAL (TOMBOL VS GRAFIK) ---
              if (!isDeviceConnected) ...[
                // JIKA BELUM ADA DEVICE: Tampilkan tombol Hubungkan Perangkat IoT
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
                // JIKA DEVICE SUDAH ADA: Tombol hilang, otomatis diganti oleh Grafik Riwayat
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(20),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: WText(
                      isi: "📈 Grafik Riwayat Sensor Aktif (pH & PPM)",
                      ukuranFont: 14,
                      color: AppColor.primary,
                      fw: FontWeight.w500,
                    ),
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
