import 'package:cloud_firestore/cloud_firestore.dart';

class Database
{
  final CollectionReference userdata = FirebaseFirestore.instance.collection('user_data');
  final CollectionReference usercart = FirebaseFirestore.instance.collection('user_cart');
  final String uid;
  Database({required this.uid});

  Future buy() async
  {
    await add_to_cart();
    return await userdata.doc(uid).set({});
  }

  Future add_to_cart() async{
    return await usercart.doc(uid).set({});
  }


  // delete data from cart
}