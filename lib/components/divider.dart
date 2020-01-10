import 'package:flutter/material.dart';
import 'package:spediter/theme/style.dart';

class Divider1 extends StatelessWidget {

  double thickness, height;
  Divider1({this.thickness, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0),
      height: height,
      decoration: BoxDecoration(
          border: Border(
        //top: BorderSide(width: 1, color: StyleColors().textColorGray12),
        bottom: BorderSide(width: 1, color: StyleColors().textColorGray12),
      )),
      child: Divider(
        thickness: thickness,
        color: StyleColors().textColorGray3,
      ),
    );
  }
}
