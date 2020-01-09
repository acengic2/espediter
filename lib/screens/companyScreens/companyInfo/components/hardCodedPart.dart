import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/divider.dart';

import '../../../singIn/signIn.dart';

class HardCodedPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      await FirebaseAuth.instance.signOut();
      Future<FirebaseUser> Function() user = FirebaseAuth.instance.currentUser;
      print(user);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Kontakt mail",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text("support@esped.com"),
              Container(
                margin: EdgeInsets.only(top: 9, bottom: 8),
                child: Divider1(
                height: 1,
                thickness: 1,
              ),
              ),
              Text(
                "Kontakt telefon",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text("062 667-266"),
              Container(
                margin: EdgeInsets.only(top: 9, bottom: 8),
                child: Divider1(
                height: 1,
                thickness: 1,
              ),
              ),
              GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 6),
                  child: Text(
                    "Odjava",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
