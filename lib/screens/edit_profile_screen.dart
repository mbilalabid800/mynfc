// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/components/edit_profile_component.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/image_picker_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  bool isLoading = false;
  bool isButtonEnabled = false;
  // final FocusNode _focusNode = FocusNode();

  late String _initialFirstName;
  late String _initialLastName;
  late String _initialCompanyName;
  late String _initialDesignation;
  late String _initialBio;
  late String _initialWebsite;

  // late String _tempFirstName;
  // late String _tempLastName;
  // late String _tempCompanyName;
  // late String _tempDesignation;
  // late String _tempBio;
  // late String _tempWebsite;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProvider =
          Provider.of<UserInfoFormStateProvider>(context, listen: false);
      userProvider.loadUserData();

      // Store initial values separately
      _initialFirstName = userProvider.firstName;
      _initialLastName = userProvider.lastName;
      _initialCompanyName = userProvider.companyName;
      _initialDesignation = userProvider.designation;
      _initialBio = userProvider.bio;
      _initialWebsite = userProvider.websiteLink;

      firstNameController.text = _initialFirstName;
      lastNameController.text = _initialLastName;
      companyNameController.text = _initialCompanyName;
      designationController.text = _initialDesignation;
      bioController.text = _initialBio;
      websiteController.text = _initialWebsite;

      // Add listeners
      firstNameController.addListener(_checkChanges);
      lastNameController.addListener(_checkChanges);
      companyNameController.addListener(_checkChanges);
      designationController.addListener(_checkChanges);
      bioController.addListener(_checkChanges);
      websiteController.addListener(_checkChanges);
    });
  }

  void _checkChanges() {
    setState(() {
      isButtonEnabled = firstNameController.text != _initialFirstName ||
          lastNameController.text != _initialLastName ||
          companyNameController.text != _initialCompanyName ||
          designationController.text != _initialDesignation ||
          bioController.text != _initialBio ||
          websiteController.text != _initialWebsite;
    });
  }

  Future<void> _pickImage() async {
    final imagePicker =
        Provider.of<ImagePickerProvider>(context, listen: false);
    await imagePicker.pickImage(context);

    if (imagePicker.image != null) {
      setState(() {
        isLoading = true; // Show loader
      });
      try {
        final String imageUrl = await uploadImageAndGetUrl(imagePicker.image!);
        final userProvider =
            Provider.of<UserInfoFormStateProvider>(context, listen: false);
        userProvider.updateImageUrl(imageUrl);
        await userProvider.updateUserData();
        CustomSnackbar().snakBarMessage2(context, "Profile image updated!");
      } catch (e) {
        CustomSnackbar().snakBarError(context, "Failed to upload image.");
      } finally {
        setState(() {
          isLoading = false; // Hide loader
        });
      }
    } else if (imagePicker.error != null) {
      CustomSnackbar().snakBarError(context, imagePicker.error!);
    }
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
  }

  void _onFieldTap(String fieldKey) {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);

    if (fieldKey == "first_name") {
      firstNameController.text = userProvider.firstName;
      userProvider.setEditingField(fieldKey);
    } else if (fieldKey == "last_name") {
      lastNameController.text = userProvider.lastName;
      userProvider.setEditingField(fieldKey);
    } else if (fieldKey == "company") {
      companyNameController.text = userProvider.companyName;
      userProvider.setEditingField(fieldKey);
    } else if (fieldKey == "designation") {
      designationController.text = userProvider.designation;
      userProvider.setEditingField(fieldKey);
    } else if (fieldKey == "bio") {
      bioController.text = userProvider.bio;
      userProvider.setEditingField(fieldKey);
    } else if (fieldKey == "website") {
      websiteController.text = userProvider.websiteLink;
      userProvider.setEditingField(fieldKey);
    }
  }

  void _saveProfile() async {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);

    // Update provider with the latest values from controllers
    userProvider.updateFirstName(firstNameController.text);
    userProvider.updateLastName(lastNameController.text);
    userProvider.updateCompanyName(companyNameController.text);
    userProvider.updateDesignation(designationController.text);
    userProvider.updateBio(bioController.text);
    userProvider.updateWebsiteLink(websiteController.text);

    await userProvider.updateUserData();
    // userProvider.clearEditingField();
    CustomSnackbar().snakBarMessage2(context, "Records updated!");
    // Update initial values to reflect the new state
    _initialFirstName = firstNameController.text;
    _initialLastName = lastNameController.text;
    _initialCompanyName = companyNameController.text;
    _initialDesignation = designationController.text;
    _initialBio = bioController.text;
    _initialWebsite = websiteController.text;

    setState(() {
      isButtonEnabled = false;
    });
  }

  void _revertChanges() {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);

    // Revert provider state to initial values
    userProvider.updateFirstName(_initialFirstName);
    userProvider.updateLastName(_initialLastName);
    userProvider.updateCompanyName(_initialCompanyName);
    userProvider.updateDesignation(_initialDesignation);
    userProvider.updateBio(_initialBio);
    userProvider.updateWebsiteLink(_initialWebsite);

    // Revert text controllers to initial values
    firstNameController.text = _initialFirstName;
    lastNameController.text = _initialLastName;
    companyNameController.text = _initialCompanyName;
    designationController.text = _initialDesignation;
    bioController.text = _initialBio;
    websiteController.text = _initialWebsite;

    setState(() {
      isButtonEnabled = false;
    });
  }

  void showConfirmationPopup(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
            ),
            actions: [
              Column(children: [
                GestureDetector(
                  onTap: () {
                    _revertChanges();
                    Navigator.of(context).pop(); //
                  },
                  child: Container(
                    width: DeviceDimensions.screenWidth(context) * 0.8,
                    height: DeviceDimensions.screenHeight(context) * 0.055,
                    decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text("Discard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.04)),
                    ),
                  ),
                ),
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    width: DeviceDimensions.screenWidth(context) * 0.8,
                    height: DeviceDimensions.screenHeight(context) * 0.055,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all()),
                    child: Center(
                      child: Text("Keep editing",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.appBlueColor,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.04)),
                    ),
                  ),
                )
              ])
            ]
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       _revertChanges(); // Close the dialog
            //     },
            //     child: Text("Discard"),
            //   ),
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop(); // Close the dialog
            //     },
            //     child: Text("Keep Editing"),
            //   ),
            // ],
            );
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    designationController.dispose();
    bioController.dispose();
    websiteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoFormStateProvider>(
        builder: (context, userProvider, child) {
      return SafeArea(
        child: GlobalBackButtonHandler(
          child: Scaffold(
            backgroundColor: AppColors.screenBackground,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.0001,
                    ),
                    AbsherAppBar3(
                      title: 'Edit Profile',
                      onLeftButtonTap: () {
                        if (isButtonEnabled) {
                          //_revertChanges();
                          showConfirmationPopup(
                              context,
                              "Discard unsaved changes",
                              "You have unsaved changes, are you sure you want to discard them?");
                          //Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      rightButton: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.035),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    // SizedBox(
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.13,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.028),
                                          Text(
                                            "Account Information",
                                            style: TextStyle(
                                                fontFamily: "Barlow-Bold",
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textColorBlue,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.050),
                                          ),
                                          Text(
                                            "Personal account",
                                            style: TextStyle(
                                                color: const Color(0xFF909091),
                                                fontFamily: "Barlow-Regular",
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.039),
                                          ),
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.028),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: _pickImage,
                                            child: CircleAvatar(
                                              radius: 32,
                                              backgroundColor:
                                                  AppColors.appBlueColor,
                                              child: CachedNetworkImage(
                                                imageUrl: userProvider.imageUrl,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      SmallThreeBounceLoader(),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/images/default_profile.jpg'),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: _pickImage,
                                              child: SvgPicture.asset(
                                                "assets/icons/uploadprofile.svg",
                                                width: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020),
                              Container(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.010),
                                    EditProfileComponent(
                                      title1: "First Name",
                                      title2: userProvider.firstName,
                                      callBack: () => _onFieldTap("first_name"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "first_name",
                                      controller: firstNameController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "first_name",
                                    ),
                                    EditProfileComponent(
                                      title1: "Last Name",
                                      title2: userProvider.lastName,
                                      callBack: () => _onFieldTap("last_name"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "last_name",
                                      controller: lastNameController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "last_name",
                                    ),
                                    EditProfileComponent(
                                      title1: "Company",
                                      title2: userProvider.companyName,
                                      callBack: () => _onFieldTap("company"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "company",
                                      controller: companyNameController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "company",
                                    ),
                                    EditProfileComponent(
                                      title1: "Designation",
                                      title2: userProvider.designation,
                                      callBack: () =>
                                          _onFieldTap("designation"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "designation",
                                      controller: designationController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "designation",
                                    ),
                                    EditProfileComponent(
                                      title1: "Bio",
                                      title2: userProvider.bio,
                                      callBack: () => _onFieldTap("bio"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "bio",
                                      controller: bioController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "bio",
                                    ),
                                    EditProfileComponent(
                                      title1: "Website",
                                      title2: userProvider.websiteLink,
                                      callBack: () => _onFieldTap("website"),
                                      currentEditingField:
                                          userProvider.currentEditingField,
                                      fieldKey: "website",
                                      controller: websiteController,
                                      isEditing:
                                          userProvider.currentEditingField ==
                                              "website",
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.010),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.040),
                              ElevatedButton(
                                onPressed:
                                    isButtonEnabled ? _saveProfile : null,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        DeviceDimensions.screenWidth(context) *
                                            0.35,
                                    vertical: 12,
                                  ),
                                  backgroundColor: AppColors.appBlueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.040),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.white54,
                    child: Center(
                      child: DualRingLoader(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
