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
  final TextEditingController countryController = TextEditingController();
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();

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
        CustomSnackbar().snakBarMessage(context, "Profile image updated!");
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
    } else if (fieldKey == "country") {
      countryController.text = userProvider.countryName;
      userProvider.setEditingField(fieldKey);
    }
  }

  void _saveProfile() async {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    await userProvider.updateUserData();
    userProvider.clearEditingField(); // Clear the current editing field
    CustomSnackbar().snakBarMessage(context, "Records updated!!");
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    designationController.dispose();
    bioController.dispose();
    countryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoFormStateProvider>(
        builder: (context, userProvider, child) {
      return SafeArea(
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Edit Profile'),
          backgroundColor: AppColors.screenBackground,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.13,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.90,
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
                                                      .responsiveSize(context) *
                                                  0.050),
                                        ),
                                        Text(
                                          "Personal account",
                                          style: TextStyle(
                                              color: const Color(0xFF909091),
                                              fontFamily: "Barlow-Regular",
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
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
                                    padding: const EdgeInsets.only(right: 15.0),
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
                                                backgroundImage: imageProvider,
                                              ),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SmallThreeBounceLoader(),
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
                                height: DeviceDimensions.screenHeight(context) *
                                    0.020),
                            Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.90,
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
                                    callBack: () => _onFieldTap("designation"),
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
                                    title1: "Country",
                                    title2: userProvider.countryName,
                                    callBack: () => _onFieldTap("country"),
                                    currentEditingField:
                                        userProvider.currentEditingField,
                                    fieldKey: "country",
                                    controller: countryController,
                                    isEditing:
                                        userProvider.currentEditingField ==
                                            "country",
                                  ),
                                  SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.010),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.040),
                            ElevatedButton(
                              onPressed: _saveProfile,
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
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
      );
    });
  }
}
