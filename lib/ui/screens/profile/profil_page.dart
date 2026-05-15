import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_confirmation_delete_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_header.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_routes.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    // Logika mengambil inisial nama depan
    String inisial = user?.nama != null && user!.nama.isNotEmpty
        ? user.nama[0].toUpperCase()
        : "?";

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 70),
          const WHeader(
            judul: "Profil",
            deskripsi: "Pastikan Data Dirimu Sudah Terisi",
          ),
          const SizedBox(height: 25),

          // Bagian Foto Profil / Inisial
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 80,
                // Background hijau jika tidak ada foto (menggunakan warna primary aplikasi)
                backgroundColor: Colors.green[50],
                child:
                    user?.foto !=
                        null // Asumsi jika nanti ada field fotoUrl
                    ? ClipOval(
                        child: Image.network(
                          user!.foto!,
                          fit: BoxFit.cover,
                          width: 160,
                          height: 160,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildInitial(inisial),
                        ),
                      )
                    : _buildInitial(inisial),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Container Data Diri
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 7,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                WText(
                  isi: user?.nama ?? "Tamu",
                  fw: FontWeight.bold,
                  ukuranFont: 26,
                  color: AppColor.primary,
                ),
                const SizedBox(height: 15),
                _buildInfoRow("Email", user?.email ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("No. Telepon", user?.nomorTelepon ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("ID telegram", user?.idTelegram ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("Alamat", user?.alamat ?? "-"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Menu Edit & Logout
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuTile(
                  label: "Edit Profile",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
                const Divider(height: 1, thickness: 1),
                _buildMenuTile(
                  label: "Log out",
                  labelColor: Colors.red,
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => WConfirmationDeleteDialog(
                        title: "konfirmasi",
                        message:
                            "Apakah Anda yakin ingin keluar dari aplikasi ?",
                        confirmText: "Keluar",
                        onConfirm: () async {
                          navigator.pop();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
                          );
                          context.read<AuthProvider>().logout();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk menampilkan Inisial Nama
  Widget _buildInitial(String char) {
    return WText(
      isi: char,
      ukuranFont: 60,
      fw: FontWeight.bold,
      color: AppColor.primary, // Huruf berwarna hijau tua (Primary)
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Agar sejajar atas jika teks panjang
        children: [
          // Label (Email, Alamat, dll)
          SizedBox(
            width: 90, // Beri lebar tetap agar titik dua sejajar vertikal
            child: WText(
              isi: label,
              color: Colors.grey,
              ukuranFont: 14,
              align: .start,
            ),
          ),

          // Titik dua
          WText(isi: ": ", fw: FontWeight.w600, ukuranFont: 14),

          // Value (Isi datanya)
          Expanded(
            // PENTING: Agar teks panjang tidak menyebabkan error overflow
            child: Text(
              value,
              textAlign: TextAlign.start,
              overflow: TextOverflow.visible,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
                // Sesuaikan font family jika kamu pakai GoogleFonts di WText
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String label,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: WText(
        align: .start,
        isi: label,
        color: labelColor ?? Colors.black,
        fw: FontWeight.w500,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
