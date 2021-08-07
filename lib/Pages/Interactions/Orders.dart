import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:firebase_flutter/Pages/Error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Loading.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<User?>(context,listen:false)?.uid;
    Item perform = Item.setfirebase(uid: uid);
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
        actions: [
          ElevatedButton(onPressed:(){ setState((){}); }, child: Text("Refresh"))
        ],
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: perform.database?.userdata.doc(uid).get(),
        builder: (context , snapshot){

          if(snapshot.connectionState == ConnectionState.done)
          {
            DocumentSnapshot? documentSnapshot = snapshot.data;
            Map? temp = Map();
            if(documentSnapshot!.exists)
            {
              temp = documentSnapshot.data() as Map;
            }
            if(snapshot.hasError)
              {
                return ErrorPopup();
              }
            else
              {
                if(temp["1"]!= null)
                  {
                    int? len =0;
                    len = temp.length;

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Image(
                                  image: NetworkImage(temp?["${index+1}"]["image"]),
                                  width: width/5,
                                  height: height/5,
                                ),
                                title: Text(temp?["${index+1}"]["title"]),
                              );
                            },
                            itemCount: len,
                          ),
                        )
                      ],
                    );
                }
                else
                  {
                    return Center(child: Text("No order history"),);
                  }
              }
          }
          else
            {
              return Loading();
            }
        },
      ),
    );
  }
}
