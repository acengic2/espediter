import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/components/loadingComponent.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';

void main() => runApp(ShowLoadingRoutes());

class ShowLoadingRoutes extends StatefulWidget {
  final String userID;
  final String id;

//constructor sending parameters email and user
  ShowLoadingRoutes({Key key, this.userID, this.id}) : super(key: key);

  @override
  _ShowLoadingRoutes createState() =>
      _ShowLoadingRoutes(userID: userID, id: id);
}

class _ShowLoadingRoutes extends State<ShowLoadingRoutes> {
  String userID;
  String id;

  String firstMessage = "Ruta se kreira";
  String secondMessage = "Molim vas sačekajte trenutak.";
  _ShowLoadingRoutes({this.userID, this.id});

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoadingComponent(firstMessage, secondMessage));
  }

  // loading screen for 2 seconds
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

//when loading screen is done redicret to home page
// parameters user and email
  onDoneLoading() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID)));
  }
}
