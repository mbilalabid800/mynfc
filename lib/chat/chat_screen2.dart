import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/chat/chat_widget.dart';
import 'package:nfc_app/constants/appColors.dart';

class ChatScreen2 extends StatefulWidget {
  const ChatScreen2({super.key});

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Chats',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: AppColors.screenBackground,
          actions: [
            Row(
              children: [
                Badge(
                  largeSize: 20,
                  smallSize: 10,
                  alignment: Alignment.topRight,
                  backgroundColor: Colors.blue,
                  child: SvgPicture.asset('assets/icons/bell.svg'),
                ),
                const SizedBox(width: 5),
                //SvgPicture.asset('assets/ellipsis-vertical.svg'),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: ' Search Contacts',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: border,
                    enabledBorder: border,
                    disabledBorder: border,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const ChatPageWidget(
                  title: 'Name of Person', message: 'Hey I am your friend.'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
