import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/screens/singIn/components/form.dart';
import 'package:spediter/screens/userScreens/components/contactPart.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';
import 'package:spediter/theme/style.dart';

void main() => runApp(RouteOnClick());

// class RouteOn extends StatelessWidget {
//   final String userID;
//   final DocumentSnapshot post;
//   RouteOn({this.post, this.userID});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Kreiraj Rutu',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       localizationsDelegates: [
//         // ... lokalizacija jezika
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('bs', null), // Bosnian
//         const Locale('en'), // English
//       ],
//       home: RouteOnClick(post: post, userID: userID),
//     );
//   }
// }

class RouteOnClick extends StatefulWidget {
final   DocumentSnapshot post;
 final  String userID;

  RouteOnClick({this.post, this.userID});

  @override
  _RouteOnClickState createState() => _RouteOnClickState();
}

class _RouteOnClickState extends State<RouteOnClick> {
  @override
  Widget build(BuildContext context) {
    final format = DateFormat.MMMMd('bs');
    final dayFormat = DateFormat.EEEE('bs');

    String companyName = widget.post.data['company_name'];
    String destinacijaPolaska = widget.post.data['starting_destination'];
    String companyID = widget.post.data['user_id'];

    /// Datum polaska
    String datumPolaska = widget.post.data['departure_date'];
    String dateReversed = datumPolaska.split('/').reversed.join();
    String departureDate = format.format(DateTime.parse(dateReversed));

    /// izvacenje dana u sedmici iz datuma
    DateTime danDatuma = DateTime.parse(datumPolaska);
    String danPolaska = dayFormat.format(danDatuma);

    String vrijemePolaska = widget.post.data['departure_time'];
    String interdestinacije = widget.post.data['interdestination'];
    String destinacijaDolaska = widget.post.data['ending_destination'];

    /// Datum dolaska
    String datumDolaska = widget.post.data['arrival_date'];
    String dateReversed1 = datumDolaska.split('/').reversed.join();
    String departureDate1 = format.format(DateTime.parse(dateReversed1));

    /// IZVLACENJE dana u sedmici iz datuma
    DateTime danDatuma1 = DateTime.parse(datumDolaska);
    String danDolaska = dayFormat.format(danDatuma1);
    String vrijemeDolaska = widget.post.data['departure_time'];
    String kapacitet = widget.post.data['capacity'];
    String dostupnost = widget.post.data['availability'];
    String vozilo = widget.post.data['vehicle'];
    String roba = widget.post.data['goods'];
    String dimenzije = widget.post.data['dimensions'];

    Widget _buildListInter() {
      if (interdestinacije != '') {
        interdestinacije =
            interdestinacije.substring(0, interdestinacije.length - 2);
        List<String> listaInter = interdestinacije.split(', ');

        return new Column(
            children: listaInter
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: StyleColors().borderGray),
                      ),
                      color: StyleColors().textColorGray12,
                    ),
                    height: 43,
                    width: 380,
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 11, bottom: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new RichText(
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                    text: 'Prolazi kroz $item',
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList());
      } else {
        return Container(
          height: 0,
          width: 0,
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UsersHome(
                      userID: widget.userID,
                    )));

            /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
            // RouteAndCheck().checkAndNavigate(context, userID);
          },
        ),
        title: Text(companyName,
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            height: 90,
            width: 380,
            color: StyleColors().blueColor,
            margin: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Container(
              margin: EdgeInsets.only(left: 8, top: 14, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Polazak vozila iz ',
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontFamily: "Roboto",
                              )),
                          new TextSpan(
                            text: (destinacijaPolaska),
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text(
                      /// dan polaska + datum polaska
                      danPolaska + ', ' + departureDate,
                      style: TextStyle(
                          locale: Locale('bs'),
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    vrijemePolaska,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          _buildListInter(),
          Container(
            height: 90,
            width: 380,
            color: StyleColors().destinationCircle1,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Container(
              margin: EdgeInsets.only(left: 8, top: 5, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 6),
                    child: RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Zadnja destinacija vozila u ',
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontFamily: "Roboto",
                              )),
                          new TextSpan(
                            text: (destinacijaDolaska),
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text(
                      danDolaska + ", " + departureDate1,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    vrijemeDolaska,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 19,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                  height: 32,
                  width: 110,
                  margin: EdgeInsets.only(
                      left: 16.0, right: 4.0, bottom: 8.0, top: 9),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    border: new Border.all(
                      color: Colors.black.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                                text: 'Kapacitet: ',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black.withOpacity(0.6),
                                  fontFamily: "Roboto",
                                )),
                            new TextSpan(
                              text: (kapacitet + ' t'),
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black.withOpacity(1.0),
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.instance.setWidth(142.0),
                      height: 32,
                      margin: EdgeInsets.only(
                          top: 16.0, bottom: 15, left: 0.0, right: 1.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.12)),
                          borderRadius: BorderRadius.all(Radius.circular(1.0))),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 17.0,
                      ),
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.only(left: 1),
                        width: ScreenUtil.instance.setWidth(141.0),
                        lineHeight: 30.0,
                        percent: (double.parse(dostupnost)) / 100,
                        center: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Popunjenost: ',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black.withOpacity(0.6))),
                              TextSpan(
                                text: dostupnost + ' %',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: ScreenUtil.instance.setSp(12.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                        linearStrokeCap: LinearStrokeCap.butt,
                        backgroundColor: Colors.white,
                        progressColor: Color.fromRGBO(3, 54, 255, 0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: StyleColors().textColorGray12),
            ),
            height: 56,
            width: 380,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 7, bottom: 2),
                    child: Text('Vrsta vozila: ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: StyleColors().textColorGray60,
                          fontFamily: "Roboto",
                        )),
                  ),
                  Text(
                    vozilo,
                    style: TextStyle(
                      color: StyleColors().textColorGray80,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: StyleColors().textColorGray12),
            ),
            height: 56,
            width: 380,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 7, bottom: 2),
                    child: Text('Vrsta robe koja se prevozi ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: StyleColors().textColorGray60,
                          fontFamily: "Roboto",
                        )),
                  ),
                  Text(
                    roba,
                    style: TextStyle(
                      color: StyleColors().textColorGray80,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: StyleColors().textColorGray12),
            ),
            height: 56,
            width: 380,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 14),
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 7, bottom: 2),
                    child: Text('Dimenzije prtljažnog prostora vozila ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: StyleColors().textColorGray60,
                          fontFamily: "Roboto",
                        )),
                  ),
                  Text(
                    dimenzije,
                    style: TextStyle(
                      color: StyleColors().textColorGray80,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider1(height: 1, thickness: 1),
          Divider1(height: 8, thickness: 8),
          ContactPart(post: post, userID: userID, companyID: companyID)
        ],
      ),
    );
  }
}
