import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

//TODO -> form validation
class _HomeState extends State<Home> {
  Map? productmap = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Authenticate authclass = Authenticate();
  double height =100.0;
  double width = 100.0;

  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Register
    if(Provider.of<Item>(context,listen:false).name !="")
    {
      FirebaseFirestore.instance.collection("name").doc("${Provider.of<User?>(context,listen:false)?.uid}").set({
        "name":Provider.of<Item>(context,listen:false).name,
        "profile":"",
      });
    }
    if(Provider.of<Item>(context,listen:false).googleName !="")
    {
      FirebaseFirestore.instance.collection("name").doc("${Provider.of<User?>(context,listen:false)?.uid}").set({
        "name":Provider.of<Item>(context,listen:false).googleName,
        "profile":"",
      });
    }
    print("dependencies");
    username(context);
  }
  void username(BuildContext context) async
  {
    //Sign In
    print("username");
    DocumentSnapshot? docsnap = await FirebaseFirestore.instance.collection(
        "name").doc(Provider
        .of<User?>(context, listen: false)
        ?.uid).get();
    Map ext = docsnap.data() as Map;
    Provider
        .of<Item>(context, listen: false)
        .name = ext["name"];
    //await Future.delayed(const Duration(seconds: 2), () {});
  }
  int k=0;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    if(k<1){username(context); k++;setState((){});}
    String? uid =  Provider.of<User?>(context,listen:false)?.uid;
    Item perform = Item.setfirebase(uid:uid);

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
                  child: InkWell(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'Cart');
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        size: 26.0,
                      ),
                    ),
                    onTap: (){
                    },
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
          drawer: FutureBuilder(
            future: FirebaseFirestore.instance.collection(
                "name").doc(Provider
                .of<User?>(context, listen: false)
                ?.uid).get(),
            builder: (context,snapshot) {
              Widget child;
              if(snapshot.hasData) {
                Map? ext = (snapshot.data! as DocumentSnapshot?)!.data() as Map?;
                Provider
                    .of<Item>(context, listen: false)
                    .name = ext?["name"];
                child = Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text("Welcome,${Provider
                            .of<Item>(context, listen: false)
                            .name}", style: TextStyle(fontSize: 18),),
                      ),
                      ListTile(
                        title: const Text('Your Order'),
                        onTap: () {
                          Navigator.pushNamed(context, 'Orders');
                        },
                      ),
                      (uid == "tkq0ZcOJawV8AUMTqWKBj5nMuf32") ? ListTile(
                        title: const Text('Add Items'),
                        onTap: () {
                          Navigator.pushNamed(context, 'Add').then((value) =>
                              setState(() {}));
                        },
                      ) : Container(),
                      (uid == "tkq0ZcOJawV8AUMTqWKBj5nMuf32") ? ListTile(
                        title: const Text('Remove Items'),
                        onTap: () {
                          Navigator.pushNamed(context, 'Remove').then((value) =>
                              setState(() {}));
                        },
                      ) : Container(),
                    ],
                  ),
                );
              }
              else
                {
                  child = CircularProgressIndicator();
                }
              return AnimatedSwitcher(duration: Duration(milliseconds: 300),child:child);
            }
          ),
          body: Stack(
            children: [
              Container(height: height,width: width,child: Image.asset("assets/bg2.jpg",fit:BoxFit.fill)),
              FutureBuilder<Map>(
                  future: perform.products(),
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
                            InkWell(
                              child: GestureDetector(
                                onTap: ()async{
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  Navigator.pushNamed(context, 'Grid',arguments: productmap);},
                                child: ListTile(
                                  leading : Text("Products",style: TextStyle(color: Colors.white),),
                                  trailing: Icon(Icons.arrow_forward_outlined,color: Colors.white,),
                                ),
                              ),
                              onTap: (){},
                            ),
                             SizedBox(height: 20),
                             SizedBox(
                               height: height/6,
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
                                                (productmap?["${index + 1}"])["image"],
                                                loadingBuilder: (context , child , progress){
                                                  return progress == null
                                                      ? child
                                                      : CircularProgressIndicator();
                                                },
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'Individual' , arguments: {
                                                'index' : "${index+1}",
                                                'productmap' : productmap
                                              });
                                            },
                                              iconSize: height/8,
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
        ),
            ],
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
        Provider.of<Item>(context,listen: false).name="";
        Provider.of<Item>(context,listen: false).googleName = "";
        authclass.signOutWithGoogle();
        k=0;
        authclass.signOut();
        break;
    }
  }
}