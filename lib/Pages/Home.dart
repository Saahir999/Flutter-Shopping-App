import 'package:firebase_flutter/Pages/Error.dart';
import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Itemholder/Items.dart';
import 'Loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

//TODO-> displaying using listvioew builder and later gridview
//TODO -> form validation , firebase error report
//TODO -> implementing add and delete feature in class Item extends ChangeNotifier
//TODO -> Taking a snapshot of firestore database acc to uid to access poducts and links
class _HomeState extends State<Home> {
  Map? productmap = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Authenticate authclass = Authenticate();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
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
            child:ListView(
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
          body: FutureBuilder<Map>(
              future: Provider.of<Item>(context, listen: false).products(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                  //Toast error
                  return ErrorPopup();
                  }
                  else {
                  productmap = snapshot.data;
                  int? len = productmap?.length;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        GestureDetector(
                          onTap: (){Navigator.pushNamed(context, 'Grid',arguments: productmap);},
                          child: ListTile(
                            leading : Text("Products"),
                            trailing: Icon(Icons.arrow_forward_outlined),
                          ),
                        ),
                         SizedBox(height: 20),
                         SizedBox(
                           height: 100,
                           child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: len ?? 0,
                                itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    child: Column(
                                    children: <Widget>[
                                       IconButton(
                                          icon : Image.network(
                                            (productmap?[index + 1])["image"],
                                            loadingBuilder: (context , child , progress){
                                              return progress == null
                                                  ? child
                                                  : CircularProgressIndicator();
                                            },
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'Individual' , arguments: {
                                            'index' : (index+1),
                                            'productmap' : productmap
                                          });
                                        },
                                          iconSize: 50,
                                        ),
                                    ]
                                  ),
                              ),
                            );
                          }
                        ),
                       ),
                      ]
                    ),
                ),
                  );
              }
            }
            else
            {
              return Loading();
            }
          }
        )

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