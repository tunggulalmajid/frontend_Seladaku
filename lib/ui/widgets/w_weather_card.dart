import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';

class WWeatherCard extends StatelessWidget {
  final bool hasLocation;
  final Map<String, dynamic>?
  weatherData; // Tempat menyimpan data cuaca dari API nanti

  const WWeatherCard({super.key, required this.hasLocation, this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Jika hasLocation true tampilkan cuaca, jika false tampilkan empty state
      child: hasLocation ? _buildWeatherContent() : _buildEmptyState(),
    );
  }

  // --- TAMPILAN 1: BELUM ADA LOKASI ---
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Belum Ada Lokasi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan lokasi untuk melihat\nperkiraan cuaca",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                "Tambah Lokasi",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN 2: SUDAH ADA LOKASI ---
  Widget _buildWeatherContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
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
                          const Icon(Icons.wb_sunny_outlined, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            "Cerah",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        "27°",
                        style: GoogleFonts.poppins(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        "30° / 24°",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "15:00",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Sen 01-04",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Jember",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Bagian Bawah (Forecast)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildForecastItem("Sel", Icons.wb_sunny_outlined),
              _buildForecastItem("Rab", Icons.cloud_outlined),
              _buildForecastItem("Kam", Icons.beach_access_rounded),
              _buildForecastItem("Jum", Icons.thunderstorm_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(String day, IconData icon) {
    return Row(
      children: [
        Text(
          day,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Icon(icon, color: Colors.white, size: 18),
      ],
    );
  }
}
