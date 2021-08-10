import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/Firebase/Database.dart';
import 'package:firebase_flutter/Firebase/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Item extends ChangeNotifier {

  Map productmap = {};
  String name= "";
  String? googleName = "";
  bool check= false;
  var data;
  final String url ="https://fakestoreapi.com/products";
  String? uid;
  Database? database;
  Storage? storage;
  Item();
  Item.setfirebase({required this.uid}){
    database = Database(uid: uid);
    storage = Storage(uid: uid);
  } //Item perform = Item.setfirebase(uid: Provider.of<User?>(context,listen:false)?.uid); for use


  Future<Map<dynamic,dynamic>> products() async {
    var response = await http.get(Uri.parse(url));
    data = json.decode(response.body);
    data.forEach((e)
    {
      productmap["${e["id"]}"] = e;
    });
    return await removeproducts( await addproducts(productmap ));
  }

  Future<Map> addproducts(Map toadd) async {
    Map products = Map();
    var query = await database?.add.get();

      query!.docs.forEach((docsnap) {
        if (docsnap.exists) {

          Map temp = docsnap.data() as Map;
          products.addAll(temp);

        }
      });

    toadd.addAll(products);
    return toadd;
  }

  Future<Map> removeproducts(Map toremove) async {
    Map products = Map();
    var query = await database?.delete.get();
      query!.docs.forEach((docsnap) {
        if (docsnap.exists) {
          Map temp = docsnap.data() as Map;
          products.addAll(temp);
        }
      });
     products.forEach((pkey, pvalue) {
      toremove.removeWhere((key, value) {
        if (value["id"] == pvalue["id"]) {
          return true;
        }
        else {
          return false;
        }
      });
    });
    Map pass = Map();
    int i=1;

    toremove.forEach((key, value) {
      pass["${i}"] = value;
      i++;
    });
    return pass;
  }

  Future<Map> addToCartWidget()async{
    Map cartmap = Map();
    await database?.usercart.doc(uid).get().then((datasnapshot) {
      if(datasnapshot.exists){
        Map inter = datasnapshot.data() as Map;
        cartmap.addAll(inter);
      }
      else
      {
        //TODO error
      }
    });
    Map pass = Map();
    int i=1;
    cartmap.forEach((key, value) {
      pass["${i}"] = cartmap[key];
      i++;
    });
    return pass;
  }

  Future<String> getProfile() async{
    DocumentSnapshot? docsnap = await database?.name.doc(uid).get();
    Map details = docsnap?.data() as Map;
    return details["profile"];

  }

  Future storeReview({required String index,required String name,required String review,required String? uid,required Map productmap2})
  async{
    DocumentSnapshot? docsnap = await database?.review.doc(index).get();
    Map<dynamic,dynamic>? store = Map();
    store = docsnap!.data() as Map? ?? Map();

    DocumentSnapshot? docsnap_name = await database?.name.doc(uid).get();
    Map<dynamic,dynamic>? store2 = Map();
    store2 = docsnap_name!.data() as Map? ?? Map();
    String profile = store2["profile"] ?? "";

    String l ="$uid";
    Map<String,String> singleton = {
      "name":name,
      "review": review,
      "profile": profile,
    };
    Map<String,Map<String,String>>? temp = {l:singleton};
    store.removeWhere((key, value){
      bool f=false;
      if(value["name"]==name){
        f = true;
      }
      return f;
    });
    store.addAll(temp);
    Map<String,dynamic> pass = Map();
    int i= 1;
    store.forEach((key,value){
      pass["$i"]=value;
      i++;
    });
    await database?.review.doc(
        "${productmap2[index]["id"]}").set(pass);
  }
}
// id
// id ,title , price , description , category , image

//AlertDialog for toast?
