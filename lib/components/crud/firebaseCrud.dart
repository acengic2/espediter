import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/loadingRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';

/// instanca za bazu
final db = Firestore.instance;

class FirebaseCrud {
  String userID;
  FirebaseCrud({this.userID});

  /// funkcija koja brise iz Rute
  /// potrebno joj je proslijediti doc.ID, DocumentSnapshot, i BuildContext
  void deleteData(
      DocumentSnapshot doc, String userID, BuildContext context) async {
    await db.collection('Rute').document(doc.documentID).delete();
    CompanyRoutes().getCompanyFinishedRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else if (docs.documents.isEmpty) {
        CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
          if (docs.documents.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListOfRoutes(
                      userID: userID,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoRoutes(userID: userID)));
          }
        });
      }
    });
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
    CompanyRoutes().getCompanyFinishedRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else if (docs.documents.isEmpty) {
        CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
          if (docs.documents.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListOfRoutes(
                      userID: userID,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoRoutes(userID: userID)));
          }
        });
      }
    });
  }

  finishRoute(int arrivalT, DocumentSnapshot doc, BuildContext context, String userID) async {
     await db.collection('Rute').document(doc.documentID).updateData({
       'arrival_timestamp': '$arrivalT',
     });
      CompanyRoutes().getCompanyFinishedRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else if (docs.documents.isEmpty) {
        CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
          if (docs.documents.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListOfRoutes(
                      userID: userID,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoRoutes(userID: userID)));
          }
        });
      }
    });
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
    CompanyRoutes().getCompanyFinishedRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else if (docs.documents.isEmpty) {
        CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
          if (docs.documents.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListOfRoutes(
                      userID: userID,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoRoutes(userID: userID)));
          }
        });
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
      int aTimestamp,
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
      'arrival_timestamp': '$aTimestamp'
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
