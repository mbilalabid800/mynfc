import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class AddEmployeeWidget extends StatelessWidget {
  const AddEmployeeWidget(
      {super.key,
      required this.title,
      required this.controller,
      required this.errorMessage});
  final String title;
  final String errorMessage;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Barlow-Regular',
            color: AppColors.textColorBlue,
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                height: DeviceDimensions.screenHeight(context) * 0.0020),
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                color: AppColors.errorColor, // Color of the error text
                fontSize: 14.0, // Size of the error text
                fontWeight: FontWeight.bold, // Weight of the error text
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFFA9A9A9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFFA9A9A9)),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.errorFieldBorderColor)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.errorFieldBorderColor)),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter employee $errorMessage';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
