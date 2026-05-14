import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend_seladaku/models/tandon_model.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:frontend_seladaku/services/socket_service.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_data_tandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_setting_tile.dart';
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

  // Fungsi pembantu untuk membatasi koma pada pH dan PPM
  String formatSensor(double? value) {
    if (value == null || value == 0.0) return "0.0";
    return value.toStringAsFixed(2);
  }

  void _sendManualAction(TandonModel tandon, String target, bool val) {
    if (tandon.deviceId == null) return;

    // Optimistic Update untuk kontrol manual individu
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: const IconThemeData(color: AppColor.text),
        title: Consumer<TandonProvider>(
          builder: (context, prov, _) {
            final tandon = prov.listTandon.firstWhere(
              (t) => t.idTandon == initialData!.idTandon,
              orElse: () => initialData!,
            );
            return WText(
              isi: tandon.namaTandon,
              fw: FontWeight.bold,
              ukuranFont: 23,
            );
          },
        ),
      ),
      body: Consumer<TandonProvider>(
        builder: (context, prov, _) {
          final tandon = prov.listTandon.firstWhere(
            (t) => t.idTandon == initialData!.idTandon,
            orElse: () => initialData!,
          );

          return ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              // Informasi Tandon
              WDataTandon(
                namaTandon: tandon.namaTandon,
                tanggalTanam: tandon.tanggalTanam,
              ),

              // Card Sensor dengan pH yang sudah diformat 2 angka di belakang koma
              WTandonCard(namaKebun: namaArea ?? '-', tandon: tandon),

              // Tile Pengaturan Aktuator
              WSettingTile(
                key: ValueKey(
                  "${tandon.idTandon}_${tandon.statusPompa}_${tandon.modeOtomatis}",
                ),
                title: "Otomatisasi",
                isAuto: tandon.modeOtomatis,
                s1Value: tandon.statusS1 == 'ON',
                s2Value: tandon.statusS2 == 'ON',
                pompaValue: tandon.statusPompa == 'ON',
                onAutoChanged: (val) {
                  if (tandon.deviceId != null) {
                    // Update lokal: Jika Auto aktif, S1 & Pompa ON, S2 OFF (Solenoid Paralon Mati)
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

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: WButton(
                  text: tandon.deviceId == null
                      ? "Hubungkan Perangkat IoT"
                      : "Ganti Perangkat IoT",
                  onPressed: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
