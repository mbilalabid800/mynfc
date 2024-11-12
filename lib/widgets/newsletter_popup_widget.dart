import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';

class NewsletterPopup {
  final FirestoreService _firestoreService = FirestoreService();
  //static final FirebaseService firebaseService = FirebaseService();
  static final TextEditingController emailController = TextEditingController();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'New product announcement: Be the first to know',
            style: TextStyle(
                fontSize: DeviceDimensions.responsiveSize(context) * 0.04,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/newsletter.json',
                height: 80,
              ),
              //text('Enter your email to stay updated:'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.035)),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle subscription logic here
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.greyText,
                        borderRadius: BorderRadius.circular(20)),
                    width: DeviceDimensions.screenWidth(context) * 0.3,
                    height: DeviceDimensions.screenHeight(context) * 0.05,
                    child: Center(
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Handle subscription logic here
                    // try {
                    //   await _firestoreService.saveNewsletterSubscriber(emailController.text);
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Subscribed successfully!')),
                    //   );
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Error: ${e.toString()}')),
                    //   );
                    // }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(20)),
                    width: DeviceDimensions.screenWidth(context) * 0.3,
                    height: DeviceDimensions.screenHeight(context) * 0.05,
                    child: Center(
                      child: Text('Subscribe',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
