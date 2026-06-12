import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seladaku/providers/weather_provider.dart';
import 'package:seladaku/ui/screens/profile/map_picker_page.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/utils/weather_helper.dart';
import 'package:seladaku/ui/widgets/w_text.dart';
import 'package:seladaku/models/weather_model.dart';

class DetailCuaca extends StatelessWidget {
  const DetailCuaca({super.key});

  Future<void> _gantiLokasiLewatDetail(
    BuildContext context,
    WeatherProvider prov,
  ) async {
    final Map<String, dynamic>? hasilPeta = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (hasilPeta != null) {
      double latitude = hasilPeta['lat'];
      double longitude = hasilPeta['lon'];
      String alamatPenuh = hasilPeta['address'];

      List<String> komponenAlamat = alamatPenuh.split(', ');
      String namaKotaSingkat = "Kebun Hidroponik";
      String namaKabupatenDinamis = "Kabupaten Jember, Jawa Timur";

      if (komponenAlamat.length > 2) {
        namaKotaSingkat = komponenAlamat[komponenAlamat.length - 2];
        namaKabupatenDinamis = komponenAlamat[komponenAlamat.length - 1];
      } else if (komponenAlamat.isNotEmpty) {
        namaKotaSingkat = komponenAlamat.last;
        namaKabupatenDinamis = alamatPenuh;
      }

      prov.updateLokasiCuaca(
        namaKota: namaKotaSingkat,
        latitude: latitude,
        longitude: longitude,
        alamatDetail: namaKabupatenDinamis,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();

    if (!weatherProv.hasLocation || weatherProv.weatherData == null) {
      return const Scaffold(
        body: Center(child: Text("Data cuaca tidak ditemukan")),
      );
    }

    final data = weatherProv.weatherData!;
    final List<DailyForecast> listRamalanEsok = data.forecast
        .skip(1)
        .cast<DailyForecast>()
        .toList();

    final teksCuacaUtama = WeatherHelper.getInfoCuaca(
      data.currentConditionCode,
    );
    final ikonCuacaUtama = WeatherHelper.getIkonCuaca(
      data.currentConditionCode,
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const WText(
          isi: "Detail Cuaca",
          fw: FontWeight.bold,
          ukuranFont: 16,
          color: AppColor.text,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.text,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: weatherProv.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            )
          : RefreshIndicator(
              color: AppColor.primary,
              backgroundColor: Colors.white,
              onRefresh: () => weatherProv.refreshCuaca(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () =>
                          _gantiLokasiLewatDetail(context, weatherProv),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColor.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WText(
                                    isi: data.namaKota,
                                    ukuranFont: 16,
                                    fw: FontWeight.bold,
                                    color: AppColor.text,
                                  ),
                                  Text(
                                    weatherProv.alamatLengkapAktif!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.text80,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.edit_location_alt_rounded,
                              color: AppColor.primary80,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColor.primary, AppColor.primary80],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              ikonCuacaUtama,
                              size: 55,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${data.currentTemp.toStringAsFixed(1)}°C",
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          WText(
                            isi: teksCuacaUtama,
                            ukuranFont: 15,
                            fw: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 1,
                            width: 120,
                            color: Colors.white.withOpacity(0.25),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              WText(
                                isi: "Maks ${data.maxTemp.toStringAsFixed(1)}°",
                                ukuranFont: 12,
                                color: Colors.white70,
                                fw: FontWeight.w500,
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              WText(
                                isi: "Min ${data.minTemp.toStringAsFixed(1)}°",
                                ukuranFont: 12,
                                color: Colors.white70,
                                fw: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const WText(
                      isi: "Ramalan Cuaca Seminggu Kedepan",
                      fw: FontWeight.bold,
                      ukuranFont: 14,
                      color: AppColor.text,
                    ),
                    const SizedBox(height: 12),

                    Container(
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
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3.0),
                          1: FlexColumnWidth(4.5),
                          2: FlexColumnWidth(2.5),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: AppColor.primary.withOpacity(0.07),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                child: WText(
                                  isi: "Hari",
                                  ukuranFont: 12,
                                  fw: FontWeight.bold,
                                  color: AppColor.text,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 26),
                                    WText(
                                      isi: "Kondisi",
                                      ukuranFont: 12,
                                      fw: FontWeight.bold,
                                      color: AppColor.text,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  "Min / Maks",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ...List.generate(listRamalanEsok.length, (index) {
                            final DailyForecast f = listRamalanEsok[index];
                            DateTime date = DateTime.parse(f.tanggal);

                            String namaHari = DateFormat(
                              'EEEE',
                              'id_ID',
                            ).format(date);
                            String tglBulan = DateFormat(
                              'dd MMM',
                              'id_ID',
                            ).format(date);

                            final teksF = WeatherHelper.getInfoCuaca(
                              f.conditionCode,
                            );
                            final ikonF = WeatherHelper.getIkonCuaca(
                              f.conditionCode,
                            );

                            Color warnaIkonList = AppColor.primary;
                            if (teksF.contains("Hujan") || teksF == "Gerimis") {
                              warnaIkonList = AppColor.blueRain;
                            } else if (teksF == "Cerah") {
                              warnaIkonList = AppColor.yellowAlert;
                            }

                            bool isLast = index == listRamalanEsok.length - 1;

                            return TableRow(
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade100,
                                          width: 1,
                                        ),
                                      ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      WText(
                                        isi: namaHari,
                                        ukuranFont: 13,
                                        fw: FontWeight.bold,
                                        color: AppColor.text,
                                      ),
                                      const SizedBox(height: 2),
                                      WText(
                                        isi: tglBulan,
                                        ukuranFont: 11,
                                        color: AppColor.text80,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        ikonF,
                                        color: warnaIkonList,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          teksF,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.text80,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "${f.minTemp.toStringAsFixed(0)}° / ${f.maxTemp.toStringAsFixed(0)}°",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
