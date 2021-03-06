import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/screens/companyScreens/editCompany/editRoutes.dart';
import 'package:spediter/theme/style.dart';

void main() => runApp(ListOfRoutesRef());

String capacityString;

/// desni,lijevi,srednji kontejner za prikaz informacija o aktivnim rutama
final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();


class ListOfRoutesRef extends StatefulWidget {
  final String userID;
  ListOfRoutesRef({this.userID});
  @override
  _ListOfRoutesRefState createState() => _ListOfRoutesRefState(userID: userID);
}

class _ListOfRoutesRefState extends State<ListOfRoutesRef> {
  String userID;
  _ListOfRoutesRefState({this.userID});

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
      Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 0.0, left: 20),
      ),
      Container(
        child: FutureBuilder(
          future: getPosts(userID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    int time = int.parse(
                        snapshot.data[index].data['arrival_timestamp']);

                    /// DATUM
                    if (time > DateTime.now().millisecondsSinceEpoch) {
                      String date = snapshot.data[index].data['departure_date'];
                      String dateReversed = date.split('/').reversed.join();
                      String departureDate = DateFormat("d MMM")
                          .format(DateTime.parse(dateReversed));
                      // KAPACITET
                      capacityString = snapshot.data[index].data['capacity'];
                      final leftSection = new Container(
                          height: 32,
                          width: 62,
                          margin: EdgeInsets.only(top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: StyleColors().blueColor,
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
                                      text: departureDate,
                                      style: new TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(13.0),
                                        color: Colors.white,
                                        fontFamily: "Roboto",
                                      )),
                                ],
                              ),
                            ),
                          )));

                      ///middle section u koji spremamo kapacitet
                      final middleSection = new Container(
                          height: 32,
                          width: 110,
                          margin: EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
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
                          ));

                      /// DOSTUPNOST
                      String availability =
                          snapshot.data[index].data['availability'];

                      final rightSection = new Stack(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.instance.setWidth(142.0),
                            height: 32,
                            margin: EdgeInsets.only(
                                top: 8, bottom: 16, left: 0.0, right: 1.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: Colors.black.withOpacity(0.12)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0))),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 9),
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.only(left: 1),
                                width: ScreenUtil.instance.setWidth(141.0),
                                lineHeight: 30.0,
                                percent: (double.parse(availability)) / 100,
                                center: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Popunjenost: ',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.black
                                                  .withOpacity(0.6))),
                                      TextSpan(
                                        text: availability + ' %',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize:
                                                ScreenUtil.instance.setSp(12.0),
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                                linearStrokeCap: LinearStrokeCap.butt,
                                backgroundColor: Colors.white,
                                progressColor: Color.fromRGBO(3, 54, 255, 0.12),
                              ))
                        ],
                      );

                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditRoute(
                                        post: snapshot.data[index],
                                        userID: userID))),
                            child: Container(
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
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Roboto",
                                              )),
                                          new TextSpan(
                                              style: new TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontFamily: "Roboto",
                                          )),
                                          new TextSpan(
                                              text:
                                                  '${snapshot.data[index].data['interdestination']}',
                                              style: new TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black
                                                    .withOpacity(0.6),
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
                                        rightSection
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider1(height: 1, thickness: 1)
                        ],
                      );
                    } else {
                      return Container(
                        width: 0,
                        height: 0,
                      );
                    }
                  });
            } else {
              return SizedBox(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    ]);
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
