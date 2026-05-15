import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../dto/edit_profile_dto.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/w_button.dart';
import '../../widgets/w_text_field.dart';
import '../../widgets/w_text.dart';
import '../../widgets/w_success_dialog.dart';
import 'map_picker_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomorTeleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController telegramController = TextEditingController();

  File? _imageFile;
  double? lat;
  double? lon;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    String inisial = user?.nama != null && user!.nama.isNotEmpty
        ? user.nama[0].toUpperCase()
        : "?";
    if (user != null) {
      namaController.text = user.nama;
      emailController.text = user.email;
      nomorTeleponController.text = user.nomorTelepon ?? "";
      alamatController.text = user.alamat ?? "";
      telegramController.text = user.idTelegram ?? "";
      lat = user.latitude;
      lon = user.longitude;
    }
    log("$lat, $lon");
  }

  // Fungsi ambil foto
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) setState(() => _imageFile = File(image.path));
  }

  // Fungsi ambil lokasi dari peta
  Future<void> _handleLocationPick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerPage(
          // Kirim lokasi yang saat ini tersimpan di state EditProfile
          initialLocation: (lat != null && lon != null)
              ? LatLng(lat!, lon!)
              : null,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        lat = result['lat'];
        lon = result['lon'];
        alamatController.text = result['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: WText(isi: "Edit Profile", fw: FontWeight.bold, ukuranFont: 20),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey, // Pasang form key di sini
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // PROFILE PICTURE SECTION
            _buildAvatar(authProvider),
            const SizedBox(height: 30),

            // FORM FIELDS
            _label("Nama Lengkap"),
            WTextField(
              hintText: "Masukkan Nama",
              controller: namaController,
              validator: (v) => v!.isEmpty ? "Nama wajib diisi, Wak!" : null,
            ),

            const SizedBox(height: 15),
            _label("email"),
            WTextField(
              hintText: "contoh : t@gmail.com",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Wajib diisi buat notifikasi";
                }
                if (!v.contains("@")) {
                  return "Gunakan format email yang benar";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),
            _label("ID Telegram (Hanya Angka)"),
            WTextField(
              hintText: "Contoh: 123456789",
              controller: telegramController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return null;
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                  return "ID Telegram harus angka";
                }

                return null;
              },
            ),

            const SizedBox(height: 15),
            _label("Alamat & Lokasi Kebun"),
            WTextField(
              hintText: "Klik untuk pilih lokasi di peta",
              controller: alamatController,
              readOnly: true,
              onTap: _handleLocationPick,
              suffixIcon: const Icon(
                Icons.location_searching_outlined,
                color: AppColor.primary,
              ),
            ),

            const SizedBox(height: 15),
            _label("Nomor Telepon"),
            WTextField(
              hintText: "0812...",
              controller: nomorTeleponController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 40),

            // ACTION BUTTON
            WButton(
              text: authProvider.isLoading
                  ? "Sedang Menyimpan..."
                  : "Simpan Profil",
              onPressed: authProvider.isLoading
                  ? () {}
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final dto = EditProfileDTO(
                          nama: namaController.text,
                          email: emailController.text,
                          nomorTelepon: nomorTeleponController.text,
                          alamat: alamatController.text,
                          idTelegram: telegramController.text,
                          lat: lat,
                          lon: lon,
                          fotoFile: _imageFile,
                        );
                        try {
                          bool success = await authProvider.updateProfile(dto);
                          authProvider.fetchUser();
                          if (success && context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (c) => WSuccessDialog(
                                message: "Profil Seladaku Terupdate!",
                                onOkPressed: () {
                                  Navigator.pop(c);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (c) => WFailedDialog(
                                message: "Error : $e",
                                onOkPressed: () {
                                  Navigator.pop(c);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(AuthProvider authProvider) {
    final user = authProvider.user;
    final inisial = user?.nama.isNotEmpty == true
        ? user!.nama[0].toUpperCase()
        : "?";

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.green[50],
            // Urutan Prioritas: 1. File baru, 2. Foto dari Server, 3. Kosong (null)
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : (user?.foto != null ? NetworkImage("${user!.foto}") : null),
            child: (_imageFile == null && user?.foto == null)
                ? _buildInitial(inisial)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppColor.primary,
                radius: 18,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(String char) {
    return WText(
      isi: char,
      ukuranFont: 60,
      fw: FontWeight.bold,
      color: AppColor.primary, // Huruf berwarna hijau tua (Primary)
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: WText(
        align: .start,
        isi: text,
        fw: FontWeight.bold,
        ukuranFont: 14,
      ),
    );
  }
}
