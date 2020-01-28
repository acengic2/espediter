import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';
import 'package:spediter/theme/style.dart';

void main() => runApp(SearchListUser());

var listOfRecent = [];
var citiesList = [];
String result;
String controlVar = '';
String initialStart = '';
String intialEnd = '';
bool filtered = false;

class SearchListUser extends StatefulWidget {
  final String userID;

  SearchListUser({
    this.userID,
  });
  @override
  _SearchListUserState createState() => _SearchListUserState(
        userID: userID,
      );
}

final format = DateFormat.MMMMd('bs');
DateTime selectedDateP;
String formatted;
final formatP = DateFormat('yyyy-MM-dd');

class _SearchListUserState extends State<SearchListUser> {
  String userID;
  _SearchListUserState({
    this.userID,
  });

  getMyData(AsyncSnapshot snapshot) async {
    var myData = await json.decode(snapshot.data.toString());

    for (var i = 0; i < myData.length; i++) {
      citiesList.add(myData[i]['grad']);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controlVar == 'starting') {
      initialStart = result;
    }
    if (controlVar == 'ending') {
      intialEnd = result;
    }
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: getPosts12(userID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  String recent = snapshot.data[index].data['recent'];
                  if (recent != '') {
                    listOfRecent = recent.split(', ');
                  }
                  return Container(height: 0, width: 0);
                },
              );
            }
            return Container(height: 0, width: 0);
          },
        ),
        Container(
          height: 0,
          width: 0,
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("assets/gradovi.json"),
            builder: (context, snapshot) {
              citiesList = [];

              getMyData(snapshot);

              return Container(height: 0, width: 0);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 8, left: 16.0, right: 16.0, top: 45),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  height: 36.0,
                  padding: EdgeInsets.only(left: 4.0, right: 4.0),
                  child: DateTimeField(
                    initialValue:
                        (selectedDateP != null) ? selectedDateP : null,
                    textCapitalization: TextCapitalization.words,
                    resetIcon: null,
                    readOnly: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                      ),
                      hintText: 'Datum polaska',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      DateTime picked = await showDatePicker(
                          locale: Locale('bs'),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2100));
                      if (picked == null) {
                        picked = DateTime.now();
                      }
                      setState(() {
                        selectedDateP = picked;
                        if (selectedDateP == null) {
                          selectedDateP = DateTime.now();
                        } else {
                          selectedDateP = picked;
                        }
                        formatted = formatP.format(selectedDateP);
                      });
                      filtered = false;
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //         UsersHome(userID: userID, datum: formatted, polaziste: initialStart, dolaziste: intialEnd)));
                      return selectedDateP;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      DestinationCircle(
                          largeCircle: StyleColors().blueColor2,
                          smallCircle: StyleColors().blueColor),
                      DestinationLine(),
                    ],
                  )),
              Expanded(
                  flex: 9,
                  child: Container(
                      margin: EdgeInsets.only(left: 9, bottom: 8, right: 5),
                      height: 36,
                      child: TextFormField(
                        initialValue: initialStart,
                        maxLength: 32,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            counterText: '',
                            hasFloatingPlaceholder: false,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 0, 0, 0.12)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.12))),
                            labelText: 'Polazište',
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: () {
                          controlVar = 'starting';
                          filtered = false;
                          FocusScope.of(context).requestFocus(FocusNode());
                          showSearch(
                              context: context,
                              delegate: RouteSearch(userID: userID));
                        },
                      )))
            ])),
        Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      DestinationLine(),
                      DestinationCircle(
                        largeCircle: StyleColors().destinationCircle2,
                        smallCircle: StyleColors().destinationCircle1,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 9,
                  child: Container(
                      margin: EdgeInsets.only(left: 9, bottom: 16, right: 5),
                      height: 36,
                      child: TextFormField(
                        initialValue: intialEnd,
                        maxLength: 32,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            counterText: '',
                            hasFloatingPlaceholder: false,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 0, 0, 0.12)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.12))),
                            labelText: 'Odredište',
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: () {
                          controlVar = 'ending';
                          filtered = false;
                          FocusScope.of(context).requestFocus(FocusNode());
                          showSearch(
                              context: context,
                              delegate: RouteSearch(userID: userID));
                        },
                      )))
            ])),
        RaisedButton(
          child: Text('FILTRIRAJ'),
          onPressed: () {
            filtered = true;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UsersHome(
                    userID: userID,
                    datum: formatted,
                    polaziste: initialStart,
                    dolaziste: intialEnd,
                    filtered: filtered)));
          },
        )
      ],
    );
  }

  Future getPosts12(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Users')
        .where('user_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }
}

class RouteSearch extends SearchDelegate<SearchListUser> {
  String userID;

  RouteSearch({
    this.userID,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 0,
      width: 0,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? listOfRecent
        : citiesList.where((p) => p.toLowerCase().startsWith(query)).toList();

    return new ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          result = suggestionList[index].toString();
          filtered = false;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UsersHome(userID: userID)));
        },
        leading: Icon(Icons.location_city),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              )
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
