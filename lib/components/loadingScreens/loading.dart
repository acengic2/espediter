import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/components/loadingComponent.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'package:spediter/screens/userScreens/routeOnClick.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';

import '../routingAndChecking.dart';

void main() => runApp(ShowLoading());

String rola;

class ShowLoading extends StatefulWidget {
  /// Varijable
  ///
  /// email koji dobijamo iz signIn screena
  /// user i sve info o trenutno logovanom user-u
  final String email;
  final FirebaseUser user;
  final String userID;

  //konstruktor koji prima info i signIn screen-a i smjesta ih u varijable instancirane iznad
  ShowLoading({
    Key key,
    this.user,
    this.email,
    this.userID,
  }) : super(key: key);

  @override
  _ShowLoading createState() => _ShowLoading(
        user: user,
        email: email,
        userID: userID,
      );
}

class _ShowLoading extends State<ShowLoading> {
  /// Varijable
  ///
  /// id trenutno logovanog usera [usID]
  String usID;
  String text1 = "Registracija Korisnika";
  String text2 = "Molim vas sačekajte trenutak.";

  // bool _loadingInProgress;

  ///VARIJABLE
  ///
  /// [email ] - email trenutno logovanog usera
  /// [user] - objekat koji sadrzi sve info o trenutno logovanom useru
  /// [userID] - user token trenutno logovanog usera
  String email;
  final FirebaseUser user;
  String userID;

  _ShowLoading({
    this.user,
    this.email,
    this.userID,
  });

// init state f-ja koja se izvrsava prije nego se bilo sta ucita sa ovog screena
// u njoj se aktivira [loadData()] f-ja
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadingComponent(text1, text2),
          Container(
            width: 0,
            height: 0,
            child: FutureBuilder(
              future: getPostsLogged(userID),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        setState(() {
                          rola = snapshot.data[index].data['role'];
                          print(rola);
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
      ),
    );
  }

  /// metoda koja provjerava id trenutno logovanog usera
  ///
  /// kreiramo instancu na [FirebaseAuth _auth]
  /// zatim kreiramo [FirebaseUser user] iz instance [_auth]
  /// zatim pravimo konekciju na kolekciju [LoggedUsers], uzimamo [user.uid] i vracamo ga u vidu stringa
  /// zatim  ga spremamo u varijablu [usID] koju smo instancirali iznad
  checkForID() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection('LoggedUsers')
        .document(user.uid)
        .snapshots()
        .toString();
    usID = user.uid;
  }

  Future getPostsLogged(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('LoggedUsers')
        .where('user_id', isEqualTo: id)
        .limit(1)
        .getDocuments();

    return qn.documents;
  }

  /// metoda koja provjerava rolu, odnosno ulogu logovanog user-a
  ///
  /// da li je user - user  ili je user - kompanija ,
  /// na osnovu toga se izvrsava redirekcija
  ///  kreiramo konekciju na kolekciju [LoggedUsers] , zatim pisemo
  /// query gdje je role == 'company'
  /// limitiramo pretraguna 1 dokument
  checkForRole() {
    checkForID();
    return Firestore.instance
        .collection('LoggedUsers')
        .where('role', isEqualTo: 'company')
        .limit(1)
        .getDocuments();
  }

// Future f-ja koja se odvija na load ovog screena
//vraca Timer u trajanju od 2 sekunde, nakon cega se aktivira f-ja [onDoneLoading]
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  /// f-ja [onDoneLoading()] koja se aktivira nakon isteka Timera
  ///
  /// prilikom aktiviranja ove f-je provjeravamo Role (da li je company/user)
  /// nakon cega na osnovu te provjere redirektamo [na osnovu da li ja kompanija ima ruta ili ne ]
  /// na [NoRoutes] ili na [ListOfRoutes]
  onDoneLoading() async {
    checkForRole();
    checkForRoutes();
  }

  checkForRoutes() {
    if (rola == 'company') {
      /// metoda koja provjerava rute i navigira 
      RouteAndCheck().checkAndNavigate(context, userID);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => RouteOnClick()));
    }
  }
}
