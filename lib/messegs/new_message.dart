import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessege = "";
  _sendMessege() async {
    FocusScope.of(context).unfocus();
    final user=await FirebaseAuth.instance.currentUser;
    final userData=await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    FirebaseFirestore.instance
        .collection('chat')
        .add({'text': _enteredMessege, 'createdAt': Timestamp.now(),
    'userName':userData['userName'],
    'userId':user?.uid});
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'enter send messege'),
            onChanged: (val) {
              setState(() {
                _enteredMessege = val;
              });
            },
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: _enteredMessege.trim().isEmpty ? null : _sendMessege,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
