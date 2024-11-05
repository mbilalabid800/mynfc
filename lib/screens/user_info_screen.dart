// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/image_picker_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/provider/user_info_progress_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Scaffold(
        //backgroundColor: Colors.white,
        backgroundColor: AppColors.screenBackground,
        body: Column(children: [
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
                style: TextStyle(fontFamily: 'Barlow-Bold', fontSize: 30)),
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
        ]));
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
            color:
                progressProvider.progress >= index ? Colors.black : Colors.grey,
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
    final formState =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);

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
                  onChanged: (value) => formState.updateFirstName(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.95,
                child: TextField(
                  //controller: lastNameController,
                  onChanged: (value) => formState.updateLastName(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
              child: Container(
                width: DeviceDimensions.screenWidth(context) * 0.95,
                height: DeviceDimensions.screenHeight(context) * 0.062,
                decoration: BoxDecoration(
                    border: Border.all(
                      //test
                      color: AppColors.textFieldBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (CountryCode code) {
                        setState(() {
                          countryName = code.name!;
                          formState.updateCountryName(countryName);
                          countryCode = code.dialCode!;
                          formState.updateContact(contactNumber, countryCode);
                        });
                        print(countryName);
                      },

                      initialSelection: 'OM', // Default country code
                      favorite: const [
                        '+968',
                        'OM'
                      ], // You can add favorite codes here

                      countryList: const [
                        {'name': 'Oman', 'code': 'OM', 'dial_code': '+968'},
                        {
                          'name': 'Afghanistan',
                          'code': 'AF',
                          'dial_code': '+93'
                        },
                        {'name': 'Albania', 'code': 'AL', 'dial_code': '+355'},
                        {'name': 'Algeria', 'code': 'DZ', 'dial_code': '+213'},
                        {'name': 'Argentina', 'code': 'AR', 'dial_code': '+54'},
                        {'name': 'Australia', 'code': 'AU', 'dial_code': '+61'},
                        {'name': 'Austria', 'code': 'AT', 'dial_code': '+43'},
                        {'name': 'Bahrain', 'code': 'BH', 'dial_code': '+973'},
                        {
                          'name': 'Bangladesh',
                          'code': 'BD',
                          'dial_code': '+880'
                        },
                        {'name': 'Belgium', 'code': 'BE', 'dial_code': '+32'},
                        {'name': 'Brazil', 'code': 'BR', 'dial_code': '+55'},
                        {'name': 'Canada', 'code': 'CA', 'dial_code': '+1'},
                        {'name': 'China', 'code': 'CN', 'dial_code': '+86'},
                        {'name': 'Colombia', 'code': 'CO', 'dial_code': '+57'},
                        {'name': 'Denmark', 'code': 'DK', 'dial_code': '+45'},
                        {'name': 'Egypt', 'code': 'EG', 'dial_code': '+20'},
                        {'name': 'Finland', 'code': 'FI', 'dial_code': '+358'},
                        {'name': 'France', 'code': 'FR', 'dial_code': '+33'},
                        {'name': 'Germany', 'code': 'DE', 'dial_code': '+49'},
                        {'name': 'Greece', 'code': 'GR', 'dial_code': '+30'},
                        {'name': 'India', 'code': 'IN', 'dial_code': '+91'},
                        {'name': 'Indonesia', 'code': 'ID', 'dial_code': '+62'},
                        {'name': 'Iraq', 'code': 'IQ', 'dial_code': '+964'},
                        {'name': 'Italy', 'code': 'IT', 'dial_code': '+39'},
                        {'name': 'Japan', 'code': 'JP', 'dial_code': '+81'},
                        {'name': 'Jordan', 'code': 'JO', 'dial_code': '+962'},
                        {'name': 'Kuwait', 'code': 'KW', 'dial_code': '+965'},
                        {'name': 'Lebanon', 'code': 'LB', 'dial_code': '+961'},
                        {'name': 'Malaysia', 'code': 'MY', 'dial_code': '+60'},
                        {'name': 'Mexico', 'code': 'MX', 'dial_code': '+52'},
                        {'name': 'Morocco', 'code': 'MA', 'dial_code': '+212'},
                        {'name': 'Nepal', 'code': 'NP', 'dial_code': '+977'},
                        {
                          'name': 'Netherlands',
                          'code': 'NL',
                          'dial_code': '+31'
                        },
                        {
                          'name': 'New Zealand',
                          'code': 'NZ',
                          'dial_code': '+64'
                        },
                        {'name': 'Nigeria', 'code': 'NG', 'dial_code': '+234'},
                        {'name': 'Norway', 'code': 'NO', 'dial_code': '+47'},
                        {'name': 'Pakistan', 'code': 'PK', 'dial_code': '+92'},
                        {
                          'name': 'Philippines',
                          'code': 'PH',
                          'dial_code': '+63'
                        },
                        {'name': 'Qatar', 'code': 'QA', 'dial_code': '+974'},
                        {'name': 'Russia', 'code': 'RU', 'dial_code': '+7'},
                        {
                          'name': 'Saudi Arabia',
                          'code': 'SA',
                          'dial_code': '+966'
                        },
                        {'name': 'Singapore', 'code': 'SG', 'dial_code': '+65'},
                        {
                          'name': 'South Africa',
                          'code': 'ZA',
                          'dial_code': '+27'
                        },
                        {'name': 'Spain', 'code': 'ES', 'dial_code': '+34'},
                        {'name': 'Sri Lanka', 'code': 'LK', 'dial_code': '+94'},
                        {'name': 'Sweden', 'code': 'SE', 'dial_code': '+46'},
                        {
                          'name': 'Switzerland',
                          'code': 'CH',
                          'dial_code': '+41'
                        },
                        {'name': 'Turkey', 'code': 'TR', 'dial_code': '+90'},
                        {
                          'name': 'United Arab Emirates',
                          'code': 'AE',
                          'dial_code': '+971'
                        },
                        {
                          'name': 'United Kingdom',
                          'code': 'GB',
                          'dial_code': '+44'
                        },
                        {
                          'name': 'United States',
                          'code': 'US',
                          'dial_code': '+1'
                        },
                        {'name': 'Vietnam', 'code': 'VN', 'dial_code': '+84'},
                      ],

                      showFlag: true,
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextField(
                        // onChanged: (value) =>
                        //     formState.updateContact(contactNumber, countryCode),
                        onChanged: (value) {
                          setState(() {
                            contactNumber = value; // Update contactNumber
                          });
                          formState.updateContact(contactNumber,
                              countryCode); // Pass both contactNumber and countryCode
                        },
                        // controller: firstNameController,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        decoration: InputDecoration(
                          border: InputBorder.none,

                          //labelText: 'First Name',
                          hintText: 'Contact No.',
                          counterText: "",
                          errorText: formState.contactError,
                          hintStyle: TextStyle(
                              color: AppColors.greyText,
                              fontFamily: 'Barlow-Regular',
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Spacer(),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.05,
            ),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              height: DeviceDimensions.screenHeight(context) * 0.07,
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
            )
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
    'Business ',
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
                    color: AppColors.textFieldBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    elevation: 16,
                    dropdownColor: Colors.white,
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
                    value: formState.selectedItem,
                    onChanged: (String? newValue) {
                      formState.updateSelectedItem(newValue);
                      // setState(() {
                      //   _selectedItem = newValue;
                      // });
                    },
                    items: _items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.03,
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
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  //controller: designationController,
                  onChanged: (value) => formState.updateDesignation(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: formState.websiteLinkError,
                    //labelText: 'Enter Last Name',
                    hintText: 'Company Link',
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
                  //controller: websiteController,
                  onChanged: (value) => formState.updateCity(value),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                activeColor: Colors.black,
                groupValue: _connectionType,
                onChanged: (int? value) {
                  setState(() {
                    _connectionType = value!;
                    formState.updateConnectionType(1);
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
                activeColor: Colors.black,
                groupValue: _connectionType,
                onChanged: (int? value) {
                  setState(() {
                    _connectionType = value!;
                    formState.updateConnectionType(2);
                  });
                },
              ),
            ),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.05,
            ),
            SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              height: DeviceDimensions.screenHeight(context) * 0.07,
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
                        color: AppColors.screenBackground),
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
                              child: SvgPicture.asset(
                                'assets/icons/uploadnew.svg',
                                height:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.01,
                                width:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.01,
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
              height: DeviceDimensions.screenHeight(context) * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  imageProvider.pickImage(context);
                },
                style: ElevatedButton.styleFrom(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(6)),
                  backgroundColor: AppColors.buttonColor,
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
              height: DeviceDimensions.screenHeight(context) * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                          Navigator.pushNamed(context, '/email-verify');
                        } catch (e) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  disabledBackgroundColor: Colors.grey,
                  backgroundColor: Colors.black,
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
