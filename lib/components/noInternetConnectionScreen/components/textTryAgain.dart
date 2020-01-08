import 'package:flutter/material.dart';
import 'package:spediter/theme/style.dart';

class TryAgain extends StatelessWidget {
  final String tryAgainStingFirstMessage = "Nemate mreže";
  final String tryAgainStingSecondMessage =
      "Nažalost nemate mreže. Riješite problem pa pokušajte ponovno.";
  final String buttonText = "POKUSAJTE PONOVO";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                tryAgainStingFirstMessage,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Roboto",
                    color: StyleColors().textColorGray80),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  tryAgainStingSecondMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: StyleColors().textColorGray60),
                ),
              ),
              ButtonTheme(
                minWidth: 154.0,
                height: 36.0,
                child: RaisedButton(
                  onPressed: () {},
                  color: StyleColors().blueColor,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
