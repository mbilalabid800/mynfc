import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';

class ViewsChart extends StatelessWidget {
  final String uid; // User's UID

  const ViewsChart({super.key, required this.uid});

  Stream<List<BarChartGroupData>> fetchGroupedChartData(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("chartsData")
        .doc("profileViewsLog")
        .collection("logs")
        .snapshots()
        .map((snapshot) {
      // Group views by day
      final groupedData = <String, int>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final viewCount = data['viewCount'] ?? 0;

        // Format date as "YYYY-MM-DD"
        final day = "${timestamp.year}-${timestamp.month}-${timestamp.day}";
        groupedData[day] = (groupedData[day] ?? 0) + (viewCount as int);
      }

      // Convert grouped data to BarChartGroupData
      int index = 0;
      return groupedData.entries.map((entry) {
        final totalViews = entry.value;

        return BarChartGroupData(
          x: index++, // Increment index for each day
          barRods: [
            BarChartRodData(
              toY: totalViews.toDouble(), // Bar height
              color: const Color.fromARGB(255, 0, 6, 69),
              width: 3, // Bar width
              borderRadius: BorderRadius.circular(4), // Rounded corners
            ),
          ],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BarChartGroupData>>(
      stream: fetchGroupedChartData(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Icon(Icons.trending_up));
        } else {
          final barGroups = snapshot.data!;

          return BarChart(
            BarChartData(
              barGroups: barGroups,
              gridData: const FlGridData(
                show: false,
                drawVerticalLine: true,
                drawHorizontalLine: true,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (value, meta) {
                      // Show day as "Day X"
                      return Text(
                        "Day ${value.toInt() + 1}", // Customize label as needed
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (
                    _,
                    __,
                    ___,
                    ____,
                  ) =>
                      null,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class FullViewsChart extends StatelessWidget {
  final String uid; // User's UID

  const FullViewsChart({super.key, required this.uid});

  Stream<List<BarChartGroupData>> fetchGroupedChartData(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("chartsData")
        .doc("profileViewsLog")
        .collection("logs")
        .snapshots()
        .map((snapshot) {
      // Group views by day
      final groupedData = <String, int>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final viewCount = data['viewCount'] ?? 0;

        // Format date as "YYYY-MM-DD"
        final day = "${timestamp.year}-${timestamp.month}-${timestamp.day}";
        groupedData[day] = (groupedData[day] ?? 0) + (viewCount as int);
      }

      // Convert grouped data to BarChartGroupData
      int index = 0;
      return groupedData.entries.map((entry) {
        final totalViews = entry.value;

        return BarChartGroupData(
          x: index++, // Increment index for each day
          barRods: [
            BarChartRodData(
              toY: totalViews.toDouble(), // Bar height
              color: const Color.fromARGB(255, 0, 6, 69),
              width: 12, // Bar width
              borderRadius: BorderRadius.circular(2), // Rounded corners
            ),
          ],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BarChartGroupData>>(
      stream: fetchGroupedChartData(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        } else {
          final barGroups = snapshot.data!;

          return BarChart(
            BarChartData(
              barGroups: barGroups,
              gridData: const FlGridData(
                show: false,
                drawVerticalLine: true,
                drawHorizontalLine: true,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      // Show day as "Day X"
                      return Text(
                        "Day ${value.toInt() + 1}", // Customize label as needed
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.025,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class LinkTapChart extends StatelessWidget {
  final String uid;
  const LinkTapChart({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: FirestoreService().fetchSocialAppTaps(uid),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: BigThreeBounceLoader());
        // }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: SmallThreeBounceLoader());
        }

        final appCounts = snapshot.data!;
        final appNames = appCounts.keys.toList();
        final counts = appCounts.values.toList();

        return BarChart(
          BarChartData(
            barGroups: List.generate(appNames.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: counts[index].toDouble(),
                    width: 3,
                    color: const Color.fromARGB(255, 0, 6, 69),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }),
            gridData: const FlGridData(
              show: false,
              drawVerticalLine: true,
              drawHorizontalLine: true,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false, interval: 1),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: (value, meta) {
                    final appIndex = value.toInt();
                    if (appIndex >= 0 && appIndex < appNames.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            appNames[appIndex],
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.02),
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
              border: const Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (
                  _,
                  __,
                  ___,
                  ____,
                ) =>
                    null,
              ),
            ),
          ),
        );
      },
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

class SocialAppBarChart extends StatelessWidget {
  final String uid;

  const SocialAppBarChart({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: FirestoreService().fetchSocialAppTaps(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: BigThreeBounceLoader());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final appCounts = snapshot.data!;
        final appNames = appCounts.keys.toList();
        final counts = appCounts.values.toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              barGroups: List.generate(appNames.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: counts[index].toDouble(),
                      width: 12,
                      color: const Color.fromARGB(255, 0, 6, 69),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                );
              }),
              gridData: const FlGridData(
                show: false,
                drawVerticalLine: true,
                drawHorizontalLine: true,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final appIndex = value.toInt();
                      if (appIndex >= 0 && appIndex < appNames.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              appNames[appIndex],
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.02),
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
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
