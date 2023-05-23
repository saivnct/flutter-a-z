import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proj_07/widgets/message_bubble.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    // print('Token: $token');

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Messages yet!'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 12, right: 12),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final msg = messages[index].data();
            final nextMsg =
                index + 1 < messages.length ? messages[index + 1].data() : null;
            final currentMsgUsrId = msg['userId'];
            final nextMsgUsrId = nextMsg?['userId'];

            final nexMsgIsSame = currentMsgUsrId == nextMsgUsrId;

            if (nexMsgIsSame) {
              return MessageBubble.next(
                message: msg['text'],
                isMe: currentMsgUsrId == myUserId,
              );
            } else {
              return MessageBubble.first(
                message: msg['text'],
                username: msg['username'],
                userImage: msg['userImage'],
                isMe: currentMsgUsrId == myUserId,
              );
            }
          },
        );
      },
    );
  }
}
