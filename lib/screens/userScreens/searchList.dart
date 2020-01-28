// import 'dart:collection';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:spediter/components/destinationCircles.dart';
// import 'package:spediter/components/destinationLines.dart';
// import 'package:spediter/screens/userScreens/usersHome.dart';
// import 'package:spediter/theme/style.dart';

// void main() => runApp(SearchListUser());

// var listOfRecent = [];
// var citiesList = [];
// String result;

// class SearchListUser extends StatefulWidget {
//   final String userID;

//   SearchListUser({
//     this.userID,
//   });
//   @override
//   _SearchListUserState createState() => _SearchListUserState(
//         userID: userID,
//       );
// }

// final format = DateFormat.MMMMd('bs');
// DateTime selectedDateP;
// String formatted;
// final formatP = DateFormat('yyyy-MM-dd');

// class _SearchListUserState extends State<SearchListUser> {
//   String userID;
//   _SearchListUserState({
//     this.userID,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         FutureBuilder(
//           future: getPosts12(userID),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: ClampingScrollPhysics(),
//                 addAutomaticKeepAlives: true,
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index) {
//                   String recent = snapshot.data[index].data['recent'];

//                   if (recent != '') {
//                     listOfRecent = recent.split(', ');
//                   }
//                   return SizedBox();
//                 },
//               );
//             }
//             return SizedBox();
//           },
//         ),
//         Container(
//           height: 0,
//           width: 0,
//           child: FutureBuilder(
//             builder: (context, snapshot) {
//               var myData = json.decode(snapshot.data.toString());
//               return new ListView.builder(
//                   shrinkWrap: true,
//                   physics: ClampingScrollPhysics(),
//                   addAutomaticKeepAlives: true,
                 
//                   itemBuilder: (BuildContext context, int index) {
//                     citiesList = [];
//                     // return ListTile(
//                     //   title: new Text(myData[index]['grad']),
//                     //   subtitle: new Text(myData[index]['drzava']),
//                     // );
//                     citiesList.add(myData[index]['grad']);
//                     return SizedBox();
//                   },
//                    itemCount: myData.length,);
//             },
//             future: DefaultAssetBundle.of(context)
//                 .loadString("assets/gradovi.json"),
//           ),
//         ),
//         Container(
//           height: 0,
//           width: 0,
//           child: FutureBuilder(
          
//             builder: (context, snapshot) {
            
//               var myData = json.decode(snapshot.data.toString());

//               for (var i = 0; i < citiesList.length; i++) {
//                 citiesList.add(myData[i]['grad']);
//               }
//               return SizedBox();
//             },
//             future: DefaultAssetBundle.of(context)
//                 .loadString("assets/gradovi.json"),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(bottom: 8, left: 16.0, right: 16.0, top: 45),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 5,
//                 child: Container(
//                   height: 36.0,
//                   padding: EdgeInsets.only(left: 4.0, right: 4.0),
//                   child: DateTimeField(
//                     textCapitalization: TextCapitalization.words,
//                     // style: TextStyle(
//                     //     fontSize: ScreenUtil.instance.setSp(15.0)),
//                     resetIcon: null,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                         borderSide:
//                             BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
//                       ),
//                       hintText: 'Datum polaska',
//                       contentPadding:
//                           EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                     ),
//                     format: format,
//                     onShowPicker: (context, currentValue) async {
//                       DateTime picked = await showDatePicker(
//                           locale: Locale('bs'),
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2018),
//                           lastDate: DateTime(2100));

//                       if (picked == null) {
//                         picked = DateTime.now();
//                       }

//                       setState(() {
//                         selectedDateP = picked;

//                         if (selectedDateP == null) {
//                           selectedDateP = DateTime.now();
//                         } else {
//                           selectedDateP = picked;
//                         }
//                       });

//                       setState(() {
//                         formatted = formatP.format(selectedDateP);

//                         if (selectedDateP == null) {
//                           selectedDateP = DateTime.now();
//                         } else {
//                           selectedDateP = picked;
//                         }
//                       });

//                       return selectedDateP;
//                     },
//                     onChanged: (input) {},
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//             margin: EdgeInsets.only(left: 16.0, right: 16.0),
//             child: Row(children: <Widget>[
//               Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: <Widget>[
//                       DestinationCircle(
//                           largeCircle: StyleColors().blueColor2,
//                           smallCircle: StyleColors().blueColor),
//                       DestinationLine(),
//                     ],
//                   )),
//               Expanded(
//                   flex: 9,
//                   child: Container(
//                       margin: EdgeInsets.only(left: 9, bottom: 8, right: 5),
//                       height: 36,
//                       child: TextFormField(
//                         initialValue: result,
//                         maxLength: 32,
//                         textCapitalization: TextCapitalization.sentences,
//                         decoration: InputDecoration(
//                             counterText: '',
//                             hasFloatingPlaceholder: false,
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(4.0)),
//                               borderSide: BorderSide(
//                                   color: Color.fromRGBO(0, 0, 0, 0.12)),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4.0)),
//                                 borderSide: BorderSide(
//                                     color: Color.fromRGBO(0, 0, 0, 0.12))),
//                             labelText: 'Polazište',
//                             labelStyle:
//                                 TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0))),
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(FocusNode());

//                           showSearch(
//                               context: context,
//                               delegate: RouteSearch(userID: userID));
//                         },
//                       )))
//             ])),
//         Container(
//             margin: EdgeInsets.only(
//               left: 16.0,
//               right: 16.0,
//             ),
//             child: Row(children: <Widget>[
//               Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: <Widget>[
//                       DestinationLine(),
//                       DestinationCircle(
//                         largeCircle: StyleColors().destinationCircle2,
//                         smallCircle: StyleColors().destinationCircle1,
//                       ),
//                     ],
//                   )),
//               Expanded(
//                   flex: 9,
//                   child: Container(
//                       margin: EdgeInsets.only(left: 9, bottom: 16, right: 5),
//                       height: 36,
//                       child: TextFormField(
//                         maxLength: 32,
//                         textCapitalization: TextCapitalization.sentences,
//                         decoration: InputDecoration(
//                             counterText: '',
//                             hasFloatingPlaceholder: false,
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(4.0)),
//                               borderSide: BorderSide(
//                                   color: Color.fromRGBO(0, 0, 0, 0.12)),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4.0)),
//                                 borderSide: BorderSide(
//                                     color: Color.fromRGBO(0, 0, 0, 0.12))),
//                             labelText: 'Odredište',
//                             labelStyle:
//                                 TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0))),
//                         onChanged: (input) {
//                           setState(() {
//                             // onceToast = 0;
//                             // onceBtnPressed = 0;
//                             // endingDestination = input;
//                             // areFieldsEmpty();
//                           });
//                         },
//                       )))
//             ])),
//       ],
//     );
//   }

//   Future getPosts12(String id) async {
//     var firestore = Firestore.instance;
//     QuerySnapshot qn = await firestore
//         .collection('Users')
//         .where('user_id', isEqualTo: id)
//         .getDocuments();
//     return qn.documents;
//   }
// }

// class RouteSearch extends SearchDelegate<SearchListUser> {
//   String userID;

//   RouteSearch({
//     this.userID,
//   });

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {},
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       height: 0,
//       width: 0,
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty
//         ? listOfRecent
//         : citiesList.where((p) => p.toLowerCase().startsWith(query)).toList();

//     return ListView(
//       shrinkWrap: true,
//       physics: ClampingScrollPhysics(),
//       addAutomaticKeepAlives: true,
      
//       children: <Widget>[
//         query.isNotEmpty
//             ? ListTile(
//                 onTap: () {
//                   result = query;
//                   result = result.substring(0, 1).toUpperCase() +
//                       result.substring(1, result.length);
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) =>
//                           UsersHome(userID: userID, polaziste: result)));
//                 },
//                 leading: Icon(Icons.location_city),
//                 title: RichText(
//                     text: TextSpan(
//                   text: query,
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold),
//                 )),
//               )
//             : Container(
//                 height: 0,
//                 width: 0,
//               ),
//         new ListView.builder(
//             shrinkWrap: true,
//             physics: ClampingScrollPhysics(),
//             addAutomaticKeepAlives: true,
            
//             itemBuilder: (context, index) => ListTile(
//                   onTap: () {
//                     result = suggestionList[index].toString();
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) =>
//                             UsersHome(userID: userID, polaziste: result)));
//                   },
//                   leading: Icon(Icons.location_city),
//                   title: RichText(
//                       text: TextSpan(
//                           text:
//                               suggestionList[index].substring(0, query.length),
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.bold),
//                           children: [
//                         TextSpan(
//                           text: suggestionList[index].substring(query.length),
//                           style: TextStyle(color: Colors.grey),
//                         )
//                       ])),
//                 ),itemCount: suggestionList.length,
//             )
//       ],
//     );
//   }
// }
