import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Error.dart';
import '../Loading.dart';

class Individual extends StatefulWidget {
  const Individual({Key? key}) : super(key: key);

  @override
  _IndividualState createState() => _IndividualState();
}

class _IndividualState extends State<Individual> {
  Authenticate authclass = Authenticate();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int dropdownValue = 1;
  @override
  Widget build(BuildContext context) {
    bool flag = false;
    Map data  = ModalRoute.of(context)?.settings.arguments as Map;
    int index = data["index"];
    Map? productmap = data["productmap"];
    double price = productmap?[index]["price"]  as double ;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text("Shop"),
          centerTitle: true,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'Cart');
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    size: 26.0,
                  ),
                )),
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
      body:SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                          child: Hero(
                            tag: productmap?[index]["image"],
                            child: Image.network(
                              productmap?[index]["image"],
                              height: 360,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          )
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Price: " + "$price" + " INR",
                        style: TextStyle(

                        ),
                      ),
                      SizedBox(height: 30),
                      ListTile(
                        leading: Icon(Icons.add_shopping_cart),
                        title: Text("Add qty to Cart"),
                        trailing: AbsorbPointer(
                          absorbing: flag,
                          child: DropdownButton<int>(
                            items: <int>[1,2,3,4,5,6,7,8,9,10].map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: new Text("$value"),
                              );
                            }).toList(),
                            value: dropdownValue,
                            icon:Icon(Icons.arrow_downward),
                            elevation: 16,
                            style:TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                        )
                      ),
                    SizedBox(height: 30),
                    GestureDetector(
                      child: ListTile(
                        title: Text(
                          "Details & Review"
                        ),
                        trailing:Icon(Icons.info) ,
                      ),
                      onTap:(){
                        //TODO -> Navigate to Details&Review and pass details from productmap
                      } ,
                    ),
                  ]
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
        authclass.signOut();
        break;
    }
  }
}
