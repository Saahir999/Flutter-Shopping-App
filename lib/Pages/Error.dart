import 'package:flutter/cupertino.dart';

class ErrorPopup extends StatelessWidget {
  const ErrorPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Column(
        children: <Widget>[
          Image(image:AssetImage("assets/Error.jpg"),),
          Text("Please Check your internet connection"),
        ],
      )),
    );
  }
}
