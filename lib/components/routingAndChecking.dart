import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';

class RouteAndCheck {
  checkAndNavigate(BuildContext context, String userID) {
    /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
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
}
