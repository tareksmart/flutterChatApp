import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _islogin = true;
  String _email = "";
  String _userName = "";
  String _password = "";

  void _submit() {
    final _isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus(); // واغلاق الكيبورد جعل الفورمة كانها فى سكرول
    if (_isValid!) {
      _formKey.currentState?.save();
      print(_email);
      print(_userName);
      print(_password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(elevation: 8,
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_islogin)
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: ((value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'please enter valid email';
                        }
                      }),
                      onSaved: (value) => _email = value!,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'email address'),
                    ),
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'please enter at least 4 char';
                      }
                    },
                    onSaved: (val) => _userName = val!,
                    decoration: InputDecoration(labelText: 'username'),
                  ),
                  TextFormField(
                    key: const ValueKey('pass'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return 'enter at least 7char';
                      }
                    },
                    onSaved: (val) => _password = val!,
                    decoration: InputDecoration(labelText: 'password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  OutlinedButton(
                      onPressed: _submit,
                      child: Text(_islogin ? 'login' : 'signup')),
                      FlatButton(onPressed: (() {
                       setState(() {
                         _islogin=!_islogin;
                       });
                      }), child: Text(_islogin?'create new account':'i already have account'))
                ],
              )),
        ),
      ),
    );
  }
}
