import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Storage.dart';
import 'Authentication.dart';

class Database {
  final CollectionReference userdata = FirebaseFirestore.instance.collection(
      'user_data');
  final CollectionReference usercart = FirebaseFirestore.instance.collection(
      'user_cart');
  final CollectionReference add = FirebaseFirestore.instance.collection("add");
  final CollectionReference delete = FirebaseFirestore.instance.collection(
      "delete");
  String? uid;

  Authenticate authclass = Authenticate();

  Database({required this.uid});

  Future<void> buy(Map<String,dynamic> productmap) async
  {
    await userdata.doc(uid).set(productmap);
  }

  Future<void> add_cart(Map<String,dynamic> singularproductmap) async {
    var docsnap = await usercart.doc(uid).get();
    Map products = Map();
    if(docsnap.data() != null)
    {
      products = docsnap.data() as Map;
    }
    String l = "${singularproductmap["id"]}";
    Map<String,dynamic> temp = {l:singularproductmap};
    products.addAll(temp);
    Map<String,dynamic> pass = Map();
    int i=1;
    products.forEach((key, value) {
      pass["${i}"] = products[key];
      i++;
    });
    await usercart.doc(uid).set(pass);
  }

  Future<void> remove_cart(Map<String,dynamic> singularproductmap) async {
    var docsnap = await usercart.doc(uid).get();
    Map products = Map();
    if(docsnap.exists)
    {
      products = docsnap.data() as Map ;
    }
    products.removeWhere((key, value) {
      if(value["id"] == singularproductmap["id"])
        {
          return true;
        }
      else{
        return false;
      }
    });
    Map<String,dynamic> pass = Map();
    int i=1;
    products.forEach((key, value) {
      pass["${i}"] = products[key];
      i++;
    });
    await usercart.doc(uid).set(pass);
  }

  Future<void> additem(Map<String,dynamic> singularproductmap) async {
    Map <String,Map<String,dynamic>> products = Map();
    String l = "${singularproductmap["id"]}";
    products.addAll({l: singularproductmap});
    await add.add(products);
  }

  Future<void> deleteitem(Map<String,dynamic> singularproductmap) async {
    Map <String,Map<String,dynamic>> products = Map();
    String l = "${singularproductmap["id"]}";
    products.addAll({l: singularproductmap});
    await delete.add(products);
  }
}