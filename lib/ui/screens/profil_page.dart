import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_header.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 70),
          WHeader(
            judul: "Profil",
            deskripsi: "Pastikan Data Dirimu Sudah Terisi",
          ),
          SizedBox(height: 25),
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 80,
                child: Image.asset('assets/pp.png'),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 7,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                WText(
                  isi: "Yanto",
                  fw: FontWeight.bold,
                  ukuranFont: 26,
                  color: AppColor.primary,
                ),
                const SizedBox(height: 15),
                _buildInfoRow("Email", "yanto@gmail.com"),
                const SizedBox(height: 8),
                _buildInfoRow("No. Telepon", "+62 812-5957-7179"),
                const SizedBox(height: 8),
                _buildInfoRow("Alamat", "Jl Halmahera 3"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 7,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuTile(
                  label: "Edit Profile",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                ),
                const Divider(height: 1, thickness: 1),
                _buildMenuTile(
                  label: "Log out",
                  labelColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: WText(
            isi: label,
            align: TextAlign.start,
            ukuranFont: 14,
            fw: FontWeight.w600,
            color: AppColor.primary,
          ),
        ),
        const WText(isi: ": ", ukuranFont: 14),
        Expanded(
          child: WText(
            isi: " $value",
            align: TextAlign.start,
            ukuranFont: 14,
            color: const Color(0xFF80CBC4),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required String label,
    required VoidCallback onTap,
    Color labelColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: WText(
          isi: label,
          align: TextAlign.start,
          fw: FontWeight.w500,
          ukuranFont: 18,
          color: labelColor,
        ),
      ),
    );
  }
}
