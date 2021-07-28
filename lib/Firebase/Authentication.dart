import 'package:firebase_auth/firebase_auth.dart';

class Authenticate
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user
  {
    return _auth.authStateChanges();
  }
  //TODO -> refer to https://firebase.flutter.dev/docs/auth/usage/#authentication-state for update


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

  Future registerWithEmail(String email, String password) async
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


}


