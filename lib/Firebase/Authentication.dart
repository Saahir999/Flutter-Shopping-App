import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? gAccName = "" ;
  Stream<User?> get user
  {
    return _auth.authStateChanges();
  }

  Future browse() async
  {
    try
        {
          UserCredential creds = await _auth.signInAnonymously();
          User? user = creds.user;
          return user;
        }
    catch(e)
        {
          //TODO-> Toast to user
          return null;
        }
        
  }
  
  Future signInWithEmail(String email, String password) async
  {
    try {
      UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = creds.user;
      return user;
    }
    catch(e)
    {
      //TODO-> Toast to user
      return null;
    }
  }

  Future registerWithEmail( String email,String password) async
  {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = creds.user;

      return user;
    }
    catch(e)
    {
      //TODO-> Toast to user
      return null;
    }
  }

  Future updatePassword(String newPassword) async
  {
    //then reauthenticate using new credentials
    //make user do relogin

    User? _user = _auth.currentUser;
    try {
      await _user?.updatePassword(newPassword);
    }
    catch(e)
    {
      return "Error";
    }
  }

  Future signOut() async
  {
    try
      {
          return _auth.signOut();
      }
    catch(e)
      {
          //TODO-> Toast to user
          return null;
      }

  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    gAccName = googleUser.displayName;
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signOutWithGoogle()
  {
    final GoogleSignIn googleSignIn = GoogleSignIn();
     return googleSignIn.signOut();
  }


}


