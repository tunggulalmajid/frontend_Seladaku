import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
// import 'package:frontend_seladaku/ui/widgets/w_header.dart';
// import 'package:frontend_seladaku/ui/widgets/w_home_header.dart';
// import 'package:frontend_seladaku/ui/widgets/w_kebun_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';
// import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';

class TandonPage extends StatefulWidget {
  const TandonPage({super.key});

  @override
  State<TandonPage> createState() => _TandonPageState();
}

class _TandonPageState extends State<TandonPage> {
  bool adaTandon = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.text),
        title: WText(
          isi: "Kebun Depan",
          fw: .bold,
          ukuranFont: 25,
          color: AppColor.text,
        ),
        toolbarHeight: 70,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, color: AppColor.text),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => WConfirmationDeleteDialog(
                  title: "Hapus Tandon?",
                  message:
                      "Apakah Anda yakin ingin menghapus Tandon? Data yang telah dihapus tidak dapat dikembalikan",
                  onConfirm: () {
                    // Tambahkan logika hapus data di sini (API call, dll)
                    Navigator.pop(context); // Tutup dialog
                  },
                ),
              );
            },
            icon: Icon(Icons.delete, color: AppColor.redStatus),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          adaTandon
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.detailTandon);
                  },
                  child: WTandonCard(
                    namaKebun: "Kebun Depan",
                    namaTandon: "Tandon 1",
                    mode: "Mode Hujan",
                    ph: 7.1,
                    ppm: 102.5,
                    volume: "202",
                  ),
                )
              : WNullKebuntandon(
                  keterangan: "Belum Ada Tandon",
                  deskripsi:
                      "Mulai pantau kebun Anda dengan menambahkan Tandon pertama",
                  icon: Icons.grass,
                ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.tandonCreate);
        },
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          ),
          backgroundColor: WidgetStatePropertyAll(AppColor.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: Icon(Icons.add, color: AppColor.background, size: 35),
      ),
    );
  }
}
