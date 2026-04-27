import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_success_dialog.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_field.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class CreateTandon extends StatefulWidget {
  const CreateTandon({super.key});

  @override
  State<CreateTandon> createState() => _CreateTandonState();
}

class _CreateTandonState extends State<CreateTandon> {
  final TextEditingController namaKebunController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.text),
        title: WText(
          isi: "Tambah Tandon",
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
              hintText: "Masukkan Nama Tandon",
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
                    return WSuccessDialog(
                      message: "Data kebun berhasil diubah dan disimpan",
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
