import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Firebase/Authentication.dart';
import 'Itemholder/Items.dart';
import 'Navigate.dart';
import 'Pages/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Item(),
        child: StreamProvider<User?>.value(
          value: Authenticate().user,
          initialData: FirebaseAuth.instance.currentUser,
          child: Navigate(),
          ),
    );
  }
}
