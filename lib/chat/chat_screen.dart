import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/chat/chat_screen2.dart';
import 'package:nfc_app/constants/appColors.dart';

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
          leading: const Icon(Icons.keyboard_backspace),
          backgroundColor: AppColors.screenBackground,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen2()));
                },
                child: SvgPicture.asset('assets/icons/plus.svg', height: 25),
              ),
            ),
          ],
          title: const Center(
            child: Text(
              'Chats',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/chat_icon.svg'),
            const SizedBox(height: 10),
            const Text(
              'Let\'s start chatting',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
                '''    Tap the plus icon at the top right, select one of your 
                  connection and start a new chat.'''),
          ],
        ),
      ),
    );
  }
}
