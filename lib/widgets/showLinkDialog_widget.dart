// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/social_app_model.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class ShowLinkDialog extends StatefulWidget {
  final SocialAppModel appItem;

  const ShowLinkDialog({super.key, required this.appItem});

  @override
  _ShowLinkDialogState createState() => _ShowLinkDialogState();
}

class _ShowLinkDialogState extends State<ShowLinkDialog> {
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameController.text =
        widget.appItem.userName; // Pre-fill with existing link if available
  }

  void _saveLink() {
    FocusScope.of(context).unfocus();
    final link = _userNameController.text.trim();
    if (link.isNotEmpty) {
      Navigator.of(context).pop(link);
    } else {
      Navigator.of(context).pop(null);
    }
  }

  void _deleteLink() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop('delete');
  }

  @override
  Widget build(BuildContext context) {
    //FocusScope.of(context).unfocus();
    final hasUserName = widget.appItem.userName.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
      ),
      child: Container(
        width: DeviceDimensions.screenWidth(context),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.010),
            Container(
              width: DeviceDimensions.screenWidth(context) * 0.17,
              height: DeviceDimensions.screenHeight(context) * 0.007,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(12)),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.appBlueColor,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.appItem.icon,
                    placeholder: (context, url) =>
                        Center(child: DualRingLoader()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.01),
            Text(
              widget.appItem.name,
              style: TextStyle(
                  fontFamily: 'Barlow-Bold',
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.072,
                  color: AppColors.textColorBlue,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: DeviceDimensions.screenHeight(context) * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      hintText: widget.appItem.gethint(),
                      hintStyle: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.045),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  widget.appItem.getMessgae(),
                  style: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.040,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.04),
            if (hasUserName) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.06,
                    width: DeviceDimensions.screenWidth(context) * 0.35,
                    child: ElevatedButton(
                      onPressed: _deleteLink,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 228, 73, 62),
                          foregroundColor: Colors.white),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.06,
                    width: DeviceDimensions.screenWidth(context) * 0.35,
                    child: ElevatedButton(
                      onPressed: _saveLink,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appBlueColor,
                          foregroundColor: Colors.white),
                      child: Text(
                        'Update',
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020)
            ] else ...[
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.06,
                width: DeviceDimensions.screenWidth(context) * 0.8,
                child: ElevatedButton(
                  onPressed: _saveLink,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appBlueColor,
                      foregroundColor: Colors.white),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.055,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();

    super.dispose();
  }
}

void showLinkBottomSheet(BuildContext context, SocialAppModel appItem) async {
  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ShowLinkDialog(appItem: appItem),
  );

  final socialAppProvider =
      Provider.of<SocialAppProvider>(context, listen: false);

  if (result != null) {
    if (result == 'delete') {
      final updatedItem = appItem.copyWith(userName: '', isVisible: false);
      socialAppProvider.removeFromaddedSocialApps([updatedItem]);
    } else if (result.isNotEmpty) {
      final updatedItem = appItem.copyWith(userName: result, isVisible: true);
      socialAppProvider.addOrUpdateAppItem(updatedItem);
    }
  }
}
