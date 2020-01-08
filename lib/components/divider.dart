import 'package:flutter/material.dart';
import 'package:spediter/theme/style.dart';

class Divider1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return

        /// DIVIDER
        Container(
      margin: EdgeInsets.only(top: 0, bottom: 0),
      height: 8,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 1, color: StyleColors().textColorGray12),
        bottom: BorderSide(width: 1, color: StyleColors().textColorGray12),
      )),
      child: Divider(
        thickness: 8,
        color: StyleColors().textColorGray3,
      ),
    );
  }
}
