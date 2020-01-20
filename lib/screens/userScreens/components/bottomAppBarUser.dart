import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomAppBarUser extends StatelessWidget {
  final String userID;
  BottomAppBarUser({this.userID});

  NetworkImage image;
  String logoURL;
  String avatarURL =
      'https://f0.pngfuel.com/png/178/595/black-profile-icon-illustration-user-profile-computer-icons-login-user-avatars-png-clip-art-thumbnail.png';

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('LoggedUsers')
        .where('user_id', isEqualTo: id)
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
                  image = NetworkImage(avatarURL);
                  return BottomAppBar(
                    child: Container(
                      height: 56.0,
                      width: 360.0,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
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
                              onPressed: () {},
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
}
