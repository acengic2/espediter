import 'package:flutter/material.dart';

class BtnVratiteSe extends StatelessWidget {
  final String buttonText = "VRATITE SE";

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: Colors.white,
      child: Text(
        buttonText,
        style:
            TextStyle(fontSize: 14, fontFamily: "Roboto", color: Colors.black),
      ),
    );
  }
}
