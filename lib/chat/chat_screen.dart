import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

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
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: AppColors.screenBackground,
          title: Center(
            child: Text('Chats',
                style: TextStyle(
                    fontFamily: 'Barlow-Regular',
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/recent-connected-list');
          },
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          tooltip: 'New Chat',
          shape: CircleBorder(),
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/chat_icon.svg'),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02),
              const Text(
                'Let\'s start chatting',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02),
              const Text(
                  '''    Tap the plus icon at the top right, select one of your 
                    connection and start a new chat.'''),
            ],
          ),
        ),
      ),
    );
  }
}
