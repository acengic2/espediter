import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/snackBar.dart';
import 'package:spediter/theme/style.dart';

class ButtonSave extends StatefulWidget {
  DocumentSnapshot post;
  String userID;

  ButtonSave({this.post, this.userID});
  @override
  _ButtonSaveState createState() =>
      _ButtonSaveState(userID: userID, post: post);
}

class _ButtonSaveState extends State<ButtonSave> {
  DocumentSnapshot post;

  _ButtonSaveState({this.post, this.userID});
  bool _isBtnDisabled = true;
  final db = Firestore.instance;

  /// Stringovi
  String userUid, userID;

  String id;
  String listOfInterdestinations = "";
  String goodsVar,
      dimensionsVar,
      selectedDateStringP,
      selectedDateStringD,
      endingDestination,
      startingDestination,
      vehicleVar,
      stringKonacnoP,
      stringKonacnoD,
      timeP,
      formatted,
      formatted2,
      timeD;
  int percentageVar;
  String capacityVar;
  String t11;
  String t22;

  /// DateTime tip datuma (radi validacije)
  DateTime selectedDateP;
  DateTime selectedDateD;
  DateTime startDateCompare;
  DateTime endDateCompare;
  DateTime t1;
  DateTime t2;

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  /// Timestamp var [unos u bazu zbog ordera ispisa]
  int dateOfSubmit = DateTime.now().millisecondsSinceEpoch;

  @override 
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: StyleColors().grayColor,
        disabledTextColor: Colors.black,
        color: StyleColors().blueColor,
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
                }

                /// VALIDACIJA POLJA
                if (percentageVar < 0 || percentageVar > 100) {
                  if (onceToast == 0) {
                    SnackBar1(message: 'Unesite broj od 0 do 100');

                    onceToast = 1;
                    Timer(Duration(seconds: 2), () {
                      onceToast = 0;
                    });
                  }
                } else {
                  if (onceBtnPressed == 0) {
                    updateData(widget.post);
                    onceBtnPressed = 1;
                    _isBtnDisabled = true;
                  }
                  // validateDatesAndTimes(context);

                }
              });
  }

  updateData(DocumentSnapshot doc) async {
    await db.collection('Rute').document(doc.documentID).updateData({
      'availability': '$percentageVar',
      'capacity': '$capacityVar',
      'ending_destination': '$endingDestination',
      'starting_destination': '$startingDestination',
      // 'interdestination': '$listOfInterdestinations',
      'arrival_date': '$formatted2',
      'arrival_time': '$t11',
      'departure_time': '$t22',
      'departure_date': '$formatted',
      'dimensions': '$dimensionsVar',
      'goods': '$goodsVar',
      'vehicle': '$vehicleVar',
      'user_id': '$userID',
      'timestamp': '$dateOfSubmit',
    });
  }
}
