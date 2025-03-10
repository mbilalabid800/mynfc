// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/image_picker_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/provider/user_info_progress_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';

import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressRectangle(index: 1),
              SizedBox(width: DeviceDimensions.screenWidth(context) * 0.015),
              ProgressRectangle(index: 2),
              SizedBox(width: DeviceDimensions.screenWidth(context) * 0.015),
              ProgressRectangle(index: 3),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Lastly, tell us more about yourself ',
                style: TextStyle(
                    fontFamily: 'Barlow-Bold',
                    fontSize: 30,
                    color: AppColors.textColorBlue)),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                NameStep(pageController: pageController),
                CompanyInfoStep(pageController: pageController),
                ImageStep(),
              ],
            ),
          ),
          SizedBox(
            height: DeviceDimensions.screenHeight(context) * 0.02,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

class ProgressRectangle extends StatelessWidget {
  final int index;

  const ProgressRectangle({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProgressProvider>(
      builder: (context, progressProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: progressProvider.progress >= index
                ? AppColors.appBlueColor
                : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          width: DeviceDimensions.screenWidth(context) * 0.05,
          height: DeviceDimensions.screenHeight(context) * 0.0055,
        );
      },
    );
  }
}

class NameStep extends StatefulWidget {
  final PageController pageController;
  const NameStep({super.key, required this.pageController});

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  String countryName = 'Oman';
  String countryCode = '+968';
  String contactNumber = '';

  @override
  Widget build(BuildContext context) {
    final formState = Provider.of<UserInfoFormStateProvider>(context);
    // final formValidator =
    //     Provider.of<FormValidationProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        color: AppColors.screenBackground,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.95,
                child: TextField(
                  keyboardType: TextInputType.name, // Opens the letter keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z\s]')), // Allows only letters and spaces
                  ],
                  //maxLength: 25,
                  onChanged: (value) => formState.updateFirstName(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.firstNameError,
                    //labelText: 'First Name',
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),

            //last name with provider

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.95,
                child: TextField(
                  keyboardType: TextInputType.name, // Opens the letter keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z\s]')), // Allows only letters and spaces
                  ],

                  //maxLength: 25,
                  //controller: lastNameController,
                  onChanged: (value) => formState.updateLastName(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.lastNameError,
                    //labelText: 'Enter Last Name',
                    hintText: 'Last Name',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.95,
                child: IntlPhoneField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorFieldBorderColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.contactError,
                    //labelText: 'Enter Last Name',
                    hintText: 'Phone Numbers',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                  dropdownTextStyle: TextStyle(
                    color: AppColors.appBlueColor,
                  ),
                  initialCountryCode: 'OM',
                  onChanged: (phone) {
                    formState.updateContact(
                        phone.number, phone.countryCode, phone.countryISOCode);
                  },
                ),
              ),
            ),

            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.05,
            ),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              // height: DeviceDimensions.screenHeight(context) * 0.07,
              height: 49,
              child: Consumer<UserInfoFormStateProvider>(
                  builder: (context, formState, child) {
                return ElevatedButton(
                  onPressed: formState.isNameFormValid
                      ? () {
                          Provider.of<UserInfoProgressProvider>(context,
                                  listen: false)
                              .incrementProgress();

                          widget.pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Continue'),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyInfoStep extends StatefulWidget {
  final PageController pageController;

  const CompanyInfoStep({super.key, required this.pageController});

  @override
  State<CompanyInfoStep> createState() => _CompanyInfoStepState();
}

class _CompanyInfoStepState extends State<CompanyInfoStep> {
  final List<String> _items = [
    'Business',
    'Individual',
  ];

  int _connectionType = 1;
  // Initial selected value
  @override
  Widget build(BuildContext context) {
    final formState = Provider.of<UserInfoFormStateProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                height: DeviceDimensions.screenHeight(context) * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textFieldBorder,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    elevation: 1,
                    dropdownColor: AppColors.screenBackground,
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        size: DeviceDimensions.responsiveSize(context) * 0.07),
                    hint: Text(
                      'Category',
                      style: TextStyle(
                          color: AppColors.headingFontColor,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.03),
                    ),
                    value: _items.contains(formState.profileType)
                        ? formState.profileType
                        : null,
                    onChanged: (String? newValue) {
                      // //xyz
                      // formState.updateSelectedItem(newValue!);
                      if (newValue != null) {
                        formState.updateSelectedItem(newValue);
                      }
                    },
                    items: _items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: AppColors.appBlueColor,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.035,
                              fontFamily: 'Barlow-Regular'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                child: TextField(
                  //controller: companyNameController,
                  onChanged: (value) => formState.updateCompanyName(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.companyNameError,
                    //labelText: 'Enter Last Name',
                    hintText: 'Company Name',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                child: TextField(
                  //maxLength: 25,
                  //controller: designationController,
                  onChanged: (value) => formState.updateDesignation(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.designationError,
                    //labelText: 'Enter First Name',
                    hintText: 'Designation',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                child: TextFormField(
                  //controller: websiteController,
                  onChanged: (value) => formState.updateWebsiteLink(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.websiteLinkError,
                    //labelText: 'Enter Last Name',
                    hintText: 'Website Link',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                child: TextField(
                  //maxLength: 25,
                  //controller: websiteController,
                  onChanged: (value) => formState.updateCity(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.appBlueColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.cityNameError,
                    //labelText: 'Enter Last Name',
                    hintText: 'City',
                    hintStyle: TextStyle(
                        color: AppColors.greyText,
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                  width: DeviceDimensions.screenWidth(context) * 0.9,
                  child: Text(
                      "Please select one of the following option to connect with:",
                      style: TextStyle(
                          fontSize: DeviceDimensions.responsiveSize(context) *
                              0.035))),
            ),
            ListTile(
              title: Text('Only Company Connections',
                  style: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.035)),
              leading: Radio<int>(
                value: 1,
                activeColor: AppColors.appBlueColor,
                groupValue: _connectionType,
                onChanged: (int? value) {
                  setState(() {
                    _connectionType = value!;
                    formState.updateConnectionType(false);
                  });
                },
              ),
            ),
            ListTile(
              title: Text('All Connections',
                  style: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.035)),
              leading: Radio<int>(
                value: 2,
                activeColor: AppColors.appBlueColor,
                groupValue: _connectionType,
                onChanged: (int? value) {
                  setState(() {
                    _connectionType = value!;
                    formState.updateConnectionType(true);
                  });
                },
              ),
            ),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.05,
            ),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              height: 49,
              //height: DeviceDimensions.screenHeight(context) * 0.07,
              child: Consumer<UserInfoFormStateProvider>(
                  builder: (context, formState, child) {
                return ElevatedButton(
                  onPressed: formState.isCompanyInfoFormValid
                      ? () {
                          Provider.of<UserInfoProgressProvider>(context,
                                  listen: false)
                              .incrementProgress();

                          widget.pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Continue'),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class ImageStep extends StatelessWidget {
  const ImageStep({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final userInfoProvider = Provider.of<UserInfoFormStateProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            imageProvider.image == null
                ? Container(
                    width: DeviceDimensions.screenWidth(context) * 0.9,
                    height: DeviceDimensions.screenHeight(context) * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 14),
                              child: Text(
                                'Upload Image',
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.04,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 8),
                              child: Text(
                                'Profile Photo',
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.03,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                        SizedBox(
                          height: DeviceDimensions.screenHeight(context) * 0.03,
                        ),
                        Container(
                            //color: Colors.white,
                            height:
                                DeviceDimensions.screenHeight(context) * 0.2,
                            width: DeviceDimensions.screenWidth(context) * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  imageProvider.pickImage(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/uploadnew.svg',
                                  height:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.01,
                                  width:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.01,
                                ),
                              ),
                            ))
                      ],
                    ))
                : ClipOval(
                    child: Image.file(imageProvider.image!,
                        width: DeviceDimensions.screenHeight(context) * 0.25,
                        height: DeviceDimensions.screenHeight(context) * 0.25,
                        fit: BoxFit.cover),
                  ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.05),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              //height: DeviceDimensions.screenHeight(context) * 0.055,
              height: 49,
              child: ElevatedButton(
                onPressed: () {
                  imageProvider.pickImage(context);
                },
                style: ElevatedButton.styleFrom(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(6)),
                  backgroundColor: AppColors.appOrangeColor,
                  //disabledBackgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                    imageProvider.hasImage ? 'Upload Again' : 'Upload Image',
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.035)),
              ),
            ),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.03,
            ),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              // height: DeviceDimensions.screenHeight(context) * 0.055,
              height: 49,
              child: ElevatedButton(
                onPressed: imageProvider.hasImage
                    ? () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: DualRingLoader(), // Your custom loader
                            );
                          },
                        );
                        try {
                          // Assume you upload the image and get the URL
                          String imageUrl = await uploadImageAndGetUrl(
                              File(imageProvider.image!.path));
                          userInfoProvider.updateImageUrl(imageUrl);

                          await userInfoProvider.saveUserData();
                          // Delay for 3 seconds

                          //await Future.delayed(Duration(seconds: 3));

                          Navigator.pop(context);
                          // Navigate to another screen
                          // Navigator.pushNamed(context, '/home-screen');
                          //Navigator.pushNamed(context, '/mainNav-screen');
                          await AuthService()
                              .sendVerificationEmail(context: context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/email-verify',
                            (route) => false,
                          );
                        } catch (e) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  disabledBackgroundColor: Colors.grey,
                  backgroundColor: AppColors.appBlueColor,
                  foregroundColor: Colors.white, // Full-width button
                ), // Disable button if no image is selected
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImageAndGetUrl(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    //Create a ref to the Firebase storage
    Reference ref = storage
        .ref()
        .child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');

    //Upload the file to Firebase Storage
    UploadTask uploadTask = ref.putFile(imageFile);

    //Get the url after the upload is complete
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;

    // // Implement your image upload logic here and return the URL
    // return 'http://example.com/your_image_url'; // Replace with actual image URL
  }
}
