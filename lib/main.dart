import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Firebase/Authentication.dart';
import 'Itemholder/Items.dart';
import 'Navigate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
          value: Authenticate().user,
          initialData: FirebaseAuth.instance.currentUser,
          child: ChangeNotifierProvider(
            create: (context) => Item(),
            child: Navigate(),
          ),
    );
  }
}
