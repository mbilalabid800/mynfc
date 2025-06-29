import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        //appBar: NavBar_AppBar(title: 'Chats'),
        // appBar: AppBar(
        //   toolbarHeight: 80,
        //   backgroundColor: AppColors.screenBackground,
        //   title: Center(
        //     child: Text('Chats',
        //         style: TextStyle(
        //             fontFamily: 'Barlow-Regular',
        //             fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
        //             fontWeight: FontWeight.w600,
        //             color: AppColors.appBlueColor)),
        //   ),
        // ),
        //floating button
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/recent-connected-list');
        //   },
        //   // backgroundColor: Colors.black,
        //   backgroundColor: AppColors.appBlueColor,
        //   foregroundColor: Colors.white,
        //   tooltip: 'New Chat',
        //   shape: CircleBorder(),
        //   child: Icon(Icons.add),
        // ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.0001,
              ),
              AbsherAppBar(title: 'Chats'),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/chat_icon.svg',
                        color: AppColors.appBlueColor),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.02),
                    const Text(
                      'Let\'s start chatting',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.appBlueColor),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.02),
                    // const Text(
                    //     '''    Tap the plus icon at the top right, select one of your
                    //       connection and start a new chat.''',
                    //     style: TextStyle(color: AppColors.appBlueColor)),
                    const Text('''    Coming Soon ''',
                        style: TextStyle(color: AppColors.appBlueColor)),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
