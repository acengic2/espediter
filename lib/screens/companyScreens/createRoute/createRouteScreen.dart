import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spediter/screens/companyScreens/createRoute/components/createRouteForm.dart';
import 'package:spediter/screens/companyScreens/createRoute/form.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(CreateRoute());

/// crna sa 60^ opacity
const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

// instanca na NoRoutes screen
NoRoutes noRoutes = new NoRoutes();

class CreateRoute extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreiraj Rutu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        // ... lokalizacija jezika
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('bs'), // Bosnian
        const Locale('en'), // English
      ],
      home: CreateRouteScreenPage(),
    );
  }
}

class CreateRouteScreenPage extends StatefulWidget {
  CreateRouteScreenPage({Key key}) : super(key: key);

  @override
  _CreateRouteScreenPageState createState() => _CreateRouteScreenPageState();
}

class _CreateRouteScreenPageState extends State<CreateRouteScreenPage> {
  /// lista medjudestinacija
  List<InterdestinationForm> interdestinations = [];

  _CreateRouteScreenPageState();

  // /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  String userID;
  bool imaliRuta = true;

  @override
  Widget build(BuildContext context) {
    /// RESPONSIVE
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.clear),
            onPressed: () {
              /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
              CompanyRoutes()
                  .getCompanyRoutes(userID)
                  .then((QuerySnapshot docs) {
                if (docs.documents.isNotEmpty) {
                  imaliRuta = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListOfRoutes(userID: userID)),
                  );
                } else {
                  imaliRuta = false;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => NoRoutes()));
                }
              });
            },
          ),
          title: const Text('Kreiranje Rute',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
        ),
        body: CreateRouteForm());
  }
}
