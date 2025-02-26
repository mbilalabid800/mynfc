import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:provider/provider.dart';

class EditProfileComponent extends StatefulWidget {
  final String title1;
  final String title2;
  final String icons;
  final VoidCallback callBack;
  final String currentEditingField;
  final String fieldKey;
  final TextEditingController controller;
  final bool isEditing;

  const EditProfileComponent({
    super.key,
    required this.title1,
    required this.title2,
    this.icons = "assets/icons/editfield.svg",
    required this.callBack,
    required this.currentEditingField,
    required this.fieldKey,
    required this.controller,
    required this.isEditing,
  });

  @override
  State<EditProfileComponent> createState() => _EditProfileComponentState();
}

class _EditProfileComponentState extends State<EditProfileComponent> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Method to close the keyboard when "done" or arrow is pressed
  void _closeKeyboard() {
    FocusScope.of(context).unfocus(); // Unfocus any active focus node
    _focusNode.unfocus(); // Explicitly unfocus this focus node
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.currentEditingField == widget.fieldKey;
    // if (isEditing) {
    //   _focusNode.requestFocus(); // Automatically focus the text field
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: () {
          _closeKeyboard(); // Close keyboard before calling callback
          widget.callBack();
        },
        child: Container(
          width: DeviceDimensions.screenWidth(context) * 0.82,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.012),
                      Text(
                        widget.title1,
                        style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF909091),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.004),
                      isEditing
                          ? TextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.037,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColorBlue,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              autofocus: true,
                              onChanged: (newValue) {
                                if (widget.fieldKey == "first_name") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateFirstName(newValue);
                                  //_focusNode.unfocus();
                                } else if (widget.fieldKey == "last_name") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateLastName(newValue);
                                  //_focusNode.unfocus();
                                } else if (widget.fieldKey == "company") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateCompanyName(newValue);
                                  //_focusNode.unfocus();
                                } else if (widget.fieldKey == "designation") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateDesignation(newValue);
                                  //_focusNode.unfocus();
                                } else if (widget.fieldKey == "bio") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateBio(newValue);
                                  //_focusNode.unfocus();
                                } else if (widget.fieldKey == "website") {
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .updateWebsiteLink(newValue);
                                  //_focusNode.unfocus();
                                }
                              },
                              textInputAction:
                                  TextInputAction.done, // Arrow button behavior
                              onSubmitted: (value) {
                                _focusNode.unfocus();
                                _closeKeyboard(); // Close keyboard on arrow press
                              },
                              onEditingComplete: () {
                                _focusNode
                                    .unfocus(); // Optionally unfocus when editing is complete
                              },
                            )
                          : Text(
                              widget.title2,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.037,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColorBlue,
                              ),
                            ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.012),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SvgPicture.asset(
                    widget.icons,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
