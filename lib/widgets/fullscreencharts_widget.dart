import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FullViewsChart extends StatelessWidget {
  const FullViewsChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 10),
              FlSpot(3, 7),
              FlSpot(4, 12),
              FlSpot(5, 13),
              FlSpot(6, 17),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.transparent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class LinkTapChart extends StatelessWidget {
  const LinkTapChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(4, 3),
              FlSpot(6, 6),
              FlSpot(8, 7),
              FlSpot(10, 9),
              FlSpot(10, 13),
              FlSpot(12, 17),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              color: Colors.transparent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class RateChart extends StatelessWidget {
  const RateChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(5, 2),
              FlSpot(5, 2),
              FlSpot(6, 2),
              FlSpot(3, 2),
              FlSpot(8, 2),
              FlSpot(8, 2),
              FlSpot(4, 2),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              color: Colors.transparent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class NewContactChart extends StatelessWidget {
  const NewContactChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, 8),
              FlSpot(1, 2),
              FlSpot(5, 10),
              FlSpot(7, 6),
              FlSpot(10, 12),
              FlSpot(10, 3),
              FlSpot(12, 17),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              color: Colors.transparent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
