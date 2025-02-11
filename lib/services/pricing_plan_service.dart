// // services/pricing_plan_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:nfc_app/constants/appColors.dart';
// import 'package:nfc_app/models/pricing_plan_model.dart';
// import 'package:nfc_app/provider/user_info_form_state_provider.dart';
// import 'package:provider/provider.dart';

// class PricingPlanService {
//   final CollectionReference plansCollection =
//       FirebaseFirestore.instance.collection('pricingPlan');

//   List<PricingPlan> getPlans() {
//     return [
//       PricingPlan(
//         icon: Icons.person,
//         title: 'For Individuals',
//         category: 'Individuals',
//         price: '7.00 ',
//         assetImagePath: 'assets/icons/cardindividual.png',
//         currency: 'OMR',
//         description: 'per card, one-time payment',
//         features: [
//           'Custom NFC Card',
//           'NFC Free Plan',
//           'One Digital business Card',
//           'Unlimited Shares (NFC, QR, Link)',
//           'Public Mode: t.link/username',
//           'In App QR- code sharing',
//           'Offline QR Code (vcard)',
//           'NameDrop Share (iOS)',
//         ],
//         nofeatures: [
//           'WorkFlow Automation',
//           'CRM Integrations (Hubspot, Zapier, Pipedrive)'
//         ],
//         buttonText: 'Order NFC Card',
//         buttonAction: (context, selectedCard, selectedColorOption) {
//           Navigator.pushNamed(
//             context,
//             '/place-order-screen',
//             arguments: {
//               'selectedCard': selectedCard,
//               'selectedColorOption': selectedColorOption,
//             },
//           );
//         },
//       ),
//       PricingPlan(
//         icon: Icons.groups,
//         title: 'For Teams & Business',
//         category: 'Teams',
//         price: '6.00 ',
//         currency: 'OMR',
//         assetImagePath: 'assets/icons/cardteam.png',
//         description: 'per user, per year',
//         features: [
//           'Custom NFC Card',
//           'NFC Free Plan',
//           'One Digital business Card',
//           'Unlimited Shares (NFC, QR, Link)',
//           'Public Mode: t.link/username',
//           'In App QR- code sharing',
//           'Offline QR Code (vcard)',
//           'NameDrop Share (iOS)',
//           'WorkFlow Automation',
//           'CRM Integrations (Hubspot, Zapier, Pipedrive)'
//         ],
//         nofeatures: [],
//         buttonText: 'Book a Demo',
//         buttonAction: (context, selectedCard, selectedColorOption) async {
//           String? currentProfileType =
//               Provider.of<UserInfoFormStateProvider>(context, listen: false)
//                   .profileType;
//           if (currentProfileType == "Business") {
//             Navigator.pushNamed(
//               context,
//               '/add-employees',
//               arguments: {
//                 'selectedCard': selectedCard,
//                 'selectedColorOption': selectedColorOption,
//               },
//             );
//           } else {
//             showDialog(
//               context: context,
//               builder: (BuildContext dialogContext) {
//                 return AlertDialog(
//                   backgroundColor: AppColors.screenBackground,
//                   title: const Text('Confirm Change'),
//                   content: const Text(
//                       'You are switching from "Individual" to "Business". Do you want to proceed?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(
//                             dialogContext); // Close the dialog and stay on the same screen
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: AppColors.errorColor,
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 7),
//                           child: Text(
//                             "Cancel",
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         Navigator.pop(dialogContext); // Close the dialog
//                         Navigator.pushNamed(
//                           context,
//                           '/add-employees',
//                           arguments: {
//                             'selectedCard': selectedCard,
//                             'selectedColorOption': selectedColorOption,
//                           },
//                         );
//                         await Provider.of<UserInfoFormStateProvider>(context,
//                                 listen: false)
//                             .updateProfileType("Business");
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: AppColors.appBlueColor,
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 7),
//                           child: Text(
//                             "Confirm",
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//       PricingPlan(
//         icon: Icons.apartment,
//         title: 'For Enterprise',
//         category: 'Companies',
//         price: '5.50 ',
//         currency: 'OMR',
//         assetImagePath: 'assets/icons/cardcompanies.png',
//         description: '100+ users',
//         features: [
//           'Custom NFC Card',
//           'NFC Free Plan',
//           'One Digital business Card',
//           'Unlimited Shares (NFC, QR, Link)',
//           'Public Mode: t.link/username',
//           'In App QR- code sharing',
//           'Offline QR Code (vcard)',
//           'NameDrop Share (iOS)',
//           'WorkFlow Automation',
//           'CRM Integrations (Hubspot, Zapier, Pipedrive)'
//         ],
//         nofeatures: [],
//         buttonText: 'Talk to Sale',
//         buttonAction: (context, selectedCard, selectedColorOption) {
//           Navigator.pushNamed(
//             context,
//             '/contact-us-screen',
//           );
//         },
//       ),
//     ];
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/pricing_plan_model.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:provider/provider.dart';

class PricingPlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchFeatures(String planType) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('SubscriptionPlan')
          .doc(planType)
          .collection('planValues')
          .get();

      return snapshot.docs.map((doc) => doc['feature'] as String).toList();
    } catch (e) {
      print('Error fetching features: $e');
      return [];
    }
  }

  Future<List<PricingPlan>> getPlans(BuildContext context) async {
    List<PricingPlan> plans = [];

    List<Map<String, dynamic>> planDetails = [
      {
        'icon': Icons.person,
        'title': '',
        'category': 'Individuals',
        'price': '7.00',
        'assetImagePath': 'assets/icons/cardindividual.png',
        'currency': 'OMR',
        'description': 'per card, one-time payment',
        'buttonText': 'Order NFC Card',
        'buttonAction': (context, selectedCard, selectedColorOption) {
          Navigator.pushNamed(
            context,
            '/place-order-screen',
            arguments: {
              'selectedCard': selectedCard,
              'selectedColorOption': selectedColorOption,
            },
          );
        },
      },
      {
        'icon': Icons.groups,
        'title': 'For Teams & Business',
        'category': 'Teams',
        'price': '6.00',
        'assetImagePath': 'assets/icons/cardteam.png',
        'currency': 'OMR',
        'description': 'per user, per year',
        'buttonText': 'Book a Demo',
        'buttonAction': (context, selectedCard, selectedColorOption) async {
          String? currentProfileType =
              Provider.of<UserInfoFormStateProvider>(context, listen: false)
                  .profileType;
          if (currentProfileType == "Business") {
            Navigator.pushNamed(
              context,
              '/add-employees',
              arguments: {
                'selectedCard': selectedCard,
                'selectedColorOption': selectedColorOption,
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  backgroundColor: AppColors.screenBackground,
                  title: const Text('Confirm Change'),
                  content: const Text(
                      'You are switching from "Individual" to "Business". Do you want to proceed?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 7),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        Navigator.pushNamed(
                          context,
                          '/add-employees',
                          arguments: {
                            'selectedCard': selectedCard,
                            'selectedColorOption': selectedColorOption,
                          },
                        );
                        await Provider.of<UserInfoFormStateProvider>(context,
                                listen: false)
                            .updateProfileType("Business");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.appBlueColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 7),
                          child: Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      },
      {
        'icon': Icons.apartment,
        'title': 'For Enterprise',
        'category': 'Companies',
        'price': '5.50',
        'assetImagePath': 'assets/icons/cardcompanies.png',
        'currency': 'OMR',
        'description': '100+ users',
        'buttonText': 'Talk to Sale',
        'buttonAction': (context, selectedCard, selectedColorOption) {
          Navigator.pushNamed(context, '/contact-us-screen');
        },
      },
    ];

    for (var detail in planDetails) {
      List<String> features = await fetchFeatures(detail['category']);
      plans.add(PricingPlan(
        icon: detail['icon'],
        title: detail['title'],
        category: detail['category'],
        price: detail['price'],
        assetImagePath: detail['assetImagePath'],
        currency: detail['currency'],
        description: detail['description'],
        features: features,
        nofeatures: [],
        buttonText: detail['buttonText'],
        buttonAction: detail['buttonAction'],
      ));
    }

    return plans;
  }
}
