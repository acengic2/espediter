import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
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
  DocumentSnapshot snapi;
  String st = '';
  bool onlyOnce = true;
  DateTime currentBackPressTime;

  _ListOfRoutesState({this.userID});

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _onRefresh();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[
                        ListOfRoutesRef(userID: userID),
                        Divider1(thickness: 8, height: 8),
                        ListOfFinishedRoutes(userID: userID),
                        Container(
                          width: 0,
                          height: 0,
                          child: FutureBuilder(
                            future: getPosts(userID),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      setState(() {
                                        snapi = snapshot.data[index];
                                      });

                                      return Container(
                                        width: 0,
                                        height: 0,
                                      );
                                    });
                              }
                              return Container(
                                width: 0,
                                height: 0,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar1(userID: userID),
          floatingActionButton: FloatingActionButton1(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ));
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    //print(snapi.data);
    CompanyRoutes().deleteRouteOnDateMatch(snapi, userID, context);
    if (onlyOnce) {
      CompanyRoutes().insertIntoFinishOnDateMatch(
          snapi,
          int.parse(snapi.data['availability']),
          snapi.data['capacity'],
          snapi.data['ending_destination'],
          snapi.data['starting_destination'],
          snapi.data['departure_date'],
          snapi.data['arrival_date'],
          snapi.data['departure_time'],
          snapi.data['departure_time'],
          snapi.data['dimensions'],
          snapi.data['goods'],
          snapi.data['vehicle'],
          userID,
          int.parse(snapi.data['timestamp']));
          onlyOnce = false;
    }
     onlyOnce = true;

    setState(() {
      st = 'rendered';
     
    });
    // if failed,use refreshFailed()
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
