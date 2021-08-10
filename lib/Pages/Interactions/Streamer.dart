import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Error.dart';

class Streamer extends StatefulWidget {
  @override
  _StreamerState createState() => _StreamerState();
}

class _StreamerState extends State<Streamer> {
  String? uid;
  Item? perform;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    perform = Item.setfirebase(uid: uid);
    uid = Provider.of<User?>(context,listen:false)?.uid;
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    String index = data["index"];
    Map productmap = data["productmap"];
    bool flag = data["flag"];

    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
            title: Text("Review"),
            ),
            body:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot?>(
                    stream: perform?.database?.reviews ,
                    builder:(context , snapshot){
                      if(snapshot.connectionState == ConnectionState.active)
                      {
                        if(snapshot.hasError)
                        {
                          return ErrorPopup();
                        }
                        else
                        {
                          QuerySnapshot? query = snapshot.data;
                          if(query!=null) {
                            int docId = search(query, index);
                            if (docId != query.size) {
                              DocumentSnapshot? docsnap = query.docs[docId];
                              if (docsnap.exists) {
                                bool flag = false;
                                Map? rev = docsnap.data() as Map?;
                                print(rev);
                                print(docsnap.id);
                                print("google.com");
                                return SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    itemCount: rev?.length,
                                    itemBuilder: (context, pos) {
                                      if (rev?['1'] != null) {
                                        flag = true;
                                        return Card(
                                          child: Container(
                                            height: height / 5,
                                            width: width / 5,
                                            child: Padding(
                                              padding: EdgeInsets
                                                  .all(
                                                  8.0),
                                              child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: <
                                                      Widget>[
                                                    ListTile(
                                                      leading: Container(
                                                        height: 50,
                                                        child: Card(
                                                            child: (rev?["${pos +
                                                                1}"]["profile"] == "")?Image(
                                                              image:AssetImage("assets/profile.jpg"),
                                                              fit: BoxFit.fitHeight,
                                                            ):Image(
                                                              image:NetworkImage(rev?["${pos +
                                                                  1}"]["profile"]),
                                                              fit: BoxFit.fitHeight,
                                                            ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                          rev?["${pos +
                                                              1}"]["name"]),
                                                    ),
                                                    Text(
                                                        rev?["${pos +
                                                            1}"]["review"]),
                                                  ]
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      else {
                                        if (((pos + 1) == rev?.length) &&
                                            (!flag)) {
                                          return Text(
                                              "No reviews yet, be the first one");
                                        }
                                        else {
                                          return Container();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }
                              else {
                                return Text(
                                    "No reviews yet, be the first one!");
                              }
                            }
                            else{
                              return Text(
                                  "No reviews yet, be the first one!");
                            }
                          }
                          else
                          {
                            return Text("No reviews yet, be the first one!");
                          }
                        }
                      }
                      else
                      {
                        return Center(child: CircularProgressIndicator());
                      }
                    } ,
                  ),
                ),
                ElevatedButton(onPressed: (flag)?(){showSheet(productmap, index);}:(){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Buy to give review'),
                  ));
                  }, child: Text("Add one")),
              ],
            ),
          )
      )
    );
  }
  int search(QuerySnapshot? query,String index)
  {
    if(query!=null)
      {
        int l= query.size;
        int i=0;
        for(i=0;i<l;i++)
          {
            if(index == query.docs[i].id)
              {
                break;
              }
          }
        return i;
      }
    return query!.size;
  }
  void showSheet(Map? productmap, String index) {
    String review = "";
    showModalBottomSheet(context: context,
        builder: (context) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type review',
                      ),
                      onChanged: (value) {
                        review = value;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if((productmap != null)&&(uid != null)) {
                          await perform?.storeReview(index: index, name: Provider.of<Item>(context,listen:false).name, review: review, uid: uid,productmap2: productmap);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Save"),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}