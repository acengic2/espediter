import 'package:flutter/material.dart';
import 'package:spediter/theme/style.dart';

class DestinationLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      height: 12,
      width: 0,
      decoration: BoxDecoration(
          border: Border.all(color: StyleColors().textColorGray12)),
    );
  }
}
