// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController massageController = TextEditingController();
  String? selectedSubject;
  final FocusNode subjectFocusNode = FocusNode();

  bool isLoading = false;

  Future<void> saveContactDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final DateTime timestamp = DateTime.now();
        String formattedTimestamp = timestamp.toString();
        // final uid = context.read<UserInfoFormStateProvider>().uid;
        await FirebaseFirestore.instance
            .collection("CustomerQueries")
            .doc(formattedTimestamp)
            .set(
          {
            'Name': nameController.text,
            'Email': emailController.text,
            'Subject': selectedSubject,
            'Message': massageController.text,
            'Time': timestamp,
            'isReplied': false,
          },
        );
        // SetOptions(merge: true));
        CustomSnackbar().snakBarMessage(context,
            "Your message has been sent!\nWe will respond you on your email shortly");

        nameController.clear();
        emailController.clear();
        massageController.clear();
        subjectFocusNode.unfocus();
        setState(() {
          selectedSubject = null;
        });
      } catch (e) {
        CustomSnackbar().snakBarError(context, "'Failed to send message: $e'");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    massageController.dispose();
    subjectFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: const CustomAppBar(title: 'Contact us'),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    "Get in touch",
                    style: TextStyle(
                      fontFamily: 'Barlow-Bold',
                      fontWeight: FontWeight.bold,
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.055,
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.005),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    "If you have any questions or need help, please fill out the form below. We do our best to respond within 1 business day.",
                    style: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontWeight: FontWeight.bold,
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.033,
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.025),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          style: TextStyle(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.0024),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: TextStyle(
                              color: const Color(0xFFA9A9A9),
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.043,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: const TextStyle(
                              color: AppColors
                                  .errorColor, // Color of the error text
                              fontSize: 14.0, // Size of the error text
                              fontWeight:
                                  FontWeight.bold, // Weight of the error text
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.appBlueColor),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Full Name';
                            }
                            if (RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Full Name cannot contain numbers';
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.012),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          style: TextStyle(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.0024),
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.043,
                              color: const Color(0xFFA9A9A9),
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: const TextStyle(
                              color: AppColors
                                  .errorColor, // Color of the error text
                              fontSize: 14.0, // Size of the error text
                              fontWeight:
                                  FontWeight.bold, // Weight of the error text
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.appBlueColor),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                            final emailPattern =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailPattern.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.012),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: DropdownButtonFormField<String>(
                          focusNode: subjectFocusNode,
                          borderRadius: BorderRadius.circular(25),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Subject",
                            hintStyle: TextStyle(
                              color: const Color(0xFFA9A9A9),
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.043,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: const TextStyle(
                              color: AppColors.errorColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.errorFieldBorderColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.errorFieldBorderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.appBlueColor),
                            ),
                          ),
                          value: selectedSubject,
                          items: [
                            customdropdown("No subject", 'No subject', context),
                            customdropdown(
                                "Book a demo", 'Book a demo', context),
                            customdropdown(
                                "Place a order", 'Place a order', context),
                            customdropdown("About my existing order",
                                'About my existing order', context),
                            customdropdown(
                                "I need a help for  a account or cards",
                                'I need a help for  a account or cards',
                                context),
                            customdropdown("Shipping & Billing",
                                'Shipping & Billing', context),
                            customdropdown(
                                "Troubleshooting", 'Troubleshooting', context),
                            customdropdown("Big Organization",
                                'Big Organization', context),
                            customdropdown("Other", 'Other', context),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedSubject = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a subject';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.012),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextFormField(
                          maxLines: 4,
                          style: TextStyle(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.0026),
                          controller: massageController,
                          decoration: InputDecoration(
                            hintText: "Your Message",
                            hintStyle: TextStyle(
                              color: const Color(0xFFA9A9A9),
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.043,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: const TextStyle(
                              color: AppColors
                                  .errorColor, // Color of the error text
                              fontSize: 14.0, // Size of the error text
                              fontWeight:
                                  FontWeight.bold, // Weight of the error text
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.errorFieldBorderColor)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.appBlueColor),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a message';
                            }
                            if (value.length < 10) {
                              return 'Message must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.030),
                      ElevatedButton(
                        onPressed: () {
                          saveContactDetails();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                DeviceDimensions.screenWidth(context) * 0.24,
                            vertical: 10,
                          ),
                          backgroundColor: AppColors.appBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Send Message",
                          style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.045,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.020),
                Padding(
                  padding: const EdgeInsets.only(left: 22.0),
                  child: Text(
                    "Reach us at:",
                    style: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.045,
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.010),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                              "assets/icons/email.svg"), // Email icon
                        ),
                        Text(
                          "example@gmail.com",
                          style: TextStyle(
                            color: const Color(0xFFA9A9A9),
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.046,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.020),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SvgPicture.asset("assets/icons/phone2.svg"),
                        ),
                        Text(
                          "+968 123456789",
                          style: TextStyle(
                            color: const Color(0xFFA9A9A9),
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.046,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.040),
              ],
            ),
            if (isLoading)
              Positioned(
                bottom: DeviceDimensions.screenHeight(context) * 0.50,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white54,
                  child: Center(
                    child: DualRingLoader(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> customdropdown(
      String value, String subject, BuildContext context) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        subject,
        style: TextStyle(
          fontSize: DeviceDimensions.responsiveSize(context) * 0.043,
          fontFamily: 'Barlow-Regular',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
