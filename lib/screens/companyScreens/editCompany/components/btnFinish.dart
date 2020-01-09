import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/screens/companyScreens/createRoute/form.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'package:spediter/theme/style.dart';

class ButtonFinishRoute extends StatefulWidget {
  DocumentSnapshot post;
  String userID;
  ButtonFinishRoute({this.post, this.userID});
  @override
  _ButtonFinishRouteState createState() =>
      _ButtonFinishRouteState(userID: userID, post: post);
}

class _ButtonFinishRouteState extends State<ButtonFinishRoute> {
  DocumentSnapshot post;

  _ButtonFinishRouteState({this.post, this.userID});

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  /// instanca za bazu
  final db = Firestore.instance;

  List<InterdestinationForm> interdestinations = [];

  String userID;

  /// Stringovi
  String userUid;

  /// DateTime tip datuma (radi validacije)
  DateTime selectedDateP;
  DateTime selectedDateD;
  DateTime startDateCompare;
  DateTime endDateCompare;
  DateTime t1;
  DateTime t2;

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

  /// Timestamp var [unos u bazu zbog ordera ispisa]
  int dateOfSubmit = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: StyleColors().grayColor,
        disabledTextColor: Colors.black,
        color: StyleColors().destinationCircle1,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          'ZAVRŠITE RUTU',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {
          if (onceBtnPressed == 0) {
            // ubacujemo u FinishedRoutes
            finishedData();
            // brisemo iz Rute
            deleteData(widget.post);
            onceBtnPressed = 1;
          }
        });
  }

  // funkcija koja brise iz Rute
  //potrebno joj je proslijediti doc.ID
  void deleteData(DocumentSnapshot doc) async {
    await db.collection('Rute').document(doc.documentID).delete();
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(userID: userID)));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NoRoutes()));
      }
    });
  }

  void onDelete(Interdestination _interdestination) {
    setState(() {
      var find = interdestinations.firstWhere(
        (it) => it.interdestination == _interdestination,
        orElse: () => null,
      );
      if (find != null)
        interdestinations.removeAt(interdestinations.indexOf(find));
    });
  }

  /// onAddForm f-ja pomocu koje dodajemo novu interdestinaciju
  ///
  /// setState u kojem prosljedjujemo metodu onDelete i onAdd
  void onAddForm() {
    setState(() {
      var _interdestination = Interdestination();
      interdestinations.add(InterdestinationForm(
        interdestination: _interdestination,
        onDelete: () => onDelete(_interdestination),
        onAdd: () => onAddForm(),
      ));
    });
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

  finishedData() async {
    DocumentReference ref = await db.collection('FinishedRoutes').add({
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
    setState(() => id = ref.documentID);
  }
}
