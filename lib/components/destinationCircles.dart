import 'package:flutter/material.dart';

class DestinationCircle extends StatelessWidget {
  final Color largeCircle, smallCircle;
  DestinationCircle({this.largeCircle, this.smallCircle});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.only(right: 8, left: 16)),
          Container(
            height: 16,
            width: 16,
            child: Icon(
              Icons.brightness_1,
              color: smallCircle,
              size: 10.0,
            ),
          ),
          Container(
            child: Icon(
              Icons.brightness_1,
              color: largeCircle,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }
}
