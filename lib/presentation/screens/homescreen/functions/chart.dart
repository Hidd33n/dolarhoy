import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final Color color;

  LineChartWidget({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // Cambia la relación de aspecto aquí
      child: Padding(
        padding: const EdgeInsets.all(10), // Ajusta los márgenes aquí
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _createSpots(),
                isCurved: true,
                color: color,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }
    return spots;
  }
}
