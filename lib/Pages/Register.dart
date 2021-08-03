
import 'package:flutter/material.dart';

import '../FireBase/Authentication.dart';
import 'Loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({ required this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {

  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Authenticate authclass = Authenticate();
    return MaterialApp(
      home: loading ? Loading() : SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[900],
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Register",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            actions: [
              ElevatedButton(onPressed: ()=> widget.toggleView(), child:Text("Sign In"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.mail),
                    title: TextFormField(

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
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.vpn_key),
                    title: TextFormField(
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
                  ElevatedButton.icon(
                      onPressed: ()  {
                        final result = authclass.registerWithEmail(
                                email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                'Could not sign in with those credentials';
                              });
                            }


                      },
                    icon: Icon(Icons.verified),
                    label: Text("Register"),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
