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
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Barlow-Regular',
              color: AppColors.textColorBlue,
            ),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                height: DeviceDimensions.screenHeight(context) * 0.0020),
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                color: AppColors.errorColor, // Color of the error text
                fontSize: 12.0, // Size of the error text
                //fontWeight: FontWeight.bold, // Weight of the error text
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
              // if (value!.isEmpty) {
              //   return 'Please enter employee $errorMessage';
              // }
              if (value == null || value.isEmpty) {
                return 'Please enter employee $errorMessage';
              }
              value = value.trim();

              if (title.toLowerCase() == 'email' &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }

              if (title.toLowerCase() == 'designation') {
                // Check if the input contains only valid characters (letters and spaces in the middle)
                if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
                  return 'Designation name must have charcaters';
                }

                if (value.length < 3) {
                  return 'Designation must be at least 3 characters long';
                }

                if (value.length > 25) {
                  return 'Designation must not exceed 25 characters';
                }
              }

              if (title.toLowerCase() == 'first name') {
                // Check if the input contains only valid characters (letters and spaces in the middle)
                if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
                  return 'First name must have charcaters';
                }

                if (value.length < 2) {
                  return 'First name must be at least 2 characters long';
                }

                if (value.length > 25) {
                  return 'First name must not exceed 25 characters';
                }
              }

              if (title.toLowerCase() == 'last name') {
                if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
                  return 'Last name must have charcaters';
                }

                if (value.length < 2) {
                  return 'Last name must be at least 2 characters long';
                }

                if (value.length > 25) {
                  return 'Last name must not exceed 25 characters';
                }
              }

              if (title.toLowerCase() == 'contact') {
                // Check if the input contains only numbers
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Contact must contain only numbers';
                }

                // Check if the input is exactly 8 characters long
                if (value.length != 8) {
                  return 'Contact must be exactly 8 digits long';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
