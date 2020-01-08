import 'package:flutter/material.dart';
import 'package:spediter/theme/style.dart';
/// Loading component class 
/// 
/// Two components with messages: different style text and messages
/// 
/// Authors: Sena Cikic, Danis Preldzic, Adi Cengic, Jusuf Elfarahati
/// Tech387 - T2
/// Jan, 2020
/// 
/// 
class LoadingComponent extends StatelessWidget {
  final String loadingStingFirstMessage;
  final String loadingStingSecondMessage;

  LoadingComponent(
      this.loadingStingFirstMessage, this.loadingStingSecondMessage);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 22),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                StyleColors().progressBar,
          ),
        ),),
        Container(
          margin: EdgeInsets.only(bottom: 16.0),
          child: Text(
            loadingStingFirstMessage,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          child: Text(
            loadingStingSecondMessage,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }
}
