// // ignore_for_file: file_names, use_build_context_synchronously

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:nfc_app/constants/appColors.dart';
// import 'package:nfc_app/responsive/device_dimensions.dart';
// import 'package:nfc_app/widgets/custom_snackbar_widget.dart';

// class SetPassword extends StatefulWidget {
//   const SetPassword({super.key});

//   @override
//   State<SetPassword> createState() => _SetPasswordState();
// }

// class _SetPasswordState extends State<SetPassword> {
//   final int _currentDot = 2;
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   Future<void> _updatePassword() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         String newPassword = newPasswordController.text;
//         String actionCode = '755011';

//         await FirebaseAuth.instance.confirmPasswordReset(
//           code: actionCode,
//           newPassword: newPassword,
//         );
//         CustomSnackbar()
//             .snakBarMessage(context, "Password updated successfully.");
//         Navigator.pushReplacementNamed(context, '/login-screen');
//       } catch (e) {
//         CustomSnackbar().snakBarError(
//             context, "Failed to update password: ${e.toString()}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: DeviceDimensions.screenHeight(context),
//           width: DeviceDimensions.screenWidth(context),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: Colors.white,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 SizedBox(
//                     height: DeviceDimensions.screenHeight(context) * 0.095),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     3,
//                     (index) {
//                       return AnimatedContainer(
//                         margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                         duration: const Duration(milliseconds: 500),
//                         width: 20,
//                         height: 7.0,
//                         decoration: BoxDecoration(
//                           color: _currentDot == index
//                               ? AppColors.appBlueColor
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                     height: DeviceDimensions.screenHeight(context) * 0.060),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Set password",
//                       style: TextStyle(
//                           fontSize:
//                               DeviceDimensions.responsiveSize(context) * 0.073,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Barlow-Bold'),
//                     ),
//                     SizedBox(
//                         height: DeviceDimensions.screenHeight(context) * 0.015),
//                     Text(
//                       "Password Requirements:",
//                       style: TextStyle(
//                           fontSize:
//                               DeviceDimensions.responsiveSize(context) * 0.039,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Barlow-Bold'),
//                     ),
//                     SizedBox(
//                         height: DeviceDimensions.screenHeight(context) * 0.010),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text(
//                         "•  Must contain at least one uppercase letter.",
//                         style: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.039,
//                             fontFamily: 'Barlow-Regular'),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text(
//                         "•  Must contain at least one lowercase letter.",
//                         style: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.039,
//                             fontFamily: 'Barlow-Regular'),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text(
//                         "•  Must include at least one special character.",
//                         style: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.039,
//                             fontFamily: 'Barlow-Regular'),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text(
//                         "•  Must include at least one number.",
//                         style: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.039,
//                             fontFamily: 'Barlow-Regular'),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text(
//                         "•  Must be at least 8 characters long.",
//                         style: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.039,
//                             fontFamily: 'Barlow-Regular'),
//                       ),
//                     ),
//                     SizedBox(
//                         height: DeviceDimensions.screenHeight(context) * 0.045),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: newPasswordController,
//                             decoration: InputDecoration(
//                               hintText: "New Password",
//                               hintStyle: const TextStyle(
//                                 color: Color(0xFFA9A9A9),
//                                 fontFamily: 'Barlow-Regular',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 12.0, bottom: 12, left: 20, right: 10),
//                                 child: SvgPicture.asset(
//                                   "assets/icons/password.svg",
//                                   height: 17,
//                                   width: 17,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide:
//                                     const BorderSide(color: Color(0xFFA9A9A9)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide:
//                                     const BorderSide(color: Color(0xFFA9A9A9)),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter Password';
//                               }
//                               if (value.length < 8) {
//                                 return 'Password must be at least 8 characters long';
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(
//                               height: DeviceDimensions.screenHeight(context) *
//                                   0.025),
//                           TextFormField(
//                             controller: confirmPasswordController,
//                             decoration: InputDecoration(
//                               hintText: "Confirm Password",
//                               hintStyle: const TextStyle(
//                                 color: Color(0xFFA9A9A9),
//                                 fontFamily: 'Barlow-Regular',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 12.0, bottom: 12, left: 20, right: 10),
//                                 child: SvgPicture.asset(
//                                   "assets/icons/password.svg",
//                                   height: 17,
//                                   width: 17,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide:
//                                     const BorderSide(color: Color(0xFFA9A9A9)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide:
//                                     const BorderSide(color: Color(0xFFA9A9A9)),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter Password';
//                               }
//                               if (value.length < 8) {
//                                 return 'Password must be at least 8 characters long';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                     height: DeviceDimensions.screenHeight(context) * 0.065),
//                 SizedBox(
//                   width: DeviceDimensions.screenWidth(context) * 90,
//                   height: 45,
//                   child: ElevatedButton(
//                     onPressed: () => _updatePassword(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.appBlueColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                     child: Text(
//                       'Save modification',
//                       style: TextStyle(
//                         fontSize:
//                             DeviceDimensions.responsiveSize(context) * 0.0445,
//                         color: Colors.white,
//                         fontFamily: 'Barlow-Regular',
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
