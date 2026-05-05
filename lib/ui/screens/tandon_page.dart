import 'package:flutter/material.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AreaModel && initialArea == null) {
      initialArea = args;

      Future.microtask(() {
        if (mounted) {
          context.read<TandonProvider>().getTandonByArea(initialArea!.idArea);
        }
      });
    }
  }

  void _handleDeleteArea(AreaModel area) async {
    final areaProv = Provider.of<AreaProvider>(context, listen: false);

    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WConfirmationDeleteDialog(
        title: "Hapus Kebun?",
        message:
            "Apakah Anda yakin ingin menghapus '${area.nama}'? Data tandon di dalamnya akan ikut terhapus.",
        onConfirm: () async {
          navigator.pop();

          bool sukses = await areaProv.removeArea(area.idArea);
          if (sukses && mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (c) => WSuccessDialog(
                message: "Kebun berhasil dihapus",
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
    if (initialArea == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        toolbarHeight: 75,
        title: Consumer<AreaProvider>(
          builder: (context, areaProv, child) {
            final areaTerbaru = areaProv.areas.firstWhere(
              (a) => a.idArea == initialArea!.idArea,
              orElse: () => initialArea!,
            );
            return WText(
              isi: areaTerbaru.nama,
              fw: FontWeight.bold,
              ukuranFont: 23,
              color: AppColor.text,
            );
          },
        ),
        actions: [
          Consumer<AreaProvider>(
            builder: (context, areaProv, child) {
              final areaTerbaru = areaProv.areas.firstWhere(
                (a) => a.idArea == initialArea!.idArea,
                orElse: () => initialArea!,
              );
              return IconButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.tambahKebun,
                  arguments: areaTerbaru,
                ),
                icon: const Icon(Icons.edit),
              );
            },
          ),

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

      body: Consumer<TandonProvider>(
        builder: (context, tandonProv, child) {
          if (tandonProv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tandonProv.listTandon.isEmpty) {
            return Column(
              children: [
                const WNullKebuntandon(
                  keterangan: "Tandon Kosong",
                  deskripsi:
                      "Belum ada tandon di kebun ini. Tambahkan tandon untuk mulai memantau.",
                  icon: Icons.opacity,
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () => tandonProv.getTandonByArea(initialArea!.idArea),
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
                        "namaArea": initialArea!.nama,
                      },
                    );
                  },
                  child: WTandonCard(
                    namaKebun: initialArea!.nama,
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
            arguments: initialArea!.idArea,
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
