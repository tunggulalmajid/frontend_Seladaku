import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:seladaku/providers/tandon_provider.dart';
import 'package:provider/provider.dart';
import 'package:seladaku/providers/area_provider.dart';
import 'package:seladaku/models/area_model.dart';
import 'package:seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:seladaku/ui/widgets/w_success_dialog.dart';
import 'package:seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:seladaku/ui/widgets/w_tandon_card.dart';
import 'package:seladaku/ui/widgets/w_text.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/utils/app_routes.dart';

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
          
          Navigator.pop(dialogCtx);

          
          bool sukses = await areaProv.removeArea(area.idArea);

          if (sukses && mounted) {
            
            
            Navigator.pop(context);

            
            await areaProv.fetchAreas();

            
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (successCtx) => WSuccessDialog(
                  message: "Kebun berhasil dihapus",
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

  @override
  Widget build(BuildContext context) {
    if (initialArea == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    
    final areaTerbaru = context.watch<AreaProvider>().areas.firstWhere(
      (a) => a.idArea == initialArea!.idArea,
      orElse: () => initialArea!,
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        toolbarHeight: 75,
        title: WText(
          isi: areaTerbaru.nama, 
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
                            .nama, 
                      },
                    );
                  },
                  child: WTandonCard(
                    namaKebun: areaTerbaru.nama, 
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
