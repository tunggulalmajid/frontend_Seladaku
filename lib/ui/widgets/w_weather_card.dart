import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seladaku/ui/screens/profile/map_picker_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seladaku/providers/weather_provider.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/utils/weather_helper.dart';
import 'package:seladaku/ui/widgets/w_text.dart';

class WWeatherCard extends StatefulWidget {
  const WWeatherCard({super.key});

  @override
  State<WWeatherCard> createState() => _WWeatherCardState();
}

class _WWeatherCardState extends State<WWeatherCard> {
  String _formattedTime = "";
  String _formattedDate = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateClock();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => _updateClock());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    if (mounted) {
      setState(() {
        _formattedTime = DateFormat('HH:mm').format(now);
        _formattedDate = DateFormat('EEE dd-MM', 'id_ID').format(now);
      });
    }
  }

  Future<void> _bukaMapPicker(
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: !weatherProv.hasLocation
          ? _buildEmptyState(context, weatherProv)
          : weatherProv.isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            )
          : _buildWeatherState(context, weatherProv),
    );
  }

  Widget _buildEmptyState(BuildContext context, WeatherProvider prov) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(
            Icons.cloud_off_rounded,
            color: Colors.grey,
            size: 30,
          ),
        ),
        const SizedBox(height: 15),
        const WText(
          isi: "Belum Ada Lokasi",
          fw: FontWeight.bold,
          ukuranFont: 18,
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Tambahkan lokasi untuk melihat perkiraan cuaca",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          onPressed: () => _bukaMapPicker(context, prov),
          child: const WText(
            isi: "Tambah Lokasi",
            color: Colors.white,
            fw: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherState(BuildContext context, WeatherProvider prov) {
    final data = prov.weatherData!;
    final teksCuaca = WeatherHelper.getInfoCuaca(data.currentConditionCode);
    final ikonCuaca = WeatherHelper.getIkonCuaca(data.currentConditionCode);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/detail-cuaca'),
      borderRadius: BorderRadius.circular(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(ikonCuaca, color: Colors.grey.shade600, size: 18),
                      const SizedBox(width: 5),
                      WText(
                        isi: teksCuaca,
                        ukuranFont: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${data.currentTemp.toStringAsFixed(0)}°",
                    style: GoogleFonts.poppins(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WText(
                    isi:
                        "${data.maxTemp.toStringAsFixed(0)}° / ${data.minTemp.toStringAsFixed(0)}°",
                    ukuranFont: 14,
                    color: Colors.grey,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formattedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WText(
                    isi: _formattedDate,
                    ukuranFont: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 15),

                  WText(
                    isi: data.namaKota,
                    ukuranFont: 14,
                    fw: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),

                  SizedBox(
                    width: 160,
                    child: Text(
                      prov.alamatLengkapAktif!,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.forecast.skip(1).take(4).map((f) {
                DateTime parsedDate = DateTime.parse(f.tanggal);
                String namaHari = DateFormat('EEE', 'id_ID').format(parsedDate);
                return Row(
                  children: [
                    WText(
                      isi: "$namaHari ",
                      color: Colors.white,
                      ukuranFont: 12,
                    ),
                    Icon(
                      WeatherHelper.getIkonCuaca(f.conditionCode),
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
