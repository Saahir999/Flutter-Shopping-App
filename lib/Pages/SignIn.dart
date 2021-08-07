import 'package:flutter/material.dart';
import '../FireBase/Authentication.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin{

  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation _sizeAnimate;
  late Animation _sizeAnimate2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 700),
        vsync: this);
    _sizeAnimate = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 100, end: 0), weight: 100),
        ]
    ).animate(_controller);
    _sizeAnimate2 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 0, end: 100), weight: 100),
        ]
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }
    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      Authenticate authclass = Authenticate();

      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              actions: [
                ElevatedButton(onPressed: () => widget.toggleView(),
                    child: Text("Register"))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
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
                    SizedBox(height:10.0),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: _sizeAnimate.value / 100,
                            child: Container(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await _controller.forward();
                                  authclass.signInWithEmail(email, password);
                                },
                                icon: Icon(Icons.verified,
                                  size: _sizeAnimate.value / 5,
                                ),
                                label: Text("Sign In", style: TextStyle(
                                    fontSize: _sizeAnimate.value / 5),),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: _sizeAnimate2.value / 100,
                            child: Container(
                              height: _sizeAnimate2.value / 2,
                              width: _sizeAnimate2.value / 2,
                              child: CircularProgressIndicator(
                                strokeWidth: _sizeAnimate2.value / 15,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
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