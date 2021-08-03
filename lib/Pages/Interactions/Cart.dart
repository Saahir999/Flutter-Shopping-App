import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Error.dart';
import '../Loading.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map? calcprice = Map();
  double height = 700;
  double pay = 0;
  double width = 250;
  Item? perform;
  Map boughtproduct = Map();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width =mediaQuery.size.width;
    pay = 0;
    calcprice = Map();
    String? uid = Provider
        .of<User?>(context, listen: false)
        ?.uid;
    perform = Item.setfirebase(uid: uid);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          actions: [
            ElevatedButton(onPressed:(){ setState((){}); }, child: Text("Refresh"))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 500,
                child: FutureBuilder<Map?>(
                  future: perform?.addToCartWidget(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<dynamic,dynamic>? cartmap = Map();
                      if (snapshot.hasError) {
                        return ErrorPopup();
                      }
                      else {
                        cartmap = snapshot.data!;
                        int len = cartmap.length;
                        if (cartmap["1"] != null ) {
                          boughtproduct = cartmap;
                          return Container(
                            height: 700,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  calcprice = cartmap;
                                }
                                return Dismissible(
                                  key: ValueKey<int>(4),
                                  child: ListTile(
                                    leading: Container(
                                      height: height/5,
                                      child: Image(
                                        image: NetworkImage(
                                            cartmap?["${index + 1}"]["image"]),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    title: Text(cartmap?["${index + 1}"]["title"]),
                                    subtitle:Text( "${cartmap?["${index + 1}"]["price"]}"),
                                  ),
                                  onDismissed: (direction)async{
                                    await perform?.database?.remove_cart(
                                        cartmap?["${index+1}"]);

                                    setState((){
                                      cartmap?.forEach((key, value) {
                                        if(key == (index+1))
                                        {
                                          cartmap?.remove(key);
                                        }
                                      });
                                    });
                                  },
                                );
                              },
                              itemCount: len,
                            ),
                          );
                        }
                        else
                          {
                            return Container(
                              child: Text("No products in Cart"),
                            );
                          }
                      }
                    }
                    else {
                      return Loading();
                    }
                  },
                ),
              ),
              FutureBuilder<Map>(
                  future: perform?.addToCartWidget(),
                  builder: (context , snapshot){
                    if(snapshot.connectionState == ConnectionState.done)
                      {
                        if(snapshot.hasError)
                          {
                            return price(context);
                          }
                        else
                          {
                            Map<String,dynamic> temp= Map();
                            Map? priceholder = snapshot.data;
                            if(priceholder!= null) {
                              int i = 1;
                              priceholder.forEach((key, value) {
                                pay = pay+ value["price"];
                              });

                              priceholder.forEach((key,value){
                                temp["${i}"]= value;
                                i++;
                              });
                            }
                            return Container(
                              child: Ink(
                                color: Colors.blue,
                                child: InkWell(
                                  child: GestureDetector(
                                    child: ListTile(
                                      title: Text("Proceed to Pay $pay"),

                                    ),
                                      onTap: ()async{
                                        await perform?.database?.buy(temp);
                                        await perform?.database?.usercart.doc(uid).delete();
                                        Navigator.pushNamed(context, "Orders");
                                      }
                                  ),
                                ),
                              ),
                            );
                          }
                      }
                    else
                      {
                        return CircularProgressIndicator();
                      }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget price(BuildContext context) {
    if (boughtproduct != null) {
      int? len = boughtproduct.length;
      for (int index = 1; index <= len; index++) {
        pay = pay + boughtproduct["$index"]["price"];
      }
    }
    setState(() {

    });
    return Container(
      child: Ink(
        color: Colors.blue,
        child: InkWell(
          child: GestureDetector(
            child: ListTile(
              title: Text("Proceed to Pay $pay"),

            ),
            onTap: () async{
              Map<String,dynamic> temp = Map();
              if(boughtproduct!= null) {
                int i=1;
                boughtproduct.forEach((key,value){
                  temp["${i}"]= value;
                  i++;
                });
                await perform?.database?.buy(temp);
              }
              Navigator.pushNamed(context, "Orders");
            },
          ),
        ),
      ),
    );
  }
}
