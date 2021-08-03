import 'package:flutter/cupertino.dart';

import 'Register.dart';
import 'SignIn.dart';

class AuthWrap extends StatefulWidget {
  @override
  _AuthWrapState createState() => _AuthWrapState();
}

class _AuthWrapState extends State<AuthWrap> {

  bool showSignIn = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView:  toggleView);
    } else {
      return Register(toggleView:  toggleView);
    }
  }
}