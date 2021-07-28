import 'package:firebase_flutter/Firebase/Authentication.dart';

import 'Home.dart';
import 'package:flutter/material.dart';
import 'Interactions/Add_items.dart';
import 'Interactions/Cart.dart';
import 'Interactions/Individual.dart';
import 'Interactions/Orders.dart';
import 'Interactions/Remove_items.dart';
import 'Interactions/Repertoire.dart';
import 'Interactions/Settings.dart';

class ShopWrapper extends StatefulWidget {
  const ShopWrapper({Key? key}) : super(key: key);

  @override
  _ShopWrapperState createState() => _ShopWrapperState();
}

class _ShopWrapperState extends State<ShopWrapper> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Authenticate authclass = Authenticate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home' : (context)=> Home(),
        'Settings' : (context)=> Settings(),
        'Orders' : (context)=> Orders(),
        'Cart' : (context)=> Cart(),
        'Add' : (context)=> Add(),
        "Remove" : (context)=> Remove(),
        "Grid" : (context)=> Grid(),
        'Individual' : (context) => Individual()
      },

    );
  }

}

