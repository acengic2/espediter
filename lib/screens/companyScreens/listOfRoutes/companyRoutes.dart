import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spediter/components/crud/firebaseCrud.dart';

int arrivalTimestamp;
int thisMomentTimestamp;

class CompanyRoutes {
  // getCompanyRoutes
  //
  // metoda koja prima [id] (userID) i koja filtrira kroz kolekciju ruta
  // izjednacava [user_id] iz baze i id trenutno logovane kompanije
  // i fetcha sve dokumente koji imaju taj id
  getCompanyRoutes(String id) {
    return Firestore.instance
        .collection('Rute')
        .where('user_id', isEqualTo: id)
        .orderBy('timestamp', descending: true)
        .getDocuments();
  }

  getCompanyFinishedRoutes(String id) {
    return Firestore.instance
        .collection('FinishedRoutes')
        .where('user_id', isEqualTo: id)
        .orderBy('timestamp', descending: false)
        .getDocuments();


    
  }

  deleteRouteOnDateMatch(
    DocumentSnapshot doc,
    String userID,
    BuildContext context,
  ) {
    DateTime arrivalTime = DateTime.parse(
        doc.data['arrival_date'] + ' ' + doc.data['arrival_time']);
    arrivalTimestamp = arrivalTime.millisecondsSinceEpoch;
    thisMomentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (arrivalTimestamp < thisMomentTimestamp) {
      FirebaseCrud().deleteDataOnMatch(doc, userID, context);
      print('DELETO SAM');
    } else {
      print('nema nista DELETE');
    }
  }

  insertIntoFinishOnDateMatch(
    DocumentSnapshot doc,
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
  ) {

    DateTime arrivalTime = DateTime.parse(
        doc.data['arrival_date'] + ' ' + doc.data['arrival_time']);
    arrivalTimestamp = arrivalTime.millisecondsSinceEpoch;
    thisMomentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (arrivalTimestamp < thisMomentTimestamp) {
      FirebaseCrud().finishedData(
          percentageVar,
          capacityVar,
          endingDestination,
          startingDestination,
          formatted,
          formatted2,
          t11,
          t22,
          dimensionsVar,
          goodsVar,
          vehicleVar,
          userID,
          dateOfSubmit);
          print('UNSENO');
    } else {
      print('nema nista INSERT');
    }
  }
}
