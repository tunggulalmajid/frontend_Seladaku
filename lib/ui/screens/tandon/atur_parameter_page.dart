import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seladaku/models/tandon_model.dart';
import 'package:seladaku/providers/tandon_provider.dart';
import 'package:seladaku/ui/widgets/w_text_field.dart';
import 'package:seladaku/ui/widgets/w_success_dialog.dart';
import 'package:seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AturParameterPage extends StatefulWidget {
  const AturParameterPage({super.key});

  @override
  State<AturParameterPage> createState() => _AturParameterPageState();
}

class _AturParameterPageState extends State<AturParameterPage> {
  final _formKey = GlobalKey<FormState>();
  late TandonModel tandon;
  bool _isInit = true;

  final TextEditingController _minPhController = TextEditingController();
  final TextEditingController _maxPhController = TextEditingController();
  final TextEditingController _minPpmController = TextEditingController();
  final TextEditingController _maxPpmController = TextEditingController();
  final TextEditingController _minVolController = TextEditingController();
  final TextEditingController _jarakMinController = TextEditingController();
  final TextEditingController _tinggiTandonController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tandon = args['tandon'] as TandonModel;

      _minPhController.text = tandon.minPh.toString();
      _maxPhController.text = tandon.maxPh.toString();
      _minPpmController.text = tandon.minPpm.toString().replaceAll('.0', '');
      _maxPpmController.text = tandon.maxPpm.toString().replaceAll('.0', '');
      _minVolController.text = tandon.minVolume.toString().replaceAll('.0', '');
      _jarakMinController.text = tandon.jarakAman.toString().replaceAll(
        '.0',
        '',
      );
      _tinggiTandonController.text = tandon.tinggiTandon.toString().replaceAll(
        '.0',
        '',
      );

      _isInit = false;
    }
  }

  @override
  void dispose() {
    _minPhController.dispose();
    _maxPhController.dispose();
    _minPpmController.dispose();
    _maxPpmController.dispose();
    _minVolController.dispose();
    _jarakMinController.dispose();
    _tinggiTandonController.dispose();
    super.dispose();
  }

  Future<void> _simpanPengaturan() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> dataPerubahan = {
      "min_ph": double.parse(_minPhController.text),
      "max_ph": double.parse(_maxPhController.text),
      "min_ppm": double.parse(_minPpmController.text).toInt(),
      "max_ppm": double.parse(_maxPpmController.text).toInt(),
      "min_volume": double.parse(_minVolController.text).toInt(),
      "jarak_aman": double.parse(_jarakMinController.text).toInt(),
      "tinggi_tandon": double.parse(_tinggiTandonController.text).toInt(),
    };

    log("Mengirim perubahan parameter: $dataPerubahan");

    final tandonProv = context.read<TandonProvider>();
    bool success = await tandonProv.updateTandon(
      tandon.idTandon,
      dataPerubahan,
    );

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (successCtx) => WSuccessDialog(
            message: "Parameter ambang batas tandon berhasil diperbarui!",
            onOkPressed: () {
              Navigator.pop(successCtx);
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (failedCtx) => WFailedDialog(
            message:
                "Gagal memperbarui parameter tandon. Mohon cek koneksi server Anda.",
            onOkPressed: () {
              Navigator.pop(failedCtx);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Text(
          'Atur Parameter',
          style: GoogleFonts.poppins(
            color: AppColor.text,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCardKelompok(
                icon: Icons.waves,
                judul: "pH Air",
                badgeText: "Rentang Normal",
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInputKecil(
                        label: "Minimum",
                        controller: _minPhController,
                        hint: "5.5",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputKecil(
                        label: "Maksimum",
                        controller: _maxPhController,
                        hint: "6.5",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCardKelompok(
                icon: Icons.timeline,
                judul: "PPM Nutrisi",
                badgeText: "Konsentrasi",
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInputKecil(
                        label: "Minimum",
                        controller: _minPpmController,
                        hint: "560",
                        suffixText: "ppm",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputKecil(
                        label: "Maksimum",
                        controller: _maxPpmController,
                        hint: "840",
                        suffixText: "ppm",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCardKelompok(
                icon: Icons.calendar_today_outlined,
                judul: "Volume Air",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelInput("Batas Minimum Air"),
                    const SizedBox(height: 6),
                    WTextField(
                      hintText: "0",
                      controller: _minVolController,
                      keyboardType: TextInputType.number,
                      suffix: _buildTextUnit("%"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Batas minimum air wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Notifikasi akan dikirim saat volume di bawah nilai ini, skala 1 - 100",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Jarak Aman Sensor",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      "Rentang jarak valid pembacaan sensor (cm)",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInputKecil(
                      label: "Jarak Min",
                      controller: _jarakMinController,
                      hint: "5",
                      suffixText: "cm",
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Terlalu dekat = sensor rawan terkena air",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCardKelompok(
                icon: Icons.assignment_outlined,
                judul: "Tinggi Tandon",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelInput("Tinggi Total Tandon"),
                    const SizedBox(height: 6),
                    WTextField(
                      hintText: "100",
                      controller: _tinggiTandonController,
                      keyboardType: TextInputType.number,
                      suffix: _buildTextUnit("cm"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tinggi total tandon wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Digunakan untuk menghitung persentase volume air",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Consumer<TandonProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02A697),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: provider.isLoading ? null : _simpanPengaturan,
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Simpan Pengaturan",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardKelompok({
    required IconData icon,
    required String judul,
    String? badgeText,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F7F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF02A697), size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    judul,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: const Color(0xFF02A697),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildLabelInput(String teks) {
    return Text(
      teks,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInputKecil({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelInput(label),
        const SizedBox(height: 6),
        WTextField(
          hintText: hint,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffix: suffixText != null ? _buildTextUnit(suffixText) : null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }
            if (double.tryParse(value) == null) {
              return 'Harus angka';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextUnit(String unit) {
    return Text(
      unit,
      style: GoogleFonts.poppins(
        color: const Color(0xFF02A697),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }
}
