
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/screens/singIn/components/form.dart';
import 'package:spediter/theme/style.dart';
String capacityString;

/// varijable
///
/// varijable u kojoj smo spremili boje
/// plava
/// crna sa 80% opacity
/// crna sa 60^ opacity

/// desni,lijevi,srednji kontejner za prikaz informacija o aktivnim rutama
final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

class ListOfFinishedRoutes extends StatefulWidget {
  final String userID;
  ListOfFinishedRoutes({this.userID});


  @override
  _ListOfFinishedRoutesState createState() =>
      _ListOfFinishedRoutesState(userID: userID);
}

class _ListOfFinishedRoutesState extends State<ListOfFinishedRoutes> {
  String userID;
  _ListOfFinishedRoutesState({this.userID});


  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('FinishedRoutes')
        .where('user_id', isEqualTo: id)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    print(userID);
    print(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Column(children: <Widget>[
      Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
          future: getPosts(userID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      /// DATUM

                      String date = snapshot.data[index].data['arrival_date'];
                      String dateReversed = date.split('/').reversed.join();
                      String arrivalDate = DateFormat("d MMM")
                          .format(DateTime.parse(dateReversed));

                      final leftSection = new Container(
                          height: 32,
                          width: 110,
                          margin: EdgeInsets.only(top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: StyleColors().grayColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: new RichText(
                              text: new TextSpan(
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: 'Završena ruta',
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                      )),
                                ],
                              ),
                            ),
                          ))); //left section container

                      ///middle section u koji spremamo kapacitet

                      final middleSection = new Container(
                          height: 32,
                          width: 62,
                          margin: EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: StyleColors().grayColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
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
                                      text: arrivalDate,
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black.withOpacity(1.0),
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )); //Middle section Container

                      return Column(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, bottom: 4, left: 17, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text:
                                                '${snapshot.data[index].data['starting_destination']}, ',
                                            style: new TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Roboto",
                                            )),
                                        new TextSpan(
                                            style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black.withOpacity(0.6),
                                          fontFamily: "Roboto",
                                        )),
                                        new TextSpan(
                                          text:
                                              ('${snapshot.data[index].data['ending_destination']}'),
                                          style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                 
                                    children: <Widget>[
                                      leftSection,
                                      middleSection,
                                    ],
                                  
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider1(height: 1, thickness: 1)
                        ],
                      );
                    },
                  ));
            } else {
              return SizedBox(
              );
            }
          },
        ),
      ),
    ]);
  }
}
