import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 12, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 9),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child:
                          SvgPicture.asset('assets/icons/back.svg', width: 17),
                    ),
                  ),
                  Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.042,
                      fontFamily: 'Barlow-Regular',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 55.0),
                    child: Text(""),
                  ),
                ],
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.020),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              "Your privacy is important to us. It is Brainstorming's policy to respect your privacy regarding any information we may collect from you across our website, and other sites we own and operate.\n\n"
                              "We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\n\n"
                              "We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n"
                              "We don’t share any personally identifying information publicly or with third-parties, except when required to by law.\n\n"
                              "What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n"
                              "We don’t share any personally identifying information publicly or with third-parties, except when required to by law.What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.",
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.035,
                                fontFamily: 'Barlow-Regular',
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.010),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: isChecked,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value;
                                });
                              }),
                          Text(
                            "I agree with Terms & Conditions",
                            style: TextStyle(
                                fontFamily: 'Barlow-Regular',
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.037,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.010),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.025),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.045,
              width: DeviceDimensions.screenWidth(context) * 0.70,
              child: ElevatedButton(
                onPressed: isChecked == true ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "I’ve agree with this",
                  style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
          ],
        ),
      ),
    );
  }
}
