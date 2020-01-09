import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spediter/screens/companyScreens/createRoute/interdestinatonForm.dart';
import 'package:spediter/screens/companyScreens/editCompany/components/editRouteForm.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:flutter/rendering.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';

void main() => runApp(EditRoute());

bool imaliRuta = true;

// instanca na NoRoutes screen
NoRoutes noRoutes = new NoRoutes();

class EditRoute extends StatelessWidget {
  // This widget is the root of your application.
  final DocumentSnapshot post;
  final String userID;

  EditRoute({this.post, this.userID});

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
      home: EditRouteScreenPage(post: post, userID: userID),
    );
  }
}

class EditRouteScreenPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String userID;

  EditRouteScreenPage({this.post, this.userID});

  @override
  _EditRouteScreenPageState createState() =>
      _EditRouteScreenPageState(post: post, userID: userID);
}

class _EditRouteScreenPageState extends State<EditRouteScreenPage> {
  /// lista medjudestinacija
  List<InterdestinationForm> interdestinations = [];
  final DocumentSnapshot post;
  String userID;

  _EditRouteScreenPageState({this.post, this.userID});

  /// onDelete f-ja za interdestinacije
  @override
  Widget build(BuildContext context) {
    /// RESPONSIVE
    ///
    /// iz klase [ScreenUtils]
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
            CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
              if (docs.documents.isNotEmpty) {
                print('NOT EMPRY');
                imaliRuta = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListOfRoutes(
                            userID: userID,
                          )),
                );
              } else {
                imaliRuta = false;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NoRoutes()));
              }
            });
          },
        ),
        title: const Text('Aktivna Ruta',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body: EditRouteForm(post: post,),
    );
  }
}
