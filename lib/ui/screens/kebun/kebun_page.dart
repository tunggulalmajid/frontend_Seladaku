import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seladaku/providers/area_provider.dart';
import 'package:seladaku/ui/widgets/w_header.dart';
import 'package:seladaku/ui/widgets/w_kebun_card.dart';
import 'package:seladaku/ui/widgets/w_null_kebuntandon.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/utils/app_routes.dart';

class KebunPage extends StatefulWidget {
  const KebunPage({super.key});

  @override
  State<KebunPage> createState() => _KebunPageState();
}

class _KebunPageState extends State<KebunPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<AreaProvider>(context, listen: false).fetchAreas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<AreaProvider>(context, listen: false).fetchAreas(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            const WHeader(
              judul: "Kebunku",
              deskripsi: "Kelola kebun dan tandon Anda",
            ),
            const SizedBox(height: 20),

            Consumer<AreaProvider>(
              builder: (context, areaProv, child) {
                if (areaProv.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (areaProv.areas.isEmpty) {
                  return const WNullKebuntandon(
                    keterangan: "Belum Ada Kebun",
                    deskripsi:
                        "Mulai pantau kebun Anda dengan menambahkan area pertama",
                    icon: Icons.grass,
                  );
                }

                return Column(
                  children: areaProv.areas.map((area) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.tandonIndex,
                          arguments: area,
                        );
                      },
                      child: WKebunCard(
                        namaKebun: area.nama,
                        jumlahTandon: area.totalTandon,
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
            EdgeInsets.symmetric(horizontal: 17, vertical: 17),
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
