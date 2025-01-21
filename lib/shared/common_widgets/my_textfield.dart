import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final String iconPath;
  final ValueChanged<String>? onChanged;
  final bool isPasswordField;
  final ValueNotifier<bool>? passwordVisibilityNotifier;
  final String? Function(String?)? validator;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    required this.iconPath,
    this.onChanged,
    this.isPasswordField = false,
    this.passwordVisibilityNotifier,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final passwordVisibility =
        passwordVisibilityNotifier ?? ValueNotifier(false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: ValueListenableBuilder<bool>(
        valueListenable: passwordVisibility,
        builder: (context, isPasswordVisible, _) {
          return TextFormField(
            controller: controller,
            obscureText: isPasswordField && !isPasswordVisible,
            style: TextStyle(
              height: DeviceDimensions.screenHeight(context) * 0.0026,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFA9A9A9),
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(iconPath),
              ),
              suffixIcon: isPasswordField
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        passwordVisibility.value = !isPasswordVisible;
                      },
                    )
                  : null,
              errorText: errorText,
              errorStyle: const TextStyle(
                color: AppColors.errorColor,
                fontSize: 14.0,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: errorText != null
                      ? AppColors.errorFieldBorderColor
                      : AppColors.textFieldBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.appBlueColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.errorFieldBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.errorFieldBorderColor),
              ),
            ),
            onChanged: onChanged,
            validator: validator,
          );
        },
      ),
    );
  }
}
