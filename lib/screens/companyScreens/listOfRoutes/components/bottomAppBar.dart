import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/companyInfo/companyInfo.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/info.dart';
import 'package:verbal_expressions/verbal_expressions.dart';

class BottomAppBar1 extends StatelessWidget {
  final String userID;
  BottomAppBar1({this.userID});

  NetworkImage image;
  String logoURL;
  String avatarURL =
      'https://f0.pngfuel.com/png/178/595/black-profile-icon-illustration-user-profile-computer-icons-login-user-avatars-png-clip-art-thumbnail.png';

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Company')
        .where('company_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosts(userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  String url = snapshot.data[index].data['url_logo'];
                  if (checkUrl(url)) {
                    logoURL = url;
                  } else {
                    logoURL = avatarURL;
                  }
                  image = NetworkImage(logoURL);
                  return BottomAppBar(
                    child: Container(
                      height: 56.0,
                      width: 360.0,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyInfo(userID: userID)));
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                margin: EdgeInsets.only(left: 16.0),
                                decoration: new BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: image,
                                  ),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.0, bottom: 0),
                            child: IconButton(
                              iconSize: 35,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Info(userID: userID)),
                                );
                              },
                              icon: Icon(
                                Icons.info_outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return SizedBox();
          }
        });
  }

  bool checkUrl(String url) {
    var regex = VerbalExpression()
      ..startOfLine()
      ..then("http")
      ..maybe("s")
      ..then("://")
      ..maybe("www.")
      ..anythingBut(" ")
      ..then(".png")
      ..or(".jpg")
      ..endOfLine();
    var regex2 = VerbalExpression()
      ..startOfLine()
      ..then("http")
      ..maybe("s")
      ..then("://")
      ..maybe("www.")
      ..anythingBut(" ")
      ..then(".jpeg")
      ..or(".svg")
      ..endOfLine();

    return (regex.hasMatch(url) || regex2.hasMatch(url));
  }
}
