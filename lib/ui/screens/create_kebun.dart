import 'package:flutter/material.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/models/area_model.dart';
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
  AreaModel? areaToEdit; // Untuk menampung data jika dalam mode Edit
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Menangkap data area yang dikirim melalui Navigator arguments
    final args = ModalRoute.of(context)?.settings.arguments;

    // Jika ada data AreaModel yang dikirim, berarti ini mode EDIT
    if (args is AreaModel) {
      areaToEdit = args;
      namaKebunController.text = areaToEdit!.nama;
    }
  }

  // Fungsi untuk eksekusi Simpan atau Update
  void _handleAction() async {
    final areaProv = Provider.of<AreaProvider>(context, listen: false);
    String namaInput = namaKebunController.text.trim();

    if (namaInput.isEmpty) return;

    bool sukses = false;
    // Pindahkan deklarasi message ke luar agar bisa diakses di bawah
    String message = "";

    if (areaToEdit == null) {
      // MODE: CREATE
      sukses = await areaProv.createArea(namaInput);
      message = "Kebun berhasil ditambahkan"; // Isi pesan create
    } else {
      // MODE: UPDATE
      sukses = await areaProv.updateArea(
        areaToEdit!.idArea,
        namaInput,
        areaToEdit!.status,
      );
      message = "Data kebun berhasil diperbarui"; // Isi pesan update
    }

    if (sukses && mounted) {
      // Tampilkan Dialog Sukses
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => WSuccessDialog(
          message: message, // Sekarang variabel message sudah aman diakses
          onOkPressed: () {
            Navigator.pop(c); // Tutup dialog
          },
        ),
      );
      // Setelah dialog ditutup, baru kembali ke halaman sebelumnya
      if (mounted) Navigator.pop(context);
    } else {
      // Jika gagal, tampilkan dialog error
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WFailedDialog(
        message: "Data kebun gagal disimpan. Periksa koneksi Anda.",
        onOkPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan Judul dan Teks Tombol secara dinamis
    bool isEditMode = areaToEdit != null;
    String title = isEditMode ? "Edit Nama Kebun" : "Tambah Kebun";
    String buttonText = isEditMode ? "Perbarui Kebun" : "Simpan Kebun";

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        title: WText(
          isi: title,
          fw: FontWeight.bold,
          ukuranFont: 22,
          color: AppColor.text,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const WText(
                isi: "Nama Kebun",
                fw: FontWeight.bold,
                ukuranFont: 16,
              ),
              const SizedBox(height: 10),
              WTextField(
                hintText: "Contoh: Kebun Hidroponik Belakang",
                controller: namaKebunController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Kebun tidak boleh kosong";
                  }
                  if (value.length < 4) {
                    return "Nama Kebun Minimal 4 huruf";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Consumer untuk memantau loading state dari provider
              Consumer<AreaProvider>(
                builder: (context, prov, _) {
                  return prov.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : WButton(
                          text: buttonText,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleAction();
                            }
                          },
                          textSize: 18,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
