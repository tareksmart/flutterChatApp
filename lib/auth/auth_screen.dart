import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notes/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late UserCredential credential;
  bool _isLoading = false;
  void _submitAuthForm(String email, String userName, String password,
      File image, bool islogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (!islogin) {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(credential.user!.uid + '.jpg');
       await ref.putFile(image);
       final url=await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({'userName': userName, 'password': password,
        'user_url':url});
      } else {
        credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: userName, password: password);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'error occure'+e.message.toString();
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Scaffold.of(ctx).showBottomSheet((context) {
        return Text(message);
      });
      // Scaffold.of(ctx).showSnackBar(SnackBar(
      //   content: Text(message),
      //   backgroundColor: Theme.of(ctx).errorColor,
      // ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
