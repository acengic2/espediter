import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/theme/style.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ContactPart());
}

class ContactPart extends StatefulWidget {
  DocumentSnapshot post;
  String userID, companyID;

  ContactPart({this.post, this.userID, this.companyID});

  @override
  _ContactPartState createState() =>
      _ContactPartState(post: post, userID: userID, companyID: companyID);
}

class _ContactPartState extends State<ContactPart> {
  DocumentSnapshot post;
  String userID, companyID;
  String companyName;
  String companyDescription;
  String companyPhone;
  String companyEmail;
  String companyWeb;
  String companyURL;

  @override
  void initState() {
    super.initState();
  }

  _ContactPartState({this.post, this.userID, this.companyID});

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return FutureBuilder(
      future: getCompanyInfo(companyID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                companyName = snapshot.data[index].data['company_name'];
                companyDescription =
                    snapshot.data[index].data['company_description'];
                companyPhone = snapshot.data[index].data['phone'];
                companyEmail = snapshot.data[index].data['email'];
                companyWeb = snapshot.data[index].data['webpage'];
                companyURL = snapshot.data[index].data['url_logo'];
                return Container(
                  margin: EdgeInsets.only(
                      top: 14.0, bottom: 16.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: 40,
                              height: 40,
                              decoration: new BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage('$companyURL'),
                                ),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil.instance.setSp(280.0),
                                margin: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  ('$companyName'),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                              Container(
                                width: ScreenUtil.instance.setSp(280.0),
                                margin: EdgeInsets.only(left: 8.0, top: 6.0),
                                child: Text(
                                  ('$companyDescription'),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),

                      //phone
                      Container(
                      width: ScreenUtil.instance.setSp( 360.0),
                        height: 172,
                        margin: EdgeInsets.only(top: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,
                                color: StyleColors().textColorGray12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _launchCall('$companyPhone');
                              },
                              child: Container(
                                  width: ScreenUtil.instance.setSp( 400.0),
                                  height: 56,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.phone,
                                          color: StyleColors().textColorGray60,
                                          size: 24.0,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              ('$companyPhone'),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ),
                                          Container(
                                                                              width: ScreenUtil.instance.setSp( 200.0),

                                            margin: EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              ('Telefon'),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              alignment: Alignment(-1.0, 0.0),
                              width: 344,
                              child: Divider1(thickness: 1, height: 1),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchMail('$companyEmail');
                              },
                              child: Container(
                                  width: 400,
                                  height: 56,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.mail,
                                          color: StyleColors().textColorGray60,
                                          size: 24.0,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              ('$companyEmail'),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ),
                                          Container(
                                             width: ScreenUtil.instance.setSp( 200.0),
                                            margin: EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              ('Mail'),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              width: 344,
                              child: Divider1(thickness: 1, height: 1),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURL('$companyWeb');
                              },
                              child: Container(
                                   width: ScreenUtil.instance.setSp(400.0),
                                  height: 56,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.web,
                                          color: StyleColors().textColorGray60,
                                          size: 24.0,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              ('$companyWeb'),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ),
                                          Container(
                                             width: ScreenUtil.instance.setSp( 200.0),
                                            margin: EdgeInsets.only(
                                                top: 2.0, bottom: 7.0),
                                            child: Text(
                                              ('Website'),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future getCompanyInfo(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Company')
        .where('company_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchMail(String mail) async {
  await launch("mailto:$mail");
}

_launchCall(String phone) async {
  await launch("tel:$phone");
}
