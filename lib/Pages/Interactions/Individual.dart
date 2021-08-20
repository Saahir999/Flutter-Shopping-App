import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Error.dart';

class Individual extends StatefulWidget {
  const Individual({Key? key}) : super(key: key);

  @override
  _IndividualState createState() => _IndividualState();
}

class _IndividualState extends State<Individual> {
  Authenticate authclass = Authenticate();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double height = 600;
  double width = 250;
  Item? perform;

  @override
  Widget build(BuildContext context) {
    String? uid = Provider
        .of<User?>(context, listen: false)
        ?.uid;
    perform = Item.setfirebase(uid: uid);
    Map data = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    String index = data["index"];
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    bool flag = true;
    if(width>height){
      flag = false;
    }
    Map? productmap = data["productmap"];
    double price = 0.0;
    try {
      price = productmap?[index]["price"] as double;
    }
    catch (e) {
      price = (productmap?[index]["price"] as int) + 0.0;
    }

    void showDetails(String? desc) {
      showModalBottomSheet(context: context,
          builder: (context) {
            return Container(
              child: Column(
                children: <Widget>[
                  Card(child: Text("Description",style:TextStyle(fontSize: 28))),
                  Card(
                    child: Text(desc ?? "",style:TextStyle(fontSize: 22)),
                  ),
                ],
              ),
            );
          }
      );
    }

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Shop"),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'Cart').then((value) {
                            setState(() {});
                          });
                        },
                        child: Icon(
                          Icons.shopping_cart,
                          size: 26.0,
                        ),
                      ),
                      onTap: (){},
                    ),
                ),
                PopupMenuButton<int>(
                  onSelected: (item) => onSelected(context, item, authclass),
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem<int>(
                      child: Text("Settings"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("???"),
                      value: 1,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Sign Out"),
                      value: 2,
                    ),
                  ],
                ),
              ],
            ),
            extendBodyBehindAppBar: false,
            body:  SingleChildScrollView(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ClipRRect(
                              child: Hero(
                                tag: productmap?["$index"]["image"],
                                child: Image.network(
                                  productmap?["$index"]["image"],
                                  height: height / 4,
                                  fit: BoxFit.fitHeight,
                                  alignment: Alignment.topCenter,
                                ),
                              )
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Price: " + "$price" + " INR",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(productmap?[index]["title"]),
                          ),
                          SizedBox(height: 30),
                          InkWell(
                            child: GestureDetector(
                              child: ListTile(
                                title: Text(
                                    "Details"
                                ),
                                trailing: Icon(Icons.info),
                              ),
                              onTap: () {
                                showDetails(productmap?["$index"]["description"]);
                              },
                            ),
                            onTap: (){},
                          ),
                          Icon_Dropdown(index: index,
                              productmap: productmap,
                              perform: perform),
                          SizedBox(height: 30),
                          FutureBuilder<DocumentSnapshot?>(
                            future: perform?.database?.userdata.doc(uid).get(),
                            builder:(context,snapshot){
                              Widget child;
                              bool f=false;
                              if(snapshot.connectionState == ConnectionState.done){
                                if(snapshot.hasError){
                                  child = ErrorPopup();
                                }
                                else if(snapshot.data != null) {
                                  Map? bought = snapshot.data!.data() as Map?;
                                  if(bought != null) {
                                    bought.forEach((key, value) {
                                      if (value["id"] == productmap?[index]["id"]) {
                                        f = true;
                                      }
                                    });
                                  }
                                }
                                child =  ElevatedButton(
                                          child: Text("+ Review", style: TextStyle(
                                              fontSize: 18,
                                              ),
                                            ),
                                          onPressed:() {

                                          Navigator.pushNamed(context, 'Streamer',arguments: {"index":index,
                                          "productmap": productmap,"flag":f
                                          });
                                          } ,
                                        );

                              }
                              else{
                                child = Center(child:CircularProgressIndicator());
                              }
                            return AnimatedSwitcher(
                              duration: Duration(seconds: 1),
                              child: child,
                              );
                            }
                          ),
                        ]
                    ),
                  ),
                ),
              ),


    );
  }


  void onSelected(BuildContext context, int item, Authenticate authclass) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'Settings');
        break;
      case 1:
      //???
        break;
      case 2:
        Provider.of<Item>(context,listen: false).name="";
        Provider.of<Item>(context,listen: false).googleName = "";
        authclass.signOutWithGoogle();
        authclass.signOut();
        break;
    }
  }

}

class Icon_Dropdown extends StatefulWidget {
  Icon_Dropdown({Key? key,required this.index,this.productmap,required this.perform}) : super(key: key);
  String index;
  Map? productmap;
  Item? perform;
  @override
  _Icon_DropdownState createState() => _Icon_DropdownState();
}

class _Icon_DropdownState extends State<Icon_Dropdown> with SingleTickerProviderStateMixin {
  int qty = 1;
  @override
  Widget build(BuildContext context) {

    bool absorbflag = false;
    Map? productmap = widget.productmap;
    String index = widget.index;
    Item? perform = widget.perform;

    return FutureBuilder<Map?>(
        future: perform?.addToCartWidget(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.done) {
            Map? cartproduct = snapshot.data;
            if (snapshot.hasError) {
              child = ErrorPopup();
            }
            else {
              bool flag = false;
              Provider.of<Item>(context,listen:false).check = flag;
              if (cartproduct!= null && cartproduct["1"] !=null) {
                cartproduct.forEach((key, value) {
                  if (cartproduct["$key"]["id"] ==
                      productmap?["$index"]["id"]) {
                    flag = true;
                    qty = cartproduct["$key"]["qty"];
                    Provider.of<Item>(context,listen:false).check = flag;
                    absorbflag = true;
                  }
                });
              }
              child = ListTile(
                  leading: IconButton(
                    icon:
                    (!flag) ? Icon(Icons.add_shopping_cart,size: 24) : Icon(Icons.done, size:24),
                    onPressed: () async {
                      if (!flag) {
                        await perform?.database?.add_cart(
                            productmap?["$index"],qty);
                        absorbflag = true;
                        setState(() {

                        });
                      }
                      else {
                        absorbflag = false;
                        await perform?.database?.remove_cart(
                            productmap?["$index"],qty);
                        setState(() {

                        });
                      }
                    },
                  ),
                  title: Text("Add qty to Cart"),
                  trailing: AbsorbPointer(
                    absorbing: absorbflag,
                    child: DropdownButton<int>(
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map<
                          DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: new Text("$value"),
                        );
                      }).toList(),
                      value: qty,
                      icon: Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          qty = newValue!;
                        });
                      },
                    ),
                  )
              );
            }
          }
          else {
            child = Center(
                child:CircularProgressIndicator()
            );
          }
          return AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: child,
          );
        }
    );
  }
}






