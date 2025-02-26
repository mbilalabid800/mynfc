// Chat Screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/messages_model.dart';
import 'package:nfc_app/provider/chat_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

class Chatting extends StatefulWidget {
  final String userId; //reciever id
  final String userName; //reciever name
  final String profileImage; //reciever pic

  const Chatting({
    super.key,
    required this.userId,
    required this.userName,
    required this.profileImage,
  });

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final TextEditingController _controller = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: SafeArea(
        child: GlobalBackButtonHandler(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.appBlueColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Navigate back
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profileImage),
                    radius: 18, // Adjust size as needed
                  ),
                  SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.04,
                  ),
                  Expanded(
                    child: Text(widget.userName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.045)),
                  ),
                ],
              ),
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //     child: Icon(Icons.more_vert, color: Colors.white),
              //   )
              // ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    stream: Provider.of<ChatProvider>(context, listen: false)
                        .fetchMessages(
                      currentUserId,
                      widget.userId,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Align(
                            alignment: message.isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: message.isSender
                                    ? Colors.indigo
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: message.isSender
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: message.isSender
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: message.isSender
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_circle,
                            color: AppColors.appOrangeColor),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Start typing...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: AppColors.appOrangeColor),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            Provider.of<ChatProvider>(context, listen: false)
                                .sendMessage(_controller.text, currentUserId,
                                    widget.userId);
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
