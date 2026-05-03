import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/models/area_model.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';

class TandonPage extends StatefulWidget {
  const TandonPage({super.key});

  @override
  State<TandonPage> createState() => _TandonPageState();
}

class _TandonPageState extends State<TandonPage> {
  AreaModel? initialArea;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil arguments satu kali saja saat halaman pertama kali dibuka
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AreaModel && initialArea == null) {
      initialArea = args;
    }
  }

  // Fungsi untuk eksekusi hapus area
  void _handleDeleteArea(AreaModel area) async {
    final areaProv = Provider.of<AreaProvider>(context, listen: false);
    final navigator = Navigator.of(context); // Simpan state navigator

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WConfirmationDeleteDialog(
        title: "Hapus Kebun?",
        message:
            "Apakah Anda yakin ingin menghapus '${area.nama}'? Data tandon di dalamnya tidak dapat dikembalikan.",
        onConfirm: () async {
          Navigator.pop(context); // 1. Tutup dialog konfirmasi

          bool sukses = await areaProv.removeArea(area.idArea);

          if (sukses) {
            // 2. Tampilkan Dialog Sukses
            if (context.mounted) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (c) => WSuccessDialog(
                  message: "Kebun berhasil dihapus",
                  onOkPressed: () => Navigator.pop(c), // Tutup dialog sukses
                ),
              );

              // 3. Kembali ke halaman list kebun (KebunPage)
              navigator.pop();
            }
          } else {
            // Tampilkan dialog gagal jika error
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (c) => WFailedDialog(
                  message: "Gagal menghapus kebun. Silakan coba lagi.",
                  onOkPressed: () => Navigator.pop(c),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialArea == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),

        // MENGGUNAKAN CONSUMER AGAR JUDUL UPDATE OTOMATIS
        title: Consumer<AreaProvider>(
          builder: (context, areaProv, child) {
            // Cari data area terbaru dari list di provider
            final areaTerbaru = areaProv.areas.firstWhere(
              (a) => a.idArea == initialArea!.idArea,
              orElse: () => initialArea!,
            );

            return Row(
              mainAxisAlignment: .start,
              children: [
                WText(
                  isi: areaTerbaru.nama,
                  fw: FontWeight.bold,
                  ukuranFont: 22,
                  color: AppColor.text,
                  align: .start,
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        toolbarHeight: 70,
        actions: [
          // TOMBOL EDIT
          Consumer<AreaProvider>(
            builder: (context, areaProv, child) {
              final areaTerbaru = areaProv.areas.firstWhere(
                (a) => a.idArea == initialArea!.idArea,
                orElse: () => initialArea!,
              );
              return IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tambahKebun,
                    arguments: areaTerbaru, // Kirim data terbaru ke form edit
                  );
                },
                icon: const Icon(Icons.edit, color: AppColor.text),
              );
            },
          ),
          // TOMBOL DELETE
          Consumer<AreaProvider>(
            builder: (context, areaProv, child) {
              final areaTerbaru = areaProv.areas.firstWhere(
                (a) => a.idArea == initialArea!.idArea,
                orElse: () => initialArea!,
              );
              return IconButton(
                onPressed: () => _handleDeleteArea(areaTerbaru),
                icon: const Icon(Icons.delete, color: AppColor.redStatus),
              );
            },
          ),
        ],
      ),
      body: Consumer<AreaProvider>(
        builder: (context, areaProv, child) {
          final areaTerbaru = areaProv.areas.firstWhere(
            (a) => a.idArea == initialArea!.idArea,
            orElse: () => initialArea!,
          );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.detailTandon);
                },
                child: WTandonCard(
                  namaKebun: areaTerbaru.nama,
                  namaTandon: "Tandon 1",
                  mode: "Mode Hujan",
                  ph: 7.1,
                  ppm: 102.5,
                  volume: "202",
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.tandonCreate,
            arguments: initialArea!.idArea,
          );
        },
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          ),
          backgroundColor: const WidgetStatePropertyAll(AppColor.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: const Icon(Icons.add, color: AppColor.background, size: 35),
      ),
    );
  }
}
