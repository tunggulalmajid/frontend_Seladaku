import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_success_dialog.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_field.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomorTeleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.text),
        title: WText(
          isi: "Edit Profile",
          fw: .bold,
          ukuranFont: 25,
          color: AppColor.text,
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60,
                child: Image.asset('assets/pp.png'),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: .start,
              children: [
                WText(
                  isi: "Nama Lengkap",
                  align: .start,
                  fw: .bold,
                  ukuranFont: 15,
                ),
                SizedBox(height: 5),
                WTextField(
                  hintText: "Nama Lengkap",
                  controller: namaController,
                ),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                WText(isi: "Email", align: .start, fw: .bold, ukuranFont: 15),
                SizedBox(height: 5),
                WTextField(hintText: "Email", controller: emailController),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                WText(
                  isi: "Nomor Telepon",
                  align: .start,
                  fw: .bold,
                  ukuranFont: 15,
                ),
                SizedBox(height: 5),
                WTextField(
                  hintText: "Nomor Telepon",
                  controller: nomorTeleponController,
                ),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                WText(isi: "Alamat", align: .start, fw: .bold, ukuranFont: 15),
                SizedBox(height: 5),
                WTextField(hintText: "Alamat", controller: alamatController),
              ],
            ),
            SizedBox(height: 15),

            SizedBox(height: 15),
            WButton(
              text: "Simpan",
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // User wajib tekan tombol OK
                  builder: (BuildContext context) {
                    return WSuccessDialog(
                      message: "Data Profile Berhasil Diupdate",
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
