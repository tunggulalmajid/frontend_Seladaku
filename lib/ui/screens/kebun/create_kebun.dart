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
  AreaModel? areaToEdit;
  final _formKey = GlobalKey<FormState>();
  bool _isInitialized = false; // FIXED: Kunci pengaman didChangeDependencies

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // FIXED: Mengunci logika agar hanya berjalan sekali saja saat halaman dibuka pertama kali
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is AreaModel) {
        areaToEdit = args;
        namaKebunController.text = areaToEdit!.nama;
      }
      _isInitialized = true; // Kunci diaktifkan
    }
  }

  void _handleAction() async {
    final areaProv = Provider.of<AreaProvider>(context, listen: false);
    String namaInput = namaKebunController.text.trim();

    if (namaInput.isEmpty) return;

    bool sukses = false;
    String message = "";

    if (areaToEdit == null) {
      sukses = await areaProv.createArea(namaInput);
      message = "Kebun berhasil ditambahkan";
    } else {
      sukses = await areaProv.updateArea(
        areaToEdit!.idArea,
        namaInput,
        areaToEdit!.status,
      );
      message = "Data kebun berhasil diperbarui";
    }

    if (sukses && mounted) {
      // FIXED: Tarik data terbaru dari API Express ke provider utama sebelum memicu popup sukses
      await areaProv.fetchAreas();

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => WSuccessDialog(
            message: message,
            onOkPressed: () {
              Navigator.pop(c);
            },
          ),
        );
        if (mounted) Navigator.pop(context);
      }
    } else {
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
