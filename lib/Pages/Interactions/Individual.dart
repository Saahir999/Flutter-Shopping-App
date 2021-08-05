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
  int dropdownValue = 1;
  double height = 600;
  double width = 250;
  Item? perform;
  int qty = 0;
  bool absorbflag = false;
  @override
  Widget build(BuildContext context) {

    String? uid = Provider.of<User?>(context,listen:false)?.uid;
    perform = Item.setfirebase(uid:uid);
    Map data  = ModalRoute.of(context)?.settings.arguments as Map;
    String index = data["index"];
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    Map? productmap = data["productmap"];
    double price = 0.0;
    try{
       price = productmap?[index]["price"]  as double ;
    }
    catch(e){
       price = (productmap?[index]["price"]  as int) + 0.0;
    }

    void showSheet(Map? productmap,String index)
    {
      String review = "";
      showModalBottomSheet(context: context,
          builder:(context){
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
                        onChanged: (value){
                          review = value;
                        },
                      ),
                      ElevatedButton(
                        onPressed: ()async{
                          await perform?.database?.review.doc("${productmap?[index]["id"]}").set({
                            "name": Provider.of<Item>(context,listen:false).name,
                            "review" : review,
                          });
                          print(productmap?[index]["id"]);
                          Navigator.pop(context);
                        },
                        child:Text("Save"),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      );
    }

    void showDetails(String? desc)
    {
      showModalBottomSheet(context: context,
          builder:(context){
            return Container(
              child: Column(
                children: <Widget>[
                   Text("Description"),
                  Card(
                    child: Text(desc?? ""),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'Cart').then((value){ setState((){}); });
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
        body:FutureBuilder<Map?>(
          future: perform?.addToCartWidget(),
          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              Map? cartproduct = snapshot.data;
              if(snapshot.hasError)
                {
                  return ErrorPopup();
                }
              else {
                bool flag = false;
                if(cartproduct?["1"]!=null) {
                  cartproduct?.forEach((key, value) {
                    if (cartproduct["$key"]["id"] ==
                        productmap?["$index"]["id"]) {
                      flag = true;
                      absorbflag = true;
                    }
                  });
                }
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                        ClipRRect(
                            child: Hero(
                              tag: productmap?["$index"]["image"],
                              child: Image.network(
                                productmap?["$index"]["image"],
                                height: height/4,
                                fit: BoxFit.fitHeight,
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
                            leading: IconButton(
                              icon: Icon(
                                  (!flag) ? Icons.add_shopping_cart : Icons
                                      .done),
                              onPressed: () async{
                                var p = productmap?["$index"]["price"];
                                if (!flag) {
                                  productmap?["$index"]["price"] = qty*p;
                                  await perform?.database?.add_cart(
                                      productmap?["$index"]);
                                  absorbflag = true;
                                  setState(() {});
                                }
                                else {
                                  absorbflag = false;
                                  productmap?["$index"]["price"] = qty*p;
                                  await perform?.database?.remove_cart(
                                      productmap?["$index"]);
                                  setState(() {});
                                }
                              },
                            ),
                            title: Text("Add qty to Cart"),
                            trailing: AbsorbPointer(
                              absorbing: absorbflag,
                              child: DropdownButton<int>(
                                items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map<
                                    DropdownMenuItem<int>>((int value) {
                                      qty = value;
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: new Text("$value"),
                                  );
                                }).toList(),
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
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
                                "Details"
                            ),
                            trailing: Icon(Icons.info),
                          ),
                          onTap: () {
                            showDetails(productmap?["$index"]["description"]);
                          },
                        ),

                        StreamBuilder<QuerySnapshot?>(
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
                                if(query!= null) {
                                  int k=0;
                                  bool flag = false;
                                  return SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      itemCount: query.docs.length,
                                      itemBuilder: (context, i) {
                                        DocumentSnapshot? docsnap = query
                                            .docs[i];
                                        Map? rev = docsnap
                                            .data() as Map?;
                                        if(docsnap.id == "${productmap?["$index"]["id"]}") {
                                          if (rev?["review"] != null) {
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
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <
                                                          Widget>[
                                                        ListTile(
                                                          leading: Card(
                                                              child: (Icon(
                                                                  Icons
                                                                      .person_pin))),
                                                          title: Text(
                                                              rev?["name"]),
                                                        ),
                                                        Text(
                                                            rev?["review"]),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          else {
                                            return Container();
                                          }
                                        }
                                        else{
                                          if((k==0)&&(!flag)){
                                            k++;
                                            return Text("No reviews yet, be the first one!");
                                          }
                                          else{
                                            return Container();
                                          }
                                        }
                                      },
                                    ),
                                  );
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
                        ElevatedButton(
                          child: Text("+ Review"
                          ,style: TextStyle(
                              backgroundColor: Colors.blue,
                              ),
                            ),
                          onPressed:(){
                            showSheet(productmap,index);
                          } ,
                        ),
                      ]
                    ),
                  ),
                );
              }
            }
            else
              {
                return Center(
                  child:CircularProgressIndicator()
                );
              }
          }
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

  Widget Streamer(BuildContext context,String index , Map? productmap)
  {
    return StreamBuilder<QuerySnapshot?>(
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
            if(query!= null) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: query.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot? docsnap = query
                        .docs[index];
                    Map? rev = docsnap
                        .data() as Map?;
                    print("google.com");
                    print(docsnap.id);
                    print("google.com");
                    print("${productmap?["$index"]?["id"]}");
                    if(docsnap.id == "${productmap?["$index"]?["id"]}") {
                      if (rev?["review"] != null) {
                        return Card(
                          child: Container(
                            height: height / 5,
                            width: width / 5,
                            child: Padding(
                              padding: EdgeInsets
                                  .all(
                                  8.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <
                                      Widget>[
                                    ListTile(
                                      leading: Card(
                                          child: (Icon(
                                              Icons
                                                  .person_pin))),
                                      title: Text(
                                          rev?["name"]),
                                    ),
                                    Text(
                                        rev?["review"]),
                                  ]
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return Container();
                        //return Text("No reviews yet, be the first one!");

                      }
                    }
                    else{
                      return Container();
                    }
                  },
                ),
              );
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
    );
  }


}
