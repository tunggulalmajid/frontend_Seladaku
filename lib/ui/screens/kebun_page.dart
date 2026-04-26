import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_header.dart';
// import 'package:frontend_ambilin/ui/widgets/w_home_header.dart';
import 'package:frontend_ambilin/ui/widgets/w_kebun_card.dart';
import 'package:frontend_ambilin/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
// import 'package:frontend_ambilin/ui/widgets/w_null_kebuntandon.dart';

class KebunPage extends StatefulWidget {
  const KebunPage({super.key});

  @override
  State<KebunPage> createState() => _KebunPageState();
}

class _KebunPageState extends State<KebunPage> {
  bool adaKebun = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),
          WHeader(judul: "Kebunku", deskripsi: "Kelola kebun dan tandon Anda"),
          SizedBox(height: 20),
          adaKebun
              ? WKebunCard(namaKebun: "Kebun Depan")
              : WNullKebuntandon(
                  keterangan: "Belum Ada Kebun",
                  deskripsi:
                      "Mulai pantau kebun Anda dengan menambahkan area pertama",
                  icon: Icons.grass,
                ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
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
