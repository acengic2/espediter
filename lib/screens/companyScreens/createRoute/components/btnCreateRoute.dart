import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/loadingRoutes.dart';
import 'package:spediter/components/snackBar.dart';
import 'package:intl/intl.dart';
import 'package:spediter/screens/companyScreens/createRoute/form.dart';
import 'package:spediter/theme/style.dart';

class ButtonCreateRoute extends StatefulWidget {
  @override
  _ButtonCreateRouteState createState() => _ButtonCreateRouteState();
}

class _ButtonCreateRouteState extends State<ButtonCreateRoute> {
  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  List<InterdestinationForm> interdestinations = [];

  final format = DateFormat.MMMMd('bs');

  final formatTime = DateFormat("HH:mm");

  final formatP = DateFormat('yyyy-MM-dd');

  String userUid,
      userID,
      id,
      listOfInterdestinations = "",
      goodsVar = '',
      dimensionsVar = '',
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
      timeD,
      capacityVar,
      t11,
      t22;

  /// instanca za bazu
  final db = Firestore.instance;
  DateTime selectedDateP, selectedDateD, t1, t2;

  /// counter da li je btn diiseblan ili ne
  bool _isBtnDisabled = true;

  /// Timestamp var [unos u bazu zbog ordera ispisa]
  int dateOfSubmit = DateTime.now().millisecondsSinceEpoch;

  int percentageVar;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: StyleColors().disabledButton,
        disabledTextColor: Colors.black,
        color: StyleColors().blueColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          'KREIRAJ RUTU',
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
                    SnackBar1(message: "Unesite brojeve od 0 do 100");
                    onceToast = 1;
                    Timer(Duration(seconds: 2), () {
                      onceToast = 0;
                    });
                  }
                } else {
                  validateDatesAndTimes(context);
                }
              });
  }

  // funkcija koja snima informacije u bazu
  createData() async {
    DocumentReference ref = await db.collection('Rute').add({
      'availability': '$percentageVar',
      'capacity': '$capacityVar',
      'ending_destination': '$endingDestination',
      'starting_destination': '$startingDestination',
      'interdestination': '$listOfInterdestinations',
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
    setState(() => id = ref.documentID);

    // navigiramo do ShowLoadingRoutes i saljemo userID i id
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowLoadingRoutes(
                userID: userID,
                id: id,
              )),
    );
  }

  ///on save forms
  void onSave() {
    if (interdestinations.length > 0) {
      var allValid = true;
      interdestinations.forEach((form) => allValid = allValid);
      if (allValid) {
        var data = interdestinations.map((it) => it.interdestination).toList();
        for (int i = 0; i < data.length; i++) {
          if ('${data[i].interdestinationData}' != '')
            listOfInterdestinations += '${data[i].interdestinationData}, ';
          else
            listOfInterdestinations += '';
        }
      }
    }
  }

  validateDatesAndTimes(BuildContext context) {
    t11 = DateFormat.Hm().format(t1);
    t22 = DateFormat.Hm().format(t2);
    DateTime now = DateTime.now();
    selectedDateP = new DateTime(
        selectedDateP.year, selectedDateP.month, selectedDateP.day);
    selectedDateD = new DateTime(
        selectedDateD.year, selectedDateD.month, selectedDateD.day);
    if (selectedDateD.isBefore(selectedDateP)) {
      if (onceToast == 0) {
        SnackBar1(
            message: 'Datum polaska ne može biti veći od datuma dolaska.');

        onceToast = 1;
        Timer(Duration(seconds: 2), () {
          onceToast = 0;
        });
      }
    } else if (selectedDateP.isAtSameMomentAs(selectedDateD)) {
      if (DateFormat.Hm().format(t2).compareTo(DateFormat.Hm().format(t1)) >
          0) {
        if (onceToast == 0) {
          SnackBar1(
              message:
                  'Vrijeme polaska ne može biti veće od vremena dolaska, ako su datumi jednaki.');

          onceToast = 1;
          Timer(Duration(seconds: 2), () {
            onceToast = 0;
          });
        }
      } else if (DateFormat.Hm()
              .format(t2)
              .compareTo(DateFormat.Hm().format(t1)) ==
          0) {
        if (onceToast == 0) {
          SnackBar1(message: 'Datumi i vremena ne mogu biti jednaki.');

          onceToast = 1;
          Timer(Duration(seconds: 2), () {
            onceToast = 0;
          });
        }
      } else {
        if (onceBtnPressed == 0) {
          onSave();
          createData();
          onceBtnPressed = 1;
        }
      }
    } else if (selectedDateD.isBefore(DateTime(now.year, now.month, now.day))) {
      if (onceToast == 0) {
        SnackBar1(
            message: 'Datum dolaska ne može biti manji od današnjeg datuma.');

        onceToast = 1;
        Timer(Duration(seconds: 2), () {
          onceToast = 0;
        });
      }
    } else if (selectedDateD
        .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      if (DateFormat.Hm()
              .format(t1)
              .compareTo(DateFormat.Hm().format(DateTime.now())) <
          0) {
        if (onceToast == 0) {
          SnackBar1(
              message:
                  'Datum dolaska je jednak današnjem datumu, ali vrijeme dolaska ne može biti manje od trenutnog vremena.');

          onceToast = 1;
          Timer(Duration(seconds: 2), () {
            onceToast = 0;
          });
        }
      } else if (DateFormat.Hm()
              .format(t1)
              .compareTo(DateFormat.Hm().format(DateTime.now())) ==
          0) {
        if (onceToast == 0) {
          SnackBar1(
              message:
                  'Datum dolaska i vrijeme dolaska ne mogu biti jednaki današnjem datumu i trenutnom vremenu.');

          onceToast = 1;
          Timer(Duration(seconds: 2), () {
            onceToast = 0;
          });
        }
      } else {
        if (onceBtnPressed == 0) {
          onSave();
          createData();
          onceBtnPressed = 1;
        }
      }
    } else {
      if (onceBtnPressed == 0) {
        onSave();
        createData();
        onceBtnPressed = 1;
      }
    }
  }
}
