import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/comingsoon1.png",
            height: 120,
          ),
          SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.appBlueColor,
                    width: 1.5,
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45.0, vertical: 7),
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
