// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

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
              color: AppColors.appOrangeColor,
              width: 5, // Bar width
              borderRadius: BorderRadius.circular(1), // Rounded corners
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
          return Center(
              child: Icon(Icons.trending_up, color: AppColors.appOrangeColor));
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
                          color: AppColors.textColorBlue,
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
                  left: BorderSide(color: AppColors.appBlueColor, width: 1),
                  bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
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

  Stream<ChartData> fetchGroupedChartData(String uid) {
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
        //final day = "${timestamp.year}-${timestamp.month}-${timestamp.day}";
        // final day = DateFormat("MMM-d").format(timestamp);
        final day = DateFormat("MMM dd").format(timestamp);
        groupedData[day] = (groupedData[day] ?? 0) + (viewCount as int);
      }

      // Convert grouped data to BarChartGroupData
      // int index = 0;
      // return groupedData.entries.map((entry) {
      //   final totalViews = entry.value;

      //   return BarChartGroupData(
      //     x: index++, // Increment index for each day
      //     barRods: [
      //       BarChartRodData(
      //         toY: totalViews.toDouble(), // Bar height
      //         color: AppColors.appOrangeColor,
      //         width: 14, // Bar width
      //         borderRadius: BorderRadius.circular(1), // Rounded corners
      //       ),
      //     ],
      //   );
      // }).toList();

      int index = 0;
      final barGroups = groupedData.entries.map((entry) {
        return BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: AppColors.appOrangeColor,
              width: 14,
              borderRadius: BorderRadius.circular(1),
            ),
          ],
        );
      }).toList();

      // Return chart data with barGroups and corresponding dates
      return ChartData(
        barGroups: barGroups,
        dates: groupedData.keys.toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChartData>(
      stream: fetchGroupedChartData(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.barGroups.isEmpty) {
          return const Center(child: Text("No data available"));
        } else {
          final chartData = snapshot.data!;
          final barGroups = snapshot.data!;
          // Extract actual dates for X-axis labels
          final dates = chartData.dates;

          return BarChart(
            BarChartData(
              barGroups: chartData.barGroups,
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
                      int index = value.toInt();
                      if (index >= 0 && index < dates.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              dates[index], // Customize label as needed
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: AppColors.textColorBlue,
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
                  left: BorderSide(color: AppColors.appBlueColor, width: 1),
                  bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
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
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tap data available'));
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
                    width: 5,
                    color: AppColors.appOrangeColor,
                    borderRadius: BorderRadius.circular(1),
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
                left: BorderSide(color: AppColors.appBlueColor, width: 1),
                bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
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
              BarChartRodData(toY: 15, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //tuesday
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 3, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //wednesday
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 4, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //Thursday
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 7, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //friday
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(toY: 13, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //saturday
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(toY: 8, width: 3, color: AppColors.appBlueColor),
            ],
          ),
          //sunday
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(toY: 18, width: 3, color: AppColors.appBlueColor),
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
                  toY: tapsPerDay[0], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //tuesday
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[1], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //wednesday
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[2], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //Thursday
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[3], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //friday
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[4], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //saturday
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[5], width: 10, color: AppColors.appBlueColor),
            ],
          ),
          //sunday
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                  toY: tapsPerDay[6], width: 10, color: AppColors.appBlueColor),
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
  }
}

class AddedConnectionChart extends StatelessWidget {
  const AddedConnectionChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Access the connections list from the provider
    final connections = context.watch<ConnectionProvider>().addedConnections;

    // Group data by date
    final Map<String, int> dateCounts = {};
    final DateFormat formatter = DateFormat('MMM dd');
    // Example: "Dec 09"
    for (var connection in connections) {
      String date = formatter.format(connection.timestamp.toDate());
      dateCounts[date] = (dateCounts[date] ?? 0) + 1;
    }

    // Sort dates in chronological order
    final sortedKeys = dateCounts.keys.toList()
      ..sort((a, b) => formatter.parse(a).compareTo(formatter.parse(b)));

    // final totalConnections =
    //     dateCounts.values.fold(0, (sum, count) => sum + count);
    // Convert sorted data into BarChartGroupData
    List<BarChartGroupData> barGroups = [];
    for (int index = 0; index < sortedKeys.length; index++) {
      String date = sortedKeys[index];
      int count = dateCounts[date]!;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: AppColors.appOrangeColor,
              width: 14,
              borderRadius: BorderRadius.circular(1),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        gridData: const FlGridData(
          show: false,
          drawHorizontalLine: true,
          drawVerticalLine: true,
        ),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    );
                  }
                  return SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < sortedKeys.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.rotate(
                        angle: -0.5,
                        child: Text(
                          sortedKeys[value.toInt()],
                          style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.02),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            )),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: AppColors.appBlueColor, width: 1),
            bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
          ),
        ),
      ),
    );
  }
}

// class SocialApp_BarChart extends StatelessWidget {
//   final String uid;

//   const SocialApp_BarChart({super.key, required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, int>>(
//       future: FirestoreService().fetchSocialAppTaps(uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: BigThreeBounceLoader());
//         }
//         if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No data available'));
//         }

//         final appCounts = snapshot.data!;
//         final appNames = appCounts.keys.toList();
//         final counts = appCounts.values.toList();

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: BarChart(
//             BarChartData(
//               barGroups: List.generate(appNames.length, (index) {
//                 return BarChartGroupData(
//                   x: index,
//                   barRods: [
//                     BarChartRodData(
//                       toY: counts[index].toDouble(),
//                       width: 14,
//                       color: AppColors.appOrangeColor,
//                       borderRadius: BorderRadius.circular(1),
//                     ),
//                   ],
//                 );
//               }),
//               gridData: const FlGridData(
//                 show: false,
//                 drawVerticalLine: true,
//                 drawHorizontalLine: true,
//               ),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true, interval: 1),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: false,
//                   ),
//                 ),
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: false,
//                   ),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       final appIndex = value.toInt();
//                       if (appIndex >= 0 && appIndex < appNames.length) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Transform.rotate(
//                             angle: -0.5,
//                             child: Text(
//                               appNames[appIndex],
//                               style: TextStyle(
//                                   fontSize:
//                                       DeviceDimensions.responsiveSize(context) *
//                                           0.02),
//                             ),
//                           ),
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     },
//                     reservedSize: 30,
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(
//                 show: true,
//                 border: const Border(
//                   left: BorderSide(color: AppColors.appBlueColor, width: 1),
//                   bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class ConnectionChart extends StatelessWidget {
  const ConnectionChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Access the connections list from the provider
    final connections = context.watch<ConnectionProvider>().addedConnections;

    // Group data by date
    final Map<String, int> dateCounts = {};
    final DateFormat formatter = DateFormat('MMM dd');
    // Example: "Dec 09"
    for (var connection in connections) {
      String date = formatter.format(connection.timestamp.toDate());
      dateCounts[date] = (dateCounts[date] ?? 0) + 1;
    }

    // Sort dates in chronological order
    final sortedKeys = dateCounts.keys.toList()
      ..sort((a, b) => formatter.parse(a).compareTo(formatter.parse(b)));

    // Convert sorted data into BarChartGroupData
    List<BarChartGroupData> barGroups = [];
    for (int index = 0; index < sortedKeys.length; index++) {
      String date = sortedKeys[index];
      int count = dateCounts[date]!;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: AppColors.appOrangeColor,
              width: 5,
              borderRadius: BorderRadius.circular(1),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < sortedKeys.length) {
                    return Text(
                      sortedKeys[value.toInt()],
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    );
                  }
                  return SizedBox.shrink();
                },
                reservedSize: 24,
              ),
            )),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: AppColors.appBlueColor, width: 1),
            bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
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
        gridData: FlGridData(
            show: false, drawHorizontalLine: true, drawVerticalLine: true),
      ),
    );
  }
}

class ChartData {
  final List<BarChartGroupData> barGroups;
  final List<String> dates;

  ChartData({required this.barGroups, required this.dates});
}

class SocialApp_BarChart extends StatelessWidget {
  final String uid;

  const SocialApp_BarChart({super.key, required this.uid});

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
                      width: 14,
                      color: AppColors.appOrangeColor,
                      borderRadius: BorderRadius.circular(1),
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
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: AppColors.appBlueColor, width: 1),
                  bottom: BorderSide(color: AppColors.appBlueColor, width: 1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
