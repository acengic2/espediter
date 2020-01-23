import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  var st;
  bool onlyOnce = true;
  bool doesDataExist = false;
  DateTime currentBackPressTime;

  _ListOfRoutesState({this.userID});

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _onRefresh();
    ListOfRoutesRef(userID: userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SmartRefresher(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[
                        ListOfRoutesRef(userID: userID),
                        Divider1(thickness: 8, height: 8),
                        ListOfFinishedRoutes(userID: userID),
                      ],
                    )
                  ]),
                ),
              ],
            ),
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
          ),
          bottomNavigationBar: BottomAppBar1(userID: userID),
          floatingActionButton: FloatingActionButton1(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ));
  }

  Future<bool> _onWillPop() async {
     return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Da li ste sigurni?'),
        content: new Text('Da li želite napustiti aplikaciju?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Ne'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Da'),
          ),
        ],
      ),
    ) ?? true;
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      st = UniqueKey();
    });
    _refreshController.refreshCompleted();
  }

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Rute')
        .where('user_id', isEqualTo: id)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qn.documents;
  }
}
