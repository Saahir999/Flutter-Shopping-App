import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:firebase_flutter/Pages/Error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Loading.dart';

class Remove extends StatefulWidget {
  const Remove({Key? key}) : super(key: key);

  @override
  _RemoveState createState() => _RemoveState();
}

class _RemoveState extends State<Remove> {
  @override
  double height = 600;
  double width = 250;
  Map? productmap;
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    Item perform = Item.setfirebase(uid: Provider.of<User?>(context,listen:false)?.uid);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Delete"),
          ),
          body:FutureBuilder<Map>(
              future: perform.products(),
              builder: (context, snapshot) {
                Widget child;
                if(snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    //Toast error
                    child = ErrorPopup();
                  }
                  else {
                    productmap = snapshot.data;
                    child = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 600,
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                itemCount: productmap?.length,
                                itemBuilder: (context , index){
                                  return Dismissible(
                                    key: ValueKey<int>(3),
                                    child: ListTile(
                                      leading: Image(
                                        image: NetworkImage(productmap?["${index+1}"]['image']),
                                        width: width/5,
                                        height: height/5,
                                        loadingBuilder: (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : CircularProgressIndicator();
                                        },
                                      ),
                                      title: Text(productmap?["${index+1}"]['title']),
                                      subtitle: Text("${productmap?["${index+1}"]['price']}"),
                                    ),
                                    onDismissed: (direction){
                                      setState((){
                                        perform.database?.deleteitem(productmap?["${index+1}"]);
                                        productmap?.forEach((key, value) {
                                          if(key == (index+1))
                                            {
                                              productmap?.remove(key);
                                            }
                                        });
                                      });
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                        ),

                    );
                  }
                }
                else
                {
                  child = CircularProgressIndicator();
                }
                return AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: child,
                );
              }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () { Navigator.popUntil(context, ModalRoute.withName('home')); },
            child: Text("Save"),
          ),
        )
    );
  }

}
