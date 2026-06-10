import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_seladaku/models/riwayat_grafik_model.dart';

class WSensorChart extends StatelessWidget {
  final List<RiwayatGrafikModel> data;
  final String jenisSensor;

  const WSensorChart({
    super.key,
    required this.data,
    required this.jenisSensor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            "Belum ada log aktivitas sensor di rentang ini",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      double nilaiY = 0.0;
      if (jenisSensor == "ph") nilaiY = data[i].ph;
      if (jenisSensor == "ppm") nilaiY = data[i].ppm.toDouble();
      if (jenisSensor == "volume") nilaiY = data[i].volume.toDouble();
      spots.add(FlSpot(i.toDouble(), nilaiY));
    }

    Color warnaGrafik = Colors.green;
    // SETTING AMAN THRESHOLD BATAS Y (FIGMA STANDARD 📊)
    double minY = 0.0;
    double maxY = 14.0; // Default skala pH murni 0 - 14

    if (jenisSensor == "ph") {
      warnaGrafik = Colors.green;
      minY =
          0.0; // Batas bawah pH selada (biar fluktuasi 6.0 - 7.0 kelihatan pas di tengah)
      maxY = 14.0; // Batas atas pH selada
    } else if (jenisSensor == "ppm") {
      warnaGrafik = const Color(0xFFFFB800);
      minY = 0.0;
      maxY = 1300.0; // Batas atas nutrisi selada maksimal kisaran 1200 PPM
    } else if (jenisSensor == "volume") {
      warnaGrafik = Colors.blue;
      minY = 0.0;
      maxY =
          100.0; // Batas volume air tandon dalam bentuk persentase (0% - 100%)
    }

    double maxX = data.length > 1 ? (data.length - 1).toDouble() : 1.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        // === FIXED: Masukkan Nilai Batas Y Yang Sudah Dikondisikan ===
        minY: minY,
        maxY: maxY,
        // ============================================================
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize:
                  40, // Ditambah sedikit dari 35 agar angka desimal pH tidak terpotong kiri
              getTitlesWidget: (value, meta) {
                // FILTER LABEL: Biar sumbu Y tidak memunculkan terlalu banyak pecahan label mepet
                // Kita buat aturan hanya memunculkan angka bulat atau kelipatan pas tertentu
                if (jenisSensor == "ph") {
                  // Munculkan per kelipatan 1.0 saja (misal: 4.0, 5.0, 6.0, 7.0...)
                  if (value % 1.0 != 0) return const SizedBox.shrink();
                } else if (jenisSensor == "ppm") {
                  // Munculkan per kelipatan 300 PPM (0, 300, 600, 900, 1200)
                  if (value % 300 != 0) return const SizedBox.shrink();
                } else if (jenisSensor == "volume") {
                  // Munculkan per kelipatan 25% (0, 25, 50, 75, 100)
                  if (value % 25 != 0) return const SizedBox.shrink();
                }

                return Text(
                  meta.formattedValue,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (value != index.toDouble()) {
                  return const SizedBox.shrink();
                }
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].xLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            left: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: warnaGrafik,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: warnaGrafik,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: warnaGrafik.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
