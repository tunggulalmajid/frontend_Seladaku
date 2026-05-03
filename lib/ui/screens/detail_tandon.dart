import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_data_tandon.dart';
// import 'package:frontend_seladaku/ui/widgets/w_header.dart';
// import 'package:frontend_seladaku/ui/widgets/w_home_header.dart';
// import 'package:frontend_seladaku/ui/widgets/w_kebun_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_setting_tile.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';
// import 'package:frontend_ambilin/ui/widgets/w_null_kebuntandon.dart';

class DetailTandon extends StatefulWidget {
  const DetailTandon({super.key});

  @override
  State<DetailTandon> createState() => _DetailTandonState();
}

class _DetailTandonState extends State<DetailTandon> {
  bool adaTandon = true;
  bool isOtomatis = false;
  bool isNotifikasi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.text),
        title: WText(
          isi: "Tandon 1",
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
          WDataTandon(
            namaKebun: "Kebun Depan",
            namaTandon: "Tandon 1",
            tanggalTanam: DateTime.now(),
          ),
          WTandonCard(
            namaKebun: "Koneksi",
            namaTandon: "Tandon 1",
            mode: "Menunggu Koneksi",
            ph: 0,
            ppm: 0,
            volume: "0",
          ),

          WSettingTile(
            title: "Otomatisasi",
            buttonText: "Kendali Manual",
            switchValue: isOtomatis,
            onSwitchChanged: (value) {
              setState(() {
                isOtomatis = value;
              });
            },
            onPressed: () {
              // Logika kendali manual
            },
          ),

          WSettingTile(
            title: "Notifikasi",
            buttonText: "Atur Parameter dan Peringatan",
            switchValue: isNotifikasi,
            onSwitchChanged: (value) {
              setState(() {
                isNotifikasi = value;
              });
            },
            onPressed: () {
              // Logika atur parameter
            },
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: WButton(
              text: "Hubungkan Perangkat IoT",
              textSize: 14,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
