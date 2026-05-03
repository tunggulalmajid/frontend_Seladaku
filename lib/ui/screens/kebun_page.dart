import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Wajib import provider
import 'package:frontend_seladaku/providers/area_provider.dart'; // Import provider area
import 'package:frontend_seladaku/ui/widgets/w_header.dart';
import 'package:frontend_seladaku/ui/widgets/w_kebun_card.dart';
import 'package:frontend_seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:frontend_seladaku/utils/app_colors.dart';
import 'package:frontend_seladaku/utils/app_routes.dart';

class KebunPage extends StatefulWidget {
  const KebunPage({super.key});

  @override
  State<KebunPage> createState() => _KebunPageState();
}

class _KebunPageState extends State<KebunPage> {
  @override
  void initState() {
    super.initState();
    // Pemicu ambil data area pertama kali saat halaman dibuka
    Future.microtask(
      () => Provider.of<AreaProvider>(context, listen: false).fetchAreas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan RefreshIndicator agar user bisa tarik ke bawah untuk refresh data
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<AreaProvider>(context, listen: false).fetchAreas(),
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator selalu aktif
          children: [
            const SizedBox(height: 20),
            const WHeader(
              judul: "Kebunku",
              deskripsi: "Kelola kebun dan tandon Anda",
            ),
            const SizedBox(height: 20),

            // Menggunakan Consumer untuk mendengarkan perubahan di AreaProvider
            Consumer<AreaProvider>(
              builder: (context, areaProv, child) {
                // 1. Tampilkan Loading saat data sedang ditarik
                if (areaProv.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // 2. Tampilkan Kondisi Kosong (Null State)
                if (areaProv.areas.isEmpty) {
                  return const WNullKebuntandon(
                    keterangan: "Belum Ada Kebun",
                    deskripsi:
                        "Mulai pantau kebun Anda dengan menambahkan area pertama",
                    icon: Icons.grass,
                  );
                }

                // 3. Tampilkan List Kebun jika ada data
                return Column(
                  children: areaProv.areas.map((area) {
                    return GestureDetector(
                      onTap: () {
                        // Kirim data area ke halaman tandon jika perlu
                        Navigator.pushNamed(
                          context,
                          AppRoutes.tandonIndex,
                          arguments: area, // Kirim object area yang diklik
                        );
                      },
                      child: WKebunCard(
                        namaKebun: area.nama,
                        // Pastikan widget WKebunCard kamu bisa menerima parameter tambahan seperti:
                        // totalTandon: area.totalTandon,
                        // status: area.status,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.tambahKebun);
        },
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          ),
          backgroundColor: const WidgetStatePropertyAll(AppColor.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: const Icon(Icons.add, color: AppColor.background, size: 35),
      ),
    );
  }
}
