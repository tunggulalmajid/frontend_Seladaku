import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_text_field.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class CreateKebun extends StatefulWidget {
  const CreateKebun({super.key});

  @override
  State<CreateKebun> createState() => _CreateKebunState();
}

class _CreateKebunState extends State<CreateKebun> {
  final TextEditingController namaKebunController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.text),
        title: WText(
          isi: "Tambah Kebun",
          fw: .bold,
          ukuranFont: 25,
          color: AppColor.text,
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 10),
            WText(isi: "Nama Kebun", align: .start, fw: .bold, ukuranFont: 15),
            SizedBox(height: 5),
            WTextField(
              hintText: "Masukkan Nama Kebun",
              controller: namaKebunController,
            ),
            SizedBox(height: 15),
            WButton(
              text: "Simpan Kebun",
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // User wajib tekan tombol OK
                  builder: (BuildContext context) {
                    return WFailedDialog(
                      message: "Data kebun Gagal diubah dan disimpan",
                      onOkPressed: () {
                        Navigator.of(context).pop(); // Tutup Dialog
                        Navigator.of(context).pop(); // Tutup Dialog
                      },
                    );
                  },
                );
              },
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
