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

class _CartState extends State<Cart> with SingleTickerProviderStateMixin{
  Map? calcprice = Map();
  double height = 700;
  double pay = 0;
  double sum = 0;
  double width = 250;
  Item? perform;
  Map boughtproduct = Map();
  late AnimationController _controller;
  late Animation _sizeAnimate;
  late Animation _sizeAnimate2;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration:Duration(milliseconds: 700),
        vsync: this);
    _sizeAnimate = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(tween:Tween<double>(begin: 100,end: 0),weight:100),
        ]
    ).animate(_controller);
    _sizeAnimate2 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(tween:Tween<double>(begin: 0,end: 100),weight:100),
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
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width =mediaQuery.size.width;
    pay = 0;
    sum =0;
    bool flag = true;
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
        body: Stack(
          children: [
            Container(height: height,child: Image.asset("assets/background.jpg",fit:BoxFit.fitHeight)),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: height - 200,
                    child: FutureBuilder<Map?>(
                      future: perform?.addToCartWidget(),
                      builder: (context, snapshot) {
                        Widget child;
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<dynamic,dynamic>? cartmap;
                          if (snapshot.hasError) {
                            child = ErrorPopup();
                          }
                          else {
                            cartmap = snapshot.data;
                            int len = cartmap?.length ?? 0;
                            if (cartmap != null ) {
                              boughtproduct = cartmap ;
                              child =  Container(
                                height: 700,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      calcprice = cartmap;
                                    }
                                    double p = ((cartmap?["${index + 1}"]["price"]).toDouble() )*((cartmap?["${index + 1}"]["qty"]).toDouble());
                                    return Dismissible(
                                      key: ValueKey<int>(4),
                                      child: InkWell(
                                        child: GestureDetector(
                                          child: Card(
                                            child: ListTile(
                                              leading:  Image(
                                                  image: NetworkImage(
                                                      cartmap?["${index + 1}"]["image"]),
                                                      width: width/5,
                                                      height: height/5,
                                                      ),
                                              title: Text(cartmap?["${index + 1}"]["title"]),
                                              subtitle:Text( "${p}"),
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.popAndPushNamed(context,'Individual',arguments: {
                                              'index' : "${index+1}",
                                              'productmap' : cartmap,
                                            } );
                                          },
                                        ),
                                        onTap: (){},
                                      ),
                                      onDismissed: (direction)async{
                                        await perform?.database?.remove_cart(
                                            cartmap?["${index+1}"],cartmap?["${index+1}"]["qty"]);

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
                                child = Container(
                                  child: Text("No products in Cart"),
                                );
                              }
                          }
                        }
                        else {
                          child = Loading();
                        }
                        return AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          child: child,
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder<Map>(
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
                                  if(priceholder!["1"]!= null) {
                                    int i = 1;
                                    flag = false;
                                    priceholder.forEach((key, value) {
                                      pay = pay+ value["price"]* value["qty"];
                                    });

                                    priceholder.forEach((key,value){
                                      temp["${i}"]= value;
                                      i++;
                                    });
                                  }
                                  return Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Opacity(
                                          opacity: _sizeAnimate.value/100,
                                          child: Container(
                                            child: ElevatedButton(
                                              onPressed: (!flag)?()async{
                                                await _controller.forward();
                                                await perform?.database?.buy(temp);
                                                await perform?.database?.usercart.doc(uid).delete();
                                                Navigator.popUntil(context,ModalRoute.withName('home'));
                                                Navigator.pushNamed(context,'Orders');
                                              }:null,
                                              child: Text("Proceed to pay ${pay.toInt()}",style: TextStyle(fontSize: _sizeAnimate.value/5),),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Opacity(
                                            opacity: _sizeAnimate2.value/100,
                                            child: Container(
                                              height: _sizeAnimate2.value/2,
                                              width: _sizeAnimate2.value/2,
                                              child: CircularProgressIndicator(
                                                strokeWidth: _sizeAnimate2.value/18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                  ),
                ],
              ),
            ),
          ],
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
                  temp["$i"]= value;
                  i++;
                });
                await perform?.database?.buy(temp);
              }
              Navigator.pushNamed(context, "Orders");
            },
          ),
          onTap: (){},
        ),
      ),
    );
  }
}
