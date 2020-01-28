import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByPolazak(String searchField) {
    return Firestore.instance
        .collection('Rute')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        // .where('searchKeyInter',
        //     isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

}
