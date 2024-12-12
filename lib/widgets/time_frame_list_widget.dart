// lib/widgets/time_frame_list.dart

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class TimeFrameList extends StatefulWidget {
  final Function(String) onSelected; // Callback for the selected time frame

  const TimeFrameList({super.key, required this.onSelected});

  @override
  State<TimeFrameList> createState() => _TimeFrameListState();
}

class _TimeFrameListState extends State<TimeFrameList> {
  final List<String> timeFrames = [
    "Today",
    "Yesterday",
    "Week",
    "Month",
    "Yearly"
  ];
  String selectedTimeFrame = "Today"; // Default selected time frame

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: DeviceDimensions.screenHeight(context) *
            0.05, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: timeFrames.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeFrame =
                      timeFrames[index]; // Update the selected time frame
                });
                widget.onSelected(timeFrames[
                    index]); // Call the callback with the selected time frame
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: selectedTimeFrame == timeFrames[index]
                      ? AppColors.appBlueColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    timeFrames[index],
                    style: TextStyle(
                      color: selectedTimeFrame == timeFrames[index]
                          ? Colors.white
                          : AppColors.appBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
