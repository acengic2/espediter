import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/components/noInternetConnectionScreen/noInternetOnLogin.dart';
import 'package:spediter/screens/userScreens/components/bottomAppBarUser.dart';
import 'package:spediter/screens/userScreens/routeOnClick.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
<<<<<<< HEAD

=======
>>>>>>> origin/master

void main() => runApp(UsersHome());

String capacityString;
String companyName;
NetworkImage image;
DocumentSnapshot post;
String avatarURL =
    'https://f0.pngfuel.com/png/178/595/black-profile-icon-illustration-user-profile-computer-icons-login-user-avatars-png-clip-art-thumbnail.png';
String companyID;

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

/// desni,lijevi,srednji kontejner za prikaz informacija o aktivnim rutama
final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

class UsersHome extends StatefulWidget {
  final String userID;

  UsersHome({Key key, this.userID}) : super(key: key);

  @override
  _UsersHomeState createState() => _UsersHomeState(userID: userID);
}

class _UsersHomeState extends State<UsersHome> {
  final String userID;
   var st;
  DateTime currentBackPressTime;

  _UsersHomeState({this.userID});

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _onRefresh();
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SmartRefresher(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 0.0, left: 20),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: getPosts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                int time = int.parse(snapshot
                                    .data[index].data['arrival_timestamp']);

                                if (time >
                                    DateTime.now().millisecondsSinceEpoch) {
                                  post = snapshot.data[index];
                                  var logoAndName;
                                  getPosts().then((data) {
                                    logoAndName = Firestore.instance
                                        .collection('Company')
                                        .document(data['companyID'])
                                        .snapshots();
                                    if (logoAndName != null) {
                                      logoAndName.forEach((item) {
                                        image = NetworkImage(avatarURL);
                                        companyName = item.data['company_name'];
                                      });
                                    }
                                  });

                                  /// DATUM
                                  String date = snapshot
                                      .data[index].data['departure_date'];
                                  String dateReversed =
                                      date.split('/').reversed.join();
                                  String departureDate = DateFormat("d MMM")
                                      .format(DateTime.parse(dateReversed));
                                  // KAPACITET
                                  capacityString =
                                      snapshot.data[index].data['capacity'];
                                  companyID =
                                      snapshot.data[index].data['user_id'];
                                  final leftSection = new Container(
                                      height: 32,
                                      width: 62,
                                      margin:
                                          EdgeInsets.only(top: 8, bottom: 16),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: blueColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1.0)),
                                      ),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: new RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: departureDate,
                                                  style: new TextStyle(
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setSp(13.0),
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
                                          left: 4.0,
                                          right: 4.0,
                                          top: 8,
                                          bottom: 16),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1.0)),
                                        border: new Border.all(
                                          color: Colors.black.withOpacity(0.12),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new RichText(
                                            text: new TextSpan(
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text: 'Kapacitet: ',
                                                    style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontFamily: "Roboto",
                                                    )),
                                                new TextSpan(
                                                  text: ('$capacityString t'),
                                                  style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    color: Colors.black
                                                        .withOpacity(1.0),
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
                                        width:
                                            ScreenUtil.instance.setWidth(142.0),
                                        height: 32,
                                        margin: EdgeInsets.only(
                                            top: 8,
                                            bottom: 16,
                                            left: 0.0,
                                            right: 1.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black
                                                    .withOpacity(0.12)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0))),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 9),
                                          child: LinearPercentIndicator(
                                            padding: EdgeInsets.only(left: 1),
                                            width: ScreenUtil.instance
                                                .setWidth(141.0),
                                            lineHeight: 30.0,
                                            percent:
                                                (double.parse(availability)) /
                                                    100,
                                            center: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Popunjenost: ',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6))),
                                                  TextSpan(
                                                    text: availability + ' %',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: ScreenUtil
                                                            .instance
                                                            .setSp(12.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.butt,
                                            backgroundColor: Colors.white,
                                            progressColor: Color.fromRGBO(
                                                3, 54, 255, 0.12),
                                          ))
                                    ],
                                  );

                                  return Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          try {
                                            final result =
                                                await InternetAddress.lookup(
                                                    'google.com');

                                            if (result.isNotEmpty &&
                                                result[0]
                                                    .rawAddress
                                                    .isNotEmpty) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RouteOn(
                                                              post: snapshot
                                                                  .data[index],
                                                              userID: userID)));
                                            }
                                          } on SocketException catch (_) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoInternetConnectionLogInSrceen()));
                                          }
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16,
                                                bottom: 4,
                                                left: 17,
                                                right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: 30,
                                                        height: 30,
                                                        margin: EdgeInsets.only(
                                                            left: 0.0,
                                                            bottom: 6.0,
                                                            right: 12.0),
                                                        decoration:
                                                            new BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.black),
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                '${snapshot.data[index].data['url_logo']}'),
                                                          ),
                                                        )),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 6.0),
                                                      child: Text(
                                                        ('${snapshot.data[index].data['company_name']}'),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Roboto",
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                new RichText(
                                                  text: new TextSpan(
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                              '${snapshot.data[index].data['starting_destination']}, ',
                                                          style: new TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Roboto",
                                                          )),
                                                      new TextSpan(
                                                          style: new TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontFamily: "Roboto",
                                                      )),
                                                      new TextSpan(
                                                          text:
                                                              ('${snapshot.data[index].data['interdestination']}'),
                                                          style: new TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                            fontFamily:
                                                                "Roboto",
                                                          )),
                                                      new TextSpan(
                                                        text:
                                                            ('${snapshot.data[index].data['ending_destination']}'),
                                                        style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                          color: Colors.black
                                                              .withOpacity(0.8),
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
                ],
              ),
            ],
          ),
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
        ),
        bottomNavigationBar: BottomAppBarUser(userID: userID),
      ),
    );

    
  }
  
 void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      st = UniqueKey();
    });
    _refreshController.refreshCompleted();
  }

  Future<bool> _onWillPop() async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Da li ste sigurni?'),
            content: new Text('Da li želite napustiti aplikaciju?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Ne'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Da'),
              ),
            ],
          ),
        ) ??
        true;
  }

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Rute')
        .orderBy('departure_timestamp', descending: true)
        .getDocuments();
    return qn.documents;
  }
}
