// import 'package:flutter/material.dart';
// import 'package:nfc_app/constants/appColors.dart';

// class ChatPageWidget extends StatelessWidget {
//   final String title;
//   final String message;
//   final void Function()? onTap;
//   const ChatPageWidget(
//       {super.key, required this.title, this.onTap, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//           child: InkWell(
//             onTap: onTap,
//             child: Row(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: AppColors.appBlueColor,
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage(
//                         'assets/images/default_profile.jpg',
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       message,
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const Divider(color: Color(0xFFE0E0E0)),
//       ],
//     );
//   }
// }
