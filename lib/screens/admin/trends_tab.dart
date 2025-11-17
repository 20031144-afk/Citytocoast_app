import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendsTab extends StatelessWidget {
  const TrendsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _card(
            "Sentiment Trends Over Time",
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    _lineData([0.7, 0.68, 0.71, 0.73, 0.74], Colors.green),
                    _lineData([0.2, 0.22, 0.21, 0.19, 0.18], Colors.orange),
                    _lineData([0.1, 0.1, 0.08, 0.08, 0.07], Colors.red),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _card(
            "Volume Trends",
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 1200),
                        FlSpot(1, 1300),
                        FlSpot(2, 1400),
                        FlSpot(3, 1600),
                        FlSpot(4, 1900),
                      ],
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  LineChartBarData _lineData(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      spots: List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
      ),
      barWidth: 3,
    );
  }
}
