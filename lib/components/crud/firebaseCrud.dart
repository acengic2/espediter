import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/loadingRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';

/// instanca za bazu
final db = Firestore.instance;

class  FirebaseCrud {
String userID;
  FirebaseCrud({this.userID});
  /// funkcija koja brise iz Rute
  /// potrebno joj je proslijediti doc.ID, DocumentSnapshot, i BuildContext
  void deleteData(
      DocumentSnapshot doc, String userID, BuildContext context) async {
    await db.collection('Rute').document(doc.documentID).delete();
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(userID: userID)));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NoRoutes(userID: userID)));
      }
    });
  }

  /// funkcija koja brise iz Rute na match datuma
  /// potrebno joj je proslijediti doc.ID, DocumentSnapshot, i BuildContext
  /// ne navigira nakon delete-a
  void deleteDataOnMatch(
      DocumentSnapshot doc, String userID, BuildContext context) async {
    await db.collection('Rute').document(doc.documentID).delete();
  }

  /// update Funkcija za Rute
  /// potrebno joj je proslijediti potrebne parametre
  updateData(
      DocumentSnapshot doc,
      int percentageVar,
      String capacityVar,
      String endingDestination,
      String startingDestination,
      String inter,
      String formatted,
      String formatted2,
      String t11,
      String t22,
      String dimensionsVar,
      String goodsVar,
      String vehicleVar,
      String userID,
      int dateOfSubmit,
      BuildContext context) async {
    await db.collection('Rute').document(doc.documentID).updateData({
      'availability': '$percentageVar',
      'capacity': '$capacityVar',
      'ending_destination': '$endingDestination',
      'starting_destination': '$startingDestination',
      'interdestination': '$inter',
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
    /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        print('NOT EMPRY');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID)),
        );
      } else {
        print('EMPTU');

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NoRoutes(userID: userID)));
      }
    });
  }

  /// create method for finished routes
  /// potrebno joj je proslijediti potrebne parametre
  finishedData(
    int percentageVar,
    String capacityVar,
    String endingDestination,
    String startingDestination,
    String formatted,
    String formatted2,
    String t11,
    String t22,
    String dimensionsVar,
    String goodsVar,
    String vehicleVar,
    String userID,
    int dateOfSubmit,
  ) async {
    // DocumentReference ref =
    await db.collection('FinishedRoutes').add({
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
    //setState(() => id = ref.documentID);
  }

  ///  funckija Update za CompanyInfo
  /// potrebni su svi parametri
  updateDataCompanyInfo(
      DocumentSnapshot doc,
      String companyDescriptionLast,
      String companyNameLast,
      String mailLast,
      String locationLast,
      String phoneLast,
      String urlLogoLast,
      String webPageLast,
      String userID,
      BuildContext context) async {
    await db.collection('Company').document(doc.documentID).updateData({
      'company_description': '$companyDescriptionLast',
      'company_name': '$companyNameLast',
      'email': '$mailLast',
      'location': '$locationLast',
      'phone': '$phoneLast',
      'url_logo': '$urlLogoLast',
      'webpage': '$webPageLast',
    });

    /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        print('NOT EMPRY');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID)),
        );
      } else {
        print('EMPTU');

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NoRoutes(userID: userID)));
      }
    });
  }

  // funkcija koja snima informacije u bazu
  createData(
      int percentageVar,
      String capacityVar,
      String endingDestination,
      String startingDestination,
      String formatted,
      String formatted2,
      String t11,
      String t22,
      String dimensionsVar,
      String goodsVar,
      String vehicleVar,
      String userID,
      String listOfInterdestinations,
      int dateOfSubmit,
      BuildContext context) async {
    await db.collection('Rute').add({
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
      //'arrivalTimestamp':  DateTime.parse('$formatted2 $t11').millisecondsSinceEpoch,
    });
    // navigiramo do ShowLoadingRoutes i saljemo userID i id
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowLoadingRoutes(
                userID: userID,
              )),
    );
  }
}
