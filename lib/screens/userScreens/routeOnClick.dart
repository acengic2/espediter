import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';

void main() => runApp(RouteOnClick());

class RouteOnClick extends StatelessWidget {
  DocumentSnapshot post;
  String userID;

  RouteOnClick({this.post, this.userID});

  @override
  Widget build(BuildContext context) {
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
                      userID: userID,
                    )));

            /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
            // RouteAndCheck().checkAndNavigate(context, userID);
          },
        ),
        title: const Text('Truck Logistic',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 90,
            width: 380,
            color: Colors.blue,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Polazak iz Sarajeva',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Ponedjeljak, 24. Februar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '14:00',
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
          Container(
            height: 42,
            width: 380,
            color: Colors.grey,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text('Zvornik')],
              ),
            ),
          ),
          Container(
            height: 43,
            width: 380,
            color: Colors.grey,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text('Loznica')],
              ),
            ),
          ),
          Container(
            height: 43,
            width: 380,
            color: Colors.grey,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text('Šabac')],
              ),
            ),
          ),
          Container(
            height: 90,
            width: 380,
            color: Colors.red,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Zadnja destinacija Beograd',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Utorak, 25. Februar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '16:00',
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
                      left: 16.0, right: 4.0, top:16.0, bottom: 8.0),
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
                              text: ('$capacityString t'),
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
                        top: 24.0,  bottom: 16, left: 0.0, right: 1.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.12)),
                          borderRadius: BorderRadius.all(Radius.circular(1.0))),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 25.0,),
                        child: LinearPercentIndicator(
                          padding: EdgeInsets.only(left: 1),
                          width: ScreenUtil.instance.setWidth(141.0),
                          lineHeight: 30.0,
                          percent: (double.parse('99')) / 100,
                          center: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Popunjenost: ',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        // fontSize: ScreenUtil.instance
                                        //     .setSp(12.0),
                                        color: Colors.black.withOpacity(0.6))),
                                TextSpan(
                                  text: '99' + ' %',
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
        ],
      ),
    );
  }
}
