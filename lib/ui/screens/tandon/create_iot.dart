import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_seladaku/providers/tandon_provider.dart';
import 'package:frontend_seladaku/ui/widgets/w_success_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:frontend_seladaku/ui/widgets/w_button.dart';
import 'package:frontend_seladaku/ui/widgets/w_text.dart';
import 'package:frontend_seladaku/ui/widgets/w_text_field.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';

class CreateIot extends StatefulWidget {
  const CreateIot({super.key});

  @override
  State<CreateIot> createState() => _CreateIotState();
}

class _CreateIotState extends State<CreateIot> {
  final TextEditingController deviceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? idTandon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    // Menangkap idTandon yang dikirim dari halaman DetailTandon via Map arguments
    if (args is Map<String, dynamic> && idTandon == null) {
      setState(() {
        idTandon = args["idTandon"];
      });
    }
  }

  void _handlePairing() async {
    if (idTandon == null) return;

    final tandonProv = context.read<TandonProvider>();
    String inputDeviceId = deviceController.text.trim();

    bool sukses = await tandonProv.connectDevice(idTandon!, inputDeviceId);

    if (sukses && mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => WSuccessDialog(
          message: "Perangkat IoT berhasil dihubungkan",
          onOkPressed: () {
            Navigator.pop(c); // Tutup popup sukses
          },
        ),
      );

      // Kembali ke Detail Tandon. Tombol otomatis hilang & berganti jadi grafik!
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WFailedDialog(
            message:
                "Gagal menghubungkan perangkat. Periksa kembali ID Perangkat Anda.",
            onOkPressed: () => Navigator.pop(context),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.text),
        title: const WText(
          isi: "Hubungkan Perangkat IoT",
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
                isi: "ID Perangkat (Device Id)",
                fw: FontWeight.bold,
                ukuranFont: 16,
              ),
              const SizedBox(height: 10),
              WTextField(
                hintText: "Contoh: device_Seladaku",
                controller: deviceController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "ID Perangkat tidak boleh kosong";
                  }
                  if (value.trim().length < 4) {
                    return "ID Perangkat minimal 4 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tampilkan loading indicator pas lagi nembak API backend
              Consumer<TandonProvider>(
                builder: (context, prov, _) {
                  return prov.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : WButton(
                          text: "Hubungkan Perangkat",
                          textSize: 18,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handlePairing();
                            }
                          },
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
