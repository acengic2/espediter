import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/bottomAppBar.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/floatingActionButton.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listOfFinishedRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listOfRoutesref.dart';

class ListOfRoutes extends StatefulWidget {
  final String userID;
  ListOfRoutes({Key key, this.userID}) : super(key: key);

  @override
  _ListOfRoutesState createState() => _ListOfRoutesState(userID: userID);
}

class _ListOfRoutesState extends State<ListOfRoutes> {
  String userID;
  String userIDF;

  _ListOfRoutesState({this.userID});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      ListOfRoutesRef(userID: userID),
                      Divider1(),
                      ListOfFinishedRoutes(userID: userID),
                    ],
                  )
                ]),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar1(userID: userID),
          floatingActionButton: FloatingActionButton1(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ));
  }
}
