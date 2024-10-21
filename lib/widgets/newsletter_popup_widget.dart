// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class NewsletterPopup {
//   static void show(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text('Subscribe to our Newsletter'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Lottie.asset(
//                 'assets/animations/newsletter.json',
//                 height: 10,
//               ),
//               Text('Enter your email to stay updated:'),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Email',
//                 ),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Subscribe'),
//               onPressed: () {
//                 // Handle subscription logic here
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
