import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_home_header.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/ui/widgets/w_tandon_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_weather_card.dart';
// import 'package:frontend_ambilin/utils/app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool adaKebun = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            WHomeHeader(
              userName: "Tunggul",
              onNotificationTap: () {},
              notificationCount: 2,
            ),
            SizedBox(height: 25),
            WWeatherCard(hasLocation: true),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Row(
                mainAxisAlignment: .start,
                children: [WText(isi: "Kebun Saya", fw: .bold, ukuranFont: 30)],
              ),
            ),
            adaKebun
                ? WTandonCard(
                    ppm: 800,
                    volume: "200",
                    ph: 7.1,
                    namaTandon: "Tandon 1",
                    mode: "Mode Hujan",
                    namaKebun: "Kebun 1",
                  )
                : WNullKebuntandon(
                    keterangan: "Belum Ada Kebun",
                    deskripsi:
                        "Mulai pantau kebun Anda dengan menambahkan area pertama ",
                    icon: Icons.add,
                  ),
          ],
        ),
      ),
    );
  }
}
