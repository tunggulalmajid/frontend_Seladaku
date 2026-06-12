import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seladaku/models/riwayat_grafik_model.dart';

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
    double minY = 0.0;
    double maxY = 14.0;

    if (jenisSensor == "ph") {
      warnaGrafik = Colors.green;
      minY = 4.0;
      maxY = 9.0;
    } else if (jenisSensor == "ppm") {
      warnaGrafik = const Color(0xFFFFB800);
      minY = 0.0;
      maxY = 1200.0;
    } else if (jenisSensor == "volume") {
      warnaGrafik = Colors.blue;
      minY = 0.0;
      maxY = 100.0;
    }

    double maxX = data.length > 1 ? (data.length - 1).toDouble() : 1.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: minY,
        maxY: maxY,

        
        
        
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                const Color(0xFF333333).withValues(alpha: 0.9),
            tooltipBorderRadius: BorderRadius.circular(8),
            maxContentWidth: 150,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  
                  String waktuAsli = data[index].xLabel;
                  String nilaiSensor = barSpot.y.toStringAsFixed(
                    jenisSensor == "ph" ? 2 : 0,
                  );

                  String satuan = "";
                  if (jenisSensor == "ph") satuan = " pH";
                  if (jenisSensor == "ppm") satuan = " PPM";
                  if (jenisSensor == "volume") satuan = "%";

                  return LineTooltipItem(
                    "$waktuAsli\n",
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "$nilaiSensor$satuan",
                        style: TextStyle(
                          color: warnaGrafik,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              }).toList();
            },
          ),
          handleBuiltInTouches: true, 
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            left: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
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
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (jenisSensor == "ph" && value % 1.0 != 0) {
                  return const SizedBox.shrink();
                }
                if (jenisSensor == "ppm" && value % 300 != 0) {
                  return const SizedBox.shrink();
                }
                if (jenisSensor == "volume" && value % 25 != 0) {
                  return const SizedBox.shrink();
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
                if (value != index.toDouble()) return const SizedBox.shrink();

                if (index >= 0 && index < data.length) {
                  
                  
                  int totalData = data.length;
                  bool cetakLabel = false;

                  if (totalData <= 4) {
                    cetakLabel = true; 
                  } else {
                    
                    int lompatan = (totalData / 3).floor();
                    if (index == 0 ||
                        index == totalData - 1 ||
                        index % lompatan == 0) {
                      cetakLabel = true;
                    }
                  }

                  if (!cetakLabel) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].xLabel,
                      style: const TextStyle(
                        fontSize: 9,
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

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: warnaGrafik,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true, 
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius:
                    3, 
                color:
                    warnaGrafik, 
                strokeWidth: 1.5, 
                strokeColor:
                    Colors.white, 
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
