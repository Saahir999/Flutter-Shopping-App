import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Firebase/Authentication.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> with SingleTickerProviderStateMixin{

  Authenticate authclass  = Authenticate();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ListTile> productgrid = [];
  late AnimationController _controller;
  late Animation _sizeAnimate;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration:Duration(milliseconds: 800),
        vsync: this);
    _sizeAnimate = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(tween:Tween<double>(begin: 270,end: 8),weight:100),
        ]
    ).animate(_controller);
    _controller.addListener(() {
      setState((){});
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _controller.forward();
    var productmap = ModalRoute.of(context)?.settings.arguments as Map;
    int axes =2;
    String? uid = Provider.of<User?>(context,listen:false)?.uid;
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width =mediaQuery.size.width;
    if(width>=height){
      axes = 4;
    }
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
                  onTap:(){},
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
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Welcome,${Provider.of<Item>(context,listen:false).name}",style: TextStyle(fontSize: 18),),
              ),
              ListTile(
                title: const Text('Your Order'),
                onTap: () {
                  Navigator.pushNamed(context, 'Orders');
                },
              ),
              (uid == "tkq0ZcOJawV8AUMTqWKBj5nMuf32")?ListTile(
                title: const Text('Add Items'),
                onTap: () {
                  Navigator.pushNamed(context, 'Add').then((value) => setState(() {}));
                },
              ):Container(),
              (uid == "tkq0ZcOJawV8AUMTqWKBj5nMuf32")?ListTile(
                title: const Text('Remove Items'),
                onTap: () {
                  Navigator.pushNamed(context, 'Remove').then((value) => setState(() {}));
                },
              ):Container(),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(height: height,child: Image.asset("assets/background.jpg",fit:BoxFit.fitHeight)),
            Padding(
              padding: EdgeInsets.fromLTRB(3.0,_sizeAnimate.value,3.0,3.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: axes,
                  children : fetch(productmap , context),
                ),
              ),
          ),
        ]
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

  List<Widget> fetch(Map? productmap , BuildContext context) {
    Widget w(String index) => InkWell(
      child: GestureDetector(
        child: Container(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    //width:MediaQuery.of(context).size.width/2.2 ,  //Fitting 3.5 elements on screen in a column
                    //width: MediaQuery.of(context).size.height / 3.8 ,
                    //height: height/8.5,
                    flex: 6,
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
                  Flexible(
                    //height: height/9.0,
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          productmap?[index]["title"],

                      ),
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
      ),
      onTap: (){},
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


