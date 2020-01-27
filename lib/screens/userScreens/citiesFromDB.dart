// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:spediter/components/divider.dart';

// class CitiesFromDB extends StatefulWidget {
//   final String userID;
//   CitiesFromDB({this.userID});

//   @override
//   _CitiesFromDBState createState() => _CitiesFromDBState(userID: userID);
// }

// class _CitiesFromDBState extends State<CitiesFromDB> {
//   String userID;
//   _CitiesFromDBState({this.userID});

//   @override
//   Widget build(BuildContext context) {
//     double defaultScreenWidth = 400.0;
//     double defaultScreenHeight = 810.0;
//     ScreenUtil.instance = ScreenUtil(
//       width: defaultScreenWidth,
//       height: defaultScreenHeight,
//       allowFontScaling: true,
//     )..init(context);





//   return Column(children: <Widget>[

//     //First future recents 
// FutureBuilder(
//       future: getPosts12(userID),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: ClampingScrollPhysics(),
//             addAutomaticKeepAlives: true,
//             itemCount: snapshot.data.length,
//             itemBuilder: (context, index) {
//               String recent = snapshot.data[index].data['recent'];

//               if (recent != '') {
//                 List<String> listOfRecent = recent.split(', ');

//                 return new Column(
//                     children: listOfRecent
//                         .map(
//                           (item) => Padding(
//                             padding: EdgeInsets.only(left: 16),
//                             child: Column(
//                                 children: <Widget>[
//                                   ListTile(
//                                     title: Text(item),
//                                     leading: Icon(Icons.schedule),
//                                     contentPadding:
//                                         EdgeInsets.symmetric(horizontal: 0.0),
//                                   ),
//                                   Divider1(
//                                     height: 1,
//                                     thickness: 1,
//                                   )
//                                 ],
//                               ),
//                           ),
//                         )
//                         .toList());
//               }
//               return Text("DSADSADSADSA ne radi");
//             },
//           );
//         }
//         return SizedBox();
//       },
//     ),


// /// Future za gradove
// /// 
//      Container(
//        width: 0,
//        height: 0,
//             child: FutureBuilder(
//         builder: (context, snapshot) {
//           var myData = json.decode(snapshot.data.toString());
//           final citiesList = [];
//           citiesList.add(myData);

          

//           return new ListView.builder(
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               addAutomaticKeepAlives: true,
//               itemCount: myData.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: new Text(myData[index]['grad']),
//                   subtitle: new Text(myData[index]['drzava']),
//                 );
//               });
//         },
//         future: DefaultAssetBundle.of(context).loadString("assets/gradovi.json"),
//     ),
//      ),



// Container( /// show when someone searches something
//     final suggestionList = query.isEmpty
//         ? recentCities
//         : cities.where((p) => p.startsWith(query)).toList();
//     child:  ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           showResults(context);
//         },
//         leading: Icon(Icons.location_city),
//         title: RichText(text: TextSpan(text: suggestionList[index].substring(0, query.length),
//         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         children: [
//             TextSpan(
//               text: suggestionList[index].substring(query.length),
//               style: TextStyle(color: Colors.grey),
//             )
//         ]
//         )),
//       ),
//       itemCount: suggestionList.length,
//     );)
//      /// Suggestion print
     
    

//   ],);

//   }

//   Future getPosts12(String id) async {
//     var firestore = Firestore.instance;
//     QuerySnapshot qn = await firestore
//         .collection('Users')
//         .where('user_id', isEqualTo: id)
//         .getDocuments();
//     return qn.documents;
//   }

//   //   void printDailyNewsDigest() {
//   //   final future = gatherNewsReports();
//   //   future.then((news) => print(news));
//   // }
// }
