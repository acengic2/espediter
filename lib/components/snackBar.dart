import 'package:flutter/material.dart';
import 'package:intl/intl_browser.dart';

class SnackBar1 extends StatelessWidget {
  final String message;
  SnackBar1({this.message});

  @override
  Widget build(BuildContext context) {

   final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content: Text(message),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        );
 Scaffold.of(context).showSnackBar(snackBar);
  
   return  snackBar;
   
    
  }
}
