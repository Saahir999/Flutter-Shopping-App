import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FireBase/Authentication.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}
//TODO -> padding the container for icon
//TODO -> OR ListTile with title as TextFormField
class _SignInState extends State<SignIn> {

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    Authenticate authclass = Authenticate();
    return MaterialApp(
      home: SafeArea(
        child:Scaffold(
          backgroundColor: Colors.blue[900],
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            actions: <Widget>[
              //ElevatedButton.icon(onPressed: onPressed, icon: icon, label: label)
            ],
          ),
          body:Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.blue[400],
                        child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(Icons.mail)

                        ),
                      ),
                    ),
                    Form(
                      child:Flexible(
                        flex: 4,
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 20.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pink,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.blue[400],
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: SizedBox(
                              child: Icon(Icons.vpn_key)
                          ),
                        ),
                      ),
                    ),
                    Form(
                      child:Flexible(
                        flex: 4,
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 20.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pink,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                 ElevatedButton.icon(
                   onPressed: ()
                   {
                     authclass.registerWithEmail(email, password);
                   },
                      icon: Icon(Icons.verified),
                      label: Text("Sign In"),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
