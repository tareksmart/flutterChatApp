import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/messegs/chat.dart';

import 'auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat',
      
      theme: ThemeData(
        canvasColor: Colors.blue,
        primarySwatch: Colors.amber,
        backgroundColor: Colors.purple,
        accentColor: Colors.purple,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('starttttttttt'+snapshot.data.toString()+'datttttttta');
              return SignUp();
            } else
              return AuthScreen();
          }), /*const MyHomePage(title: 'Flutter Demo Home Page')*/
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<UserCredential> signInWithGoogle() async {
    //final GoogleSignIn _google
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
                child: Text('signed in anonyms'),
                onPressed: () async {
                  try {
                    final usercredntial =
                        await FirebaseAuth.instance.signInAnonymously();
                    print('دخول مجهول بنجاح');
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case "operation-not-allowed":
                        print(
                            "Anonymous auth hasn't been enabled for this project.");
                        break;
                      default:
                        print("Unknown error.");
                    }
                  }
                }),
            OutlinedButton(
                //with email
                child: Text('signed in email'),
                onPressed: () async {
                  try {
                    final usercredntial = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: 'tarek@examble.com',
                            password: 'Sd01002566#');
                    print('تسجيل mail');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                }),
            OutlinedButton(
                onPressed: () {
                  try {
                    final user = FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: 'tarek@examble.com',
                            password: 'Sd01002566#');
                    print('sign in secuess');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                child: Text('sign in')),
            OutlinedButton(
                onPressed: () async {
                  try {
                    UserCredential cred = await signInWithGoogle();
                    print('sign google sucess');
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('google sign')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
