import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart';
import 'package:spediter/components/routingAndChecking.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';
import 'package:spediter/theme/style.dart';

void main() => runApp(Info());

// instanca na NoRoutes screen
NoRoutes noRoutes = new NoRoutes();

class Info extends StatelessWidget {
  final String userID;
  Info({this.userID});

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
      home: InfoPage(userID: userID),
    );
  }
}

class InfoPage extends StatefulWidget {
  final String userID;
  InfoPage({this.userID});

  @override
  _InfoPageState createState() => _InfoPageState(userID: userID);
}

class _InfoPageState extends State<InfoPage> {
  final String userID;

  _InfoPageState({this.userID});

  /// instanca za bazu
  final db = Firestore.instance;

  int onceToast = 0, onceBtnPressed = 0;

  String userUid;

  String id;
  String rola;

  bool imaliRuta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.clear),
            onPressed: () {
              /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
              if (rola == 'user') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UsersHome(
                          userID: userID,
                        )));
              } else {
                RouteAndCheck().checkAndNavigate(context, userID);
              }
            },
          ),
          title: const Text('Info',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
        ),
        body:

            /// GestureDetector na osnovu kojeg zavaramo tastaturu na klik izvan njenog prostora
            Builder(
                builder: (context) => new GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        onceToast = 0;
                      },
                      child: ListView(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 22),
                              //height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Šta je e-Špediter?',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray80,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: getPosts(userID),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              rola = snapshot
                                                  .data[index].data['role'];
                                              
                                              return SizedBox();
                                            });
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                  Container(
                                    //height: 104,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'E-Špediter je savremeni softver za Android i iOS uređaje, koji smanjuje troškove i olakšava bolju koordinaciju pri otpremanju robe iz vlastite države u inozemstvo i obrnuto.' +
                                          ' Glavna namjena i zamisao jeste da se olakša komunikacija i pristup informacijama između Špeditera i potencijalnog naručioca prevoza robe, te osloboditi Vas cjelokupnog napora i brige oko otpreme, dopreme i prevoza robe u međunarodnom prometu.' + 
                                          ' Ključna namjena je i da se olakša pregled slobodnih špeditera koji se prometuju na trasi koja je predmet interesovanja potencijalnog naručioca prevoza robe.',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray60,
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 14),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: StyleColors().textColorGray12,
                                        width: 1))),
                          ),
                          Container(
                              //height: 106,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Kako koristiti e-Špediter?',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray80,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    //height: 60,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'E-Špediter korisnik postajete uz jednostavnu registraciju putem kontaktiranja naših administratora.' + 
                                      ' Omogućavamo Vam postavljanje i praćenje svih ruta sa teritorije BiH jednim klikom.' + 
                                      ' Uz navedeno imate mogućnost jednostavnog pregleda svojih prethodnih aktivnosti, spašavanje informacija o profilu i kompaniji, a kao dodatak u narednom periodu je planirano još mnogo inovacija.' +
                                      ' Digitalne tehnologije su odličan način da se premosti jaz između izazova koje donosi nedostatak vremena i realne potrebe ljudi.',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray60,
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 14),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: StyleColors().textColorGray12,
                                        width: 1))),
                          ),
                          Container(
                              //height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Program unapređenja i lojalnosti?',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray80,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    //height: 104,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'Prateći svjetske trendove i lidere, sastavni dio e-Špediter politike će biti i ažuriranje aplikacije na dvosedmičnom nivou. ' +
                                          'Svi korisnici aplikacije koji budu aktivno uključeni u traženju i prijavljivanju aplikativnih neispravnosti će sa zadovoljstvom biti nagrađeni. ' +
                                          'Sve prijave ove prirode korisnici mogu prijaviti na e.spediterdemo@gmail.com.',
                                      style: TextStyle(
                                          color: StyleColors().textColorGray60,
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 56),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: StyleColors().textColorGray12,
                                        width: 1))),
                          ),
                        ],
                      ),
                    )));
  }
}

Future getPosts(String id) async {
  var firestore = Firestore.instance;
  QuerySnapshot qn = await firestore
      .collection('LoggedUsers')
      .where('user_id', isEqualTo: id)
      .getDocuments();
  return qn.documents;
}
