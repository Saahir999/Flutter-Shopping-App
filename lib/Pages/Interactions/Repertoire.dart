import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Error.dart';
import '../Loading.dart';

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {

  Authenticate authclass  = Authenticate();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ListTile> productgrid = [];
  @override
  Widget build(BuildContext context) {

    var productmap = ModalRoute.of(context)?.settings.arguments as Map;

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
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Edit'),
              ),
              ListTile(
                title: const Text('Your Order'),
                onTap: () {
                  Navigator.pushNamed(context, 'Orders');
                },
              ),
              ListTile(
                title: const Text('Add Items'),
                onTap: () {
                  Navigator.pushNamed(context, 'Add');
                },
              ),
              ListTile(
                title: const Text('Remove Items'),
                onTap: () {
                  Navigator.pushNamed(context, 'Remove');
                },
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  children : fetch(productmap , context),
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

  List<Widget> fetch(Map? productmap , BuildContext context) {
    Widget w(int index) => GestureDetector(
      child: Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //width:MediaQuery.of(context).size.width/2.2 ,  //Fitting 3.5 elements on screen in a column
                  //width: MediaQuery.of(context).size.height / 3.8 ,
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Hero(
                      tag: productmap?[index]["image"],
                      child: Image(
                        image: NetworkImage(productmap?[index]["image"]),
                        fit: BoxFit.fill,
                        loadingBuilder: (context , child , progress){
                          return progress == null
                              ? child
                              : CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 75.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(productmap?[index]["title"]),
                  ),
                ),
              ],
            ),
          )
      ),
      onTap: (){
        Navigator.pushNamed(context, 'Individual', arguments: {
          'index' : index,
          'productmap' : productmap
        });
      },
    );

    List<Widget> grid = [];
    productmap?.forEach((key, value) {
      grid.add(w(key));
    });

    return grid;
  }

  String? shorten(String? title)
  {
    int len = title?.length ?? 0;
    int i = 0;
    for(i = 0; i<len;i++)
      {
        if(title?[i]!=' ')
          {
            break;
          }
      }
    return title?.substring(0,i);
  }
}


