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
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessege,
      'createdAt': Timestamp.now(),
      'userName': userData['userName'],
      'userImage': userData['user_url'],
      'userId': user?.uid
    });
    //هنا تمسح محتوى الرسالة فيلد لكن محتوى الرسالة موجود
    _controller.clear();
    //لتفريغ محتوى الرسالة
    setState(() {
      _enteredMessege = "";
    });
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
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            controller: _controller,
            decoration: InputDecoration(
                labelText: 'enter send messege',
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor))),
            onChanged: (val) {
              setState(() {
                _enteredMessege = val;
              });
            },
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey,
              onPressed: _enteredMessege.trim().isEmpty ? null : _sendMessege,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
