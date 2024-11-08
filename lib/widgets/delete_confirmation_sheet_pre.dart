import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/delete_confirmation_sheet.dart';

class DeleteConfirmationSheetPre {
  void accountDeleteConfirmPre(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.screenBackground,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 320,
          width: DeviceDimensions.screenWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.015),
              Container(
                width: DeviceDimensions.screenWidth(context) * 0.16,
                height: DeviceDimensions.screenHeight(context) * 0.007,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12)),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.035),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "DELETE ACCOUNT?",
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.060,
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 2, right: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Are you sure to delete account.",
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.040,
                        fontFamily: 'Barlow-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.085),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const Wrap(
                          children: [
                            DeleteConfirmationSheet(),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: DeviceDimensions.screenWidth(context) * 0.18,
                    vertical: 9,
                  ),
                  backgroundColor: const Color(0xFFF86F6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Yes, I want to delete",
                  style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.015),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: DeviceDimensions.screenWidth(context) * 0.308,
                    vertical: 9,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                      color: Color(0xFFF86F6B),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF86F68),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
