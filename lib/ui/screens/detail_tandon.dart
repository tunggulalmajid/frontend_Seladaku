import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/tandon_model.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_data_tandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_setting_tile.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';
import 'package:provider/provider.dart';

class DetailTandon extends StatefulWidget {
  const DetailTandon({super.key});

  @override
  State<DetailTandon> createState() => _DetailTandonState();
}

class _DetailTandonState extends State<DetailTandon> {
  TandonModel? initialData;
  String? namaArea;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic> && initialData == null) {
      setState(() {
        initialData = args["tandon"];
        namaArea = args["namaArea"];
      });

      log("$initialData");
    }
  }

  void _toggleSetting(int id, String key, bool value) async {
    final tandonProv = Provider.of<TandonProvider>(context, listen: false);

    await tandonProv.updateTandon(id, {key: value ? 1 : 0});
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
              color: AppColor.text,
            );
          },
        ),
        actions: [
          Consumer<TandonProvider>(
            builder: (context, prov, _) {
              final tandonTerbaru = prov.listTandon.firstWhere(
                (t) => t.idTandon == initialData!.idTandon,
                orElse: () => initialData!,
              );

              return IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tandonCreate,
                    arguments: tandonTerbaru,
                  );
                },
                icon: const Icon(Icons.edit),
              );
            },
          ),
          IconButton(
            onPressed: () => _handleDelete(initialData!.idTandon),
            icon: const Icon(Icons.delete, color: AppColor.redStatus),
          ),
        ],
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
              WDataTandon(
                namaTandon: tandon.namaTandon,
                tanggalTanam: tandon.tanggalTanam,
              ),
              WTandonCard(namaKebun: namaArea ?? '-', tandon: tandon),

              WSettingTile(
                title: "Otomatisasi",
                buttonText: "Kendali Manual Pompa",
                switchValue: tandon.modeOtomatis,
                onSwitchChanged: (value) =>
                    _toggleSetting(tandon.idTandon, "mode_otomatis", value),
                onPressed: () {},
              ),

              WSettingTile(
                title: "Notifikasi",
                buttonText: "Atur Parameter & Peringatan",
                switchValue: tandon.isNotifAktif,
                onSwitchChanged: (value) =>
                    _toggleSetting(tandon.idTandon, "is_notif_aktif", value),
                onPressed: () {},
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: WButton(
                  text: tandon.deviceId == null
                      ? "Hubungkan Perangkat IoT"
                      : "Ganti Perangkat IoT",
                  textSize: 14,
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
