import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _submitMsg() async {
    //close soft keyboard
    FocusScope.of(context).unfocus();

    final msg = _messageController.text;
    if (msg.trim().isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    await FirebaseFirestore.instance.collection('chat').add({
      //add method automatically generate item's id
      'text': msg,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'username': userInfo.data()!['username'],
      'userImage': userInfo.data()!['image_url'],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            onPressed: _submitMsg,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
