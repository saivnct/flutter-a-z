import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj_07/widgets/chat_mesages.dart';
import 'package:proj_07/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              //wrap ChatMessages in Expanded to make sure it take all the available space
              child: ChatMessages(),
            ),
            const NewMessage(),
          ],
        ));
  }
}
