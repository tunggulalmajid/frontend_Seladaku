import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/screens/home_page.dart';
import 'package:frontend_seladaku/ui/screens/kebun_page.dart';
import 'package:frontend_seladaku/ui/screens/profil_page.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 2. Daftar halaman yang akan ditampilkan (pastikan jumlahnya sama dengan item navbar)
  final List<Widget> _pages = [
    const HomePage(),
    const KebunPage(),
    const ProfilPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8, // Memberikan sedikit bayangan di atas navbar
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,

        // Warna saat dipilih (Hijau sesuai AppColor)
        selectedItemColor: AppColor.primary,
        // Warna saat tidak dipilih (Abu-abu)
        unselectedItemColor: Colors.grey,

        // Styling teks label agar mirip di gambar
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),

        // Menampilkan label di semua kondisi
        showSelectedLabels: true,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass_rounded, size: 30),
            label: "Kebun",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded, size: 30),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
