import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/bottomAppBar.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/floatingActionButton.dart';
import 'package:spediter/theme/style.dart';
import '../createRoute/createRouteScreen.dart';

void main() => runApp(NoRoutes());

const noRoutesString =
    "Trenutno nemate nikakvih ruta. Molimo vas da kreirate rutu.";

class NoRoutes extends StatefulWidget {
  final String userID;

  //konstruktor koji prima info i signIn screen-a i smjesta ih u varijable instancirane iznad
  NoRoutes({Key key, this.userID}) : super(key: key);

  @override
  _NoRoutesScreenPageState createState() =>
      _NoRoutesScreenPageState(userID: userID);
}

class _NoRoutesScreenPageState extends State<NoRoutes> {
  final String userID;
  DateTime currentBackPressTime;

  _NoRoutesScreenPageState({this.userID});

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Company')
        .where('company_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Nemate ruta',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Roboto",
                          color: StyleColors().textColorGray80),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: Container(
                          width: 328,
                          child: Text(
                            noRoutesString,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: StyleColors().textColorGray60),
                          ),
                        )),
                    ButtonTheme(
                      minWidth: 154.0,
                      height: 36.0,
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateRoute()),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          "KREIRAJ RUTU",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: Colors.white),
                        ),
                        color: StyleColors().blueColor,
                      ),
                    )
                  ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar1(userID: userID),
        floatingActionButton: FloatingActionButton1(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }
}
