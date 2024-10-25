import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViewsChart extends StatelessWidget {
  const ViewsChart({
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
              const FlSpot(50, 350),
              const FlSpot(90, 480),
              const FlSpot(100, 500),
              const FlSpot(120, 520),
              const FlSpot(150, 450),
              const FlSpot(180, 480),
              const FlSpot(220, 530),
              const FlSpot(280, 530),
              const FlSpot(320, 580),
              const FlSpot(380, 600),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: const FlDotData(show: false),
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

class FullViewsChart extends StatelessWidget {
  const FullViewsChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Show titles on the Y axis (left)
              interval: 100, // Interval between Y axis titles
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 50, // Reserve space for the left titles
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 10, // Hide titles on the top
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 10, // Hide titles on the right
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.transparent), // Hide right border
            top: BorderSide(color: Colors.transparent), // Hide top border
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(50, 350),
              const FlSpot(90, 480),
              const FlSpot(100, 500),
              const FlSpot(120, 520),
              const FlSpot(150, 450),
              const FlSpot(180, 480),
              const FlSpot(220, 530),
              const FlSpot(280, 530),
              const FlSpot(320, 580),
              const FlSpot(380, 600),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: const FlDotData(show: true),
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

class LinkTapChart extends StatelessWidget {
  const LinkTapChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1),
              const FlSpot(4, 3),
              const FlSpot(6, 6),
              const FlSpot(8, 7),
              const FlSpot(10, 9),
              const FlSpot(10, 13),
              const FlSpot(12, 17),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: const FlDotData(show: false),
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

class CardTapsChart extends StatelessWidget {
  const CardTapsChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: 15,
        barGroups: [
          //Monday
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 15, width: 3, color: Colors.black),
            ],
          ),
          //tuesday
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 3, width: 3, color: Colors.black),
            ],
          ),
          //wednesday
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 4, width: 3, color: Colors.black),
            ],
          ),
          //Thursday
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 7, width: 3, color: Colors.black),
            ],
          ),
          //friday
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(toY: 13, width: 3, color: Colors.black),
            ],
          ),
          //saturday
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(toY: 8, width: 3, color: Colors.black),
            ],
          ),
          //sunday
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(toY: 18, width: 3, color: Colors.black),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          show: false,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Mon');
                  case 1:
                    return Text('Tue');
                  case 2:
                    return Text('Wed');
                  case 3:
                    return Text('Thur');
                  case 4:
                    return Text('Fri');
                  case 5:
                    return Text('Sat');
                  case 6:
                    return Text('Sun');

                  default:
                    return Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 25,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );

    // return LineChart(
    //   LineChartData(
    //     gridData: const FlGridData(show: false),
    //     titlesData: const FlTitlesData(show: false),
    //     borderData: FlBorderData(show: false),
    //     lineBarsData: [
    //       LineChartBarData(
    //         spots: [
    //           const FlSpot(5, 2),
    //           const FlSpot(5, 2),
    //           const FlSpot(6, 2),
    //           const FlSpot(3, 2),
    //           const FlSpot(8, 2),
    //           const FlSpot(8, 2),
    //           const FlSpot(4, 2),
    //         ],
    //         isCurved: true,
    //         color: Colors.black,
    //         barWidth: 2,
    //         dotData: const FlDotData(show: false),
    //         belowBarData: BarAreaData(
    //           show: false,
    //           color: Colors.transparent.withOpacity(0.3),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class FullCardTapsChart extends StatelessWidget {
  // Tap counts for each day (Monday to Sunday)
  final List<double> tapsPerDay;
  const FullCardTapsChart({
    super.key,
    required this.tapsPerDay,
  });

// Tap counts for each day (Monday to Sunday)
  //final List<double> tapsPerDay ;

  @override
  Widget build(BuildContext context) {
    // Calculate the total number of taps
    //double totalTaps = tapsPerDay.reduce((a, b) => a + b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 25,
        barGroups: [
          //Monday
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[0], width: 10, color: Colors.black),
            ],
          ),
          //tuesday
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[1], width: 10, color: Colors.black),
            ],
          ),
          //wednesday
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[2], width: 10, color: Colors.black),
            ],
          ),
          //Thursday
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[3], width: 10, color: Colors.black),
            ],
          ),
          //friday
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[4], width: 10, color: Colors.black),
            ],
          ),
          //saturday
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[5], width: 10, color: Colors.black),
            ],
          ),
          //sunday
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[6], width: 10, color: Colors.black),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Mon');
                  case 1:
                    return Text('Tue');
                  case 2:
                    return Text('Wed');
                  case 3:
                    return Text('Thur');
                  case 4:
                    return Text('Fri');
                  case 5:
                    return Text('Sat');
                  case 6:
                    return Text('Sun');

                  default:
                    return Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 28,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );

    // return LineChart(
    //   LineChartData(
    //     gridData: const FlGridData(
    //       show: true,
    //       drawVerticalLine: true,
    //       drawHorizontalLine: true,
    //     ),
    //     titlesData: FlTitlesData(
    //       show: true,
    //       bottomTitles: AxisTitles(
    //         sideTitles: SideTitles(
    //           showTitles: true,
    //           reservedSize: 20,
    //           getTitlesWidget: (value, meta) {
    //             switch (value.toInt()) {
    //               case 1:
    //                 return const Text(
    //                   'Jan',
    //                   style: TextStyle(fontSize: 10),
    //                 );
    //               case 2:
    //                 return const Text('Feb', style: TextStyle(fontSize: 9));
    //               case 3:
    //                 return const Text('Mar', style: TextStyle(fontSize: 9));
    //               case 4:
    //                 return const Text('Apr', style: TextStyle(fontSize: 9));
    //               case 5:
    //                 return const Text('May', style: TextStyle(fontSize: 9));
    //               case 6:
    //                 return const Text('Jun', style: TextStyle(fontSize: 9));
    //               case 7:
    //                 return const Text('Jul', style: TextStyle(fontSize: 9));
    //               case 8:
    //                 return const Text('Aug', style: TextStyle(fontSize: 9));
    //               case 9:
    //                 return const Text('Sep', style: TextStyle(fontSize: 9));
    //               case 10:
    //                 return const Text('Oct', style: TextStyle(fontSize: 9));
    //               case 11:
    //                 return const Text('Nov', style: TextStyle(fontSize: 9));
    //               case 12:
    //                 return const Text('Dec', style: TextStyle(fontSize: 9));
    //               default:
    //                 return const Text('', style: TextStyle(fontSize: 9));
    //             }
    //           },
    //           interval: 1,
    //         ),
    //       ),
    //       leftTitles: AxisTitles(
    //         sideTitles: SideTitles(
    //           showTitles: true, // Show titles on the Y axis (left)
    //           interval: 1, // Interval between Y axis titles
    //           getTitlesWidget: (value, meta) {
    //             return Text(
    //               value.toInt().toString(),
    //               style: const TextStyle(
    //                 color: Colors.black,
    //                 fontSize: 10,
    //               ),
    //             );
    //           },
    //           reservedSize: 20, // Reserve space for the left titles
    //         ),
    //       ),
    //       topTitles: const AxisTitles(
    //         sideTitles: SideTitles(
    //           showTitles: false,
    //           reservedSize: 10, // Hide titles on the top
    //         ),
    //       ),
    //       rightTitles: const AxisTitles(
    //         sideTitles: SideTitles(
    //           showTitles: false,
    //           reservedSize: 10, // Hide titles on the right
    //         ),
    //       ),
    //     ),
    //     borderData: FlBorderData(
    //       show: true,
    //       border: const Border(
    //         left: BorderSide(color: Colors.black, width: 1),
    //         bottom: BorderSide(color: Colors.black, width: 1),
    //         right: BorderSide(color: Colors.transparent), // Hide right border
    //         top: BorderSide(color: Colors.transparent), // Hide top border
    //       ),
    //     ),
    //     lineBarsData: [
    //       LineChartBarData(
    //         spots: [
    //           const FlSpot(1, 0),
    //           const FlSpot(2, 3),
    //           const FlSpot(3, 6),
    //           const FlSpot(4, 2),
    //           const FlSpot(5, 3),
    //           const FlSpot(6, 4),
    //           const FlSpot(7, 5),
    //           const FlSpot(8, 7),
    //           const FlSpot(9, 8),
    //           const FlSpot(10, 8),
    //           const FlSpot(11, 10),
    //           const FlSpot(12, 8),
    //         ],
    //         isCurved: true,
    //         color: const Color.fromARGB(255, 69, 69, 69),
    //         barWidth: 2,
    //         dotData: const FlDotData(show: false),
    //         belowBarData: BarAreaData(
    //           show: false,
    //           color: Colors.transparent.withOpacity(0.3),
    //         ),
    //       ),
    //       LineChartBarData(
    //         spots: [
    //           const FlSpot(1, 3),
    //           const FlSpot(2, 4),
    //           const FlSpot(3, 5),
    //           const FlSpot(4, 3),
    //           const FlSpot(5, 5),
    //           const FlSpot(6, 2),
    //           const FlSpot(7, 4),
    //           const FlSpot(8, 6),
    //           const FlSpot(9, 5),
    //           const FlSpot(10, 7),
    //           const FlSpot(11, 9),
    //           const FlSpot(12, 6),
    //         ],
    //         isCurved: true,
    //         color: const Color.fromARGB(255, 94, 45, 209),
    //         barWidth: 2,
    //         dotData: const FlDotData(show: true),
    //         belowBarData: BarAreaData(
    //           show: false,
    //           color: Colors.transparent.withOpacity(0.3),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(1, 0),
              const FlSpot(2, 3),
              const FlSpot(3, 6),
              const FlSpot(4, 2),
              const FlSpot(5, 3),
              const FlSpot(6, 4),
              const FlSpot(7, 5),
              const FlSpot(8, 7),
              const FlSpot(9, 8),
              const FlSpot(10, 8),
              const FlSpot(11, 10),
              const FlSpot(12, 8),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 2,
            dotData: const FlDotData(show: false),
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

class FullNewContactChart extends StatelessWidget {
  const FullNewContactChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return const Text(
                      'Jan',
                      style: TextStyle(fontSize: 10),
                    );
                  case 2:
                    return const Text('Feb', style: TextStyle(fontSize: 9));
                  case 3:
                    return const Text('Mar', style: TextStyle(fontSize: 9));
                  case 4:
                    return const Text('Apr', style: TextStyle(fontSize: 9));
                  case 5:
                    return const Text('May', style: TextStyle(fontSize: 9));
                  case 6:
                    return const Text('Jun', style: TextStyle(fontSize: 9));
                  case 7:
                    return const Text('Jul', style: TextStyle(fontSize: 9));
                  case 8:
                    return const Text('Aug', style: TextStyle(fontSize: 9));
                  case 9:
                    return const Text('Sep', style: TextStyle(fontSize: 9));
                  case 10:
                    return const Text('Oct', style: TextStyle(fontSize: 9));
                  case 11:
                    return const Text('Nov', style: TextStyle(fontSize: 9));
                  case 12:
                    return const Text('Dec', style: TextStyle(fontSize: 9));
                  default:
                    return const Text('', style: TextStyle(fontSize: 9));
                }
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Show titles on the Y axis (left)
              interval: 1, // Interval between Y axis titles
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 20, // Reserve space for the left titles
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 10, // Hide titles on the top
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 10, // Hide titles on the right
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.transparent), // Hide right border
            top: BorderSide(color: Colors.transparent), // Hide top border
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(1, 0),
              const FlSpot(2, 3),
              const FlSpot(3, 6),
              const FlSpot(4, 2),
              const FlSpot(5, 3),
              const FlSpot(6, 4),
              const FlSpot(7, 5),
              const FlSpot(8, 7),
              const FlSpot(9, 8),
              const FlSpot(10, 8),
              const FlSpot(11, 10),
              const FlSpot(12, 8),
            ],
            isCurved: true,
            color: const Color.fromARGB(255, 69, 69, 69),
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              color: Colors.transparent.withOpacity(0.3),
            ),
          ),
          LineChartBarData(
            spots: [
              const FlSpot(1, 3),
              const FlSpot(2, 4),
              const FlSpot(3, 5),
              const FlSpot(4, 3),
              const FlSpot(5, 5),
              const FlSpot(6, 2),
              const FlSpot(7, 4),
              const FlSpot(8, 6),
              const FlSpot(9, 5),
              const FlSpot(10, 7),
              const FlSpot(11, 9),
              const FlSpot(12, 6),
            ],
            isCurved: true,
            color: const Color.fromARGB(255, 94, 45, 209),
            barWidth: 2,
            dotData: const FlDotData(show: true),
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
