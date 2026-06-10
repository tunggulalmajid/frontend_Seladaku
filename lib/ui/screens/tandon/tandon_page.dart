import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/models/area_model.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
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
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && initialArea == null) {
        if (args is Map<String, dynamic>) {
          setState(() {
            initialArea = AreaModel(
              idArea: args['idArea'],
              nama: args['namaArea'],
              status: true,
              totalTandon: 0,
            );
          });
        } else if (args is AreaModel) {
          setState(() {
            initialArea = args;
          });
        }

        if (initialArea != null) {
          Future.microtask(() {
            if (mounted) {
              context.read<TandonProvider>().getTandonByArea(
                initialArea!.idArea,
              );
            }
          });
        }
      }
    } catch (e) {
      log("Error didChangeDependencies tandon page : $e");
    }
  }

  void _handleDeleteArea(AreaModel area) async {
    final areaProv = Provider.of<AreaProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => WConfirmationDeleteDialog(
        title: "Hapus Kebun?",
        message:
            "Apakah Anda yakin ingin menghapus '${area.nama}'? Data tandon di dalamnya akan ikut terhapus.",
        onConfirm: () async {
          // 1. Tutup dialog konfirmasi terlebih dahulu
          Navigator.pop(dialogCtx);

          // 2. Jalankan aksi hapus ke backend Express
          bool sukses = await areaProv.removeArea(area.idArea);

          if (sukses && mounted) {
            // 3. SEGERA KELUAR dari TandonPage ke KebunPage sebelum data ditarik ulang!
            // Ini trik mendasar agar user tidak melihat penampakan data lama di latar belakang
            Navigator.pop(context);

            // 4. Tarik data terbaru di latar belakang KebunPage
            await areaProv.fetchAreas();

            // 5. Tampilkan dialog sukses menggunakan konteks global yang aman di KebunPage
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (successCtx) => WSuccessDialog(
                  message: "Kebun berhasil dihapus",
                  onOkPressed: () {
                    Navigator.pop(successCtx); // Tutup dialog sukses murni
                  },
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

    // Amankan data kebun reaktif agar selalu membaca perubahan nama ter-update dari AreaProvider global
    final areaTerbaru = context.watch<AreaProvider>().areas.firstWhere(
      (a) => a.idArea == initialArea!.idArea,
      orElse: () => initialArea!,
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        toolbarHeight: 75,
        title: WText(
          isi: areaTerbaru.nama, // FIXED: Reaktif membaca data ter-update
          fw: FontWeight.bold,
          ukuranFont: 23,
          color: AppColor.text,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.tambahKebun,
              arguments: areaTerbaru,
            ),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _handleDeleteArea(areaTerbaru),
            icon: const Icon(Icons.delete, color: AppColor.redStatus),
          ),
        ],
      ),
      body: Consumer<TandonProvider>(
        builder: (context, tandonProv, child) {
          if (tandonProv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tandonProv.listTandon.isEmpty) {
            return const Column(
              children: [
                WNullKebuntandon(
                  keterangan: "Tandon Kosong",
                  deskripsi:
                      "Belum ada tandon di kebun ini. Tambahkan tandon untuk mulai memantau.",
                  icon: Icons.opacity,
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () => tandonProv.getTandonByArea(areaTerbaru.idArea),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              itemCount: tandonProv.listTandon.length,
              itemBuilder: (context, index) {
                final tandon = tandonProv.listTandon[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailTandon,
                      arguments: {
                        "tandon": tandon,
                        "namaArea": areaTerbaru
                            .nama, // FIXED: Mengirim nama kebun ter-update
                      },
                    );
                  },
                  child: WTandonCard(
                    namaKebun: areaTerbaru.nama, // FIXED: Reaktif sinkron
                    tandon: tandon,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.tandonCreate,
            arguments: areaTerbaru.idArea,
          );
        },
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 17, vertical: 17),
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
