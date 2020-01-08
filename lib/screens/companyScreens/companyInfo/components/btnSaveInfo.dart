import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ButtonSaveInfo extends StatefulWidget {
  DocumentSnapshot post;
  String userID;
  ButtonSaveInfo({this.post, this.userID});

  @override
  _ButtonSaveInfoState createState() =>
      _ButtonSaveInfoState(post: post, userID: userID);
}

class _ButtonSaveInfoState extends State<ButtonSaveInfo> {
  DocumentSnapshot post;
  String userID;

  _ButtonSaveInfoState({this.post, this.userID});

  /// key za formu
  final _formKey = GlobalKey<FormState>();

  /// instanca za bazu
  final db = Firestore.instance;

  /// fokusi

  var focusImage = new FocusNode();
  var focusName = new FocusNode();
  var focusAbout = new FocusNode();
  var focusMail = new FocusNode();
  var focusPhone = new FocusNode();
  var focusWeb = new FocusNode();
  var focusLocation = new FocusNode();

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  /// Stringovi
  String userUid;
  String id;
  String phone,
      webPage,
      location,
      companyName,
      urlLogo,
      companyDescription,
      mail;
  String phoneLast,
      webPageLast,
      locationLast,
      companyNameLast,
      urlLogoLast,
      companyDescriptionLast,
      mailLast;

  /// counteri za velicinu ekrana (responsive)
  /// i za postojanje ruta kod kompanije
  bool _screenUtilActive = true;
  bool imaliRuta = true;

  /// counter da li je btn diiseblan ili ne
  bool _isBtnDisabled = true;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: Color.fromRGBO(219, 219, 219, 1),
        disabledTextColor: Color.fromRGBO(0, 0, 0, 1),
        color: Color.fromRGBO(3, 54, 255, 1),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          'SAČUVAJ PROMJENE',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: _isBtnDisabled
            ? null
            : () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();

                  if (urlLogoLast == null) {
                    urlLogoLast = urlLogo;
                  }
                  if (companyNameLast == null) {
                    companyNameLast = companyName;
                  }
                  if (companyDescriptionLast == null) {
                    companyDescriptionLast = companyDescription;
                  }
                  if (mailLast == null) {
                    mailLast = mail;
                  }
                  if (phoneLast == null) {
                    phoneLast = phone;
                  }
                  if (webPageLast == null) {
                    webPageLast = webPage;
                  }
                  if (locationLast == null) {
                    locationLast = location;
                  }

                  if (companyDescriptionLast == '' ||
                      mailLast == '' ||
                      locationLast == '' ||
                      companyNameLast == '' ||
                      urlLogoLast == '' ||
                      phoneLast == '' ||
                      webPageLast == '') {
                    if (onceToast == 0) {
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                        content: Text('Sva polja moraju biti popunjena.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {},
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      onceToast = 1;
                      Timer(Duration(seconds: 2), () {
                        onceToast = 0;
                      });
                    }
                  } else {
                    if (onceBtnPressed == 0) {
                      updateData(widget.post);

                      _isBtnDisabled = true;
                      onceBtnPressed = 1;
                    }
                  }
                }
              });
  }

  //  funckija za update todo
  updateData(DocumentSnapshot docID) async {
    await db.collection('Company').document(docID.documentID).updateData({
      'company_description': '$companyDescriptionLast',
      'company_name': '$companyNameLast',
      'email': '$mailLast',
      'location': '$locationLast',
      'phone': '$phoneLast',
      'url_logo': '$urlLogoLast',
      'webpage': '$webPageLast',
    });
    _isBtnDisabled = true;
  }
}
