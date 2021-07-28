import 'package:flutter/cupertino.dart';

class ErrorPopup extends StatelessWidget {
  const ErrorPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Please restart app")),
    );
  }
}
