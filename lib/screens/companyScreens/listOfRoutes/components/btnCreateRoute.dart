import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/createRoute/createRouteScreen.dart';
import 'package:spediter/theme/style.dart';


class BottomAppBar1 extends StatelessWidget {
  final String text = "KREIRAJ RUTU";

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 154.0,
      height: 36.0,
      child: RaisedButton.icon(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateRoute()));
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          text,
          style: TextStyle(
              fontSize: 14, fontFamily: "Roboto", color: Colors.white),
        ),
        color: StyleColors().blueColor,
      ),
    );
  }
}
