import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/tandon_model.dart';
import 'package:frontend_seladaku/providers/area_provider.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_text_field.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateTandon extends StatefulWidget {
  const CreateTandon({super.key});

  @override
  State<CreateTandon> createState() => _CreateTandonState();
}

class _CreateTandonState extends State<CreateTandon> {
  // GlobalKey untuk validasi Form
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaTandonController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  TandonModel? tandonToEdit;
  int? idAreaForCreate;
  DateTime? selectedDate; // State utama untuk tanggal
  bool _isSubmitting = false;

  // Helper untuk format tanggal ke MySQL YYYY-MM-DD HH:mm:ss
  String _formatToMySQL(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is TandonModel) {
      // Jika data tandon berbeda dengan yang sedang dipegang state, update controllernya
      if (tandonToEdit == null || tandonToEdit!.idTandon != args.idTandon) {
        tandonToEdit = args;
        namaTandonController.text = tandonToEdit!.namaTandon;

        // Pastikan konversi ke Local agar tidak berkurang 1 hari saat ditampilkan
        selectedDate = tandonToEdit!.tanggalTanam.toLocal();
        tanggalController.text = DateFormat(
          'dd MMMM yyyy',
        ).format(selectedDate!);
      }
    } else if (args is int && idAreaForCreate == null) {
      idAreaForCreate = args;
    }
  }

  // Fungsi memunculkan kalender (DatePicker)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColor.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Update state internal dan tampilan controller
        selectedDate = picked;
        tanggalController.text = DateFormat('dd MMMM yyyy').format(picked);
      });
      log("Tanggal baru dipilih: $selectedDate");
    }
  }

  void _handleSave() async {
    // 1. Validasi Form (TextFormField)
    if (!_formKey.currentState!.validate()) return;

    // 2. Validasi Tanggal
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih tanggal tanam")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final tandonProv = Provider.of<TandonProvider>(context, listen: false);
    bool sukses = false;

    try {
      // Gunakan format MySQL untuk menghindari Error 500 (Incorrect date value)
      // Gunakan toLocal() untuk memastikan tanggal konsisten
      String formattedDate = _formatToMySQL(selectedDate!.toLocal());

      if (tandonToEdit != null) {
        // --- MODE EDIT (PATCH) ---
        Map<String, dynamic> data = {
          "nama_tandon": namaTandonController.text,
          "tanggal_tanam": formattedDate,
        };
        log("Mengirim data update: $data");
        sukses = await tandonProv.updateTandon(tandonToEdit!.idTandon, data);
      } else {
        // --- MODE CREATE (POST) ---
        if (idAreaForCreate != null) {
          sukses = await tandonProv.createTandon(
            idArea: idAreaForCreate!,
            nama: namaTandonController.text,
            tanggalTanam: selectedDate!.toLocal(),
          );
        }
      }

      if (mounted) {
        if (sukses) {
          Provider.of<AreaProvider>(context, listen: false).fetchAreas();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WSuccessDialog(
              message: tandonToEdit != null
                  ? "Perubahan berhasil disimpan"
                  : "Tandon baru berhasil ditambahkan",
              onOkPressed: () {
                Navigator.pop(context); // Tutup Dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
          );
        } else {
          _showErrorDialog(
            "Gagal menyimpan. Server menolak format data atau nama sudah ada.",
          );
        }
      }
    } catch (e) {
      debugPrint("Error saat menyimpan: $e");
      _showErrorDialog("Terjadi kesalahan sistem: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) =>
          WFailedDialog(message: msg, onOkPressed: () => Navigator.pop(c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        title: WText(
          isi: tandonToEdit != null ? "Edit Tandon" : "Tambah Tandon",
          fw: FontWeight.bold,
          ukuranFont: 22,
          color: AppColor.text,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              WText(isi: "Nama Tandon", fw: FontWeight.bold, ukuranFont: 15),
              const SizedBox(height: 5),
              WTextField(
                hintText: "Masukkan Nama Tandon",
                controller: namaTandonController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama tandon tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              WText(isi: "Tanggal Tanam", fw: FontWeight.bold, ukuranFont: 15),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: WTextField(
                    hintText: "Pilih Tanggal Tanam",
                    controller: tanggalController,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tanggal wajib dipilih";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 35),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : WButton(
                      text: tandonToEdit != null
                          ? "Simpan Perubahan"
                          : "Tambah Tandon",
                      onPressed: _handleSave,
                      textSize: 18,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
