import 'dart:convert';
import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:firebase_flutter/model/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;



class Item extends ChangeNotifier {

  Map productmap = {};
  var data;
  List<Product> _products = [];
  final String url ="https://fakestoreapi.com/products";
  
  Future<Map<dynamic,dynamic>> products() async {
    var response = await http.get(Uri.parse(url));
    data = json.decode(response.body);

    _products = [];

    print(data);
    data.forEach((e)
    {
      productmap[e["id"]] = e;
    });
    print(url);
    print(productmap);

    return productmap;
  }
}
// id
// id ,title , price , description , category , image

//AlertDialog for toast?
