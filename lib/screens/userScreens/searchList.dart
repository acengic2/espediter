import 'dart:async';
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
int onceBtnPressed = 0;

class SearchListUser extends StatefulWidget {
  final String userID;
  String recent;

  SearchListUser({this.userID, this.recent});
  @override
  _SearchListUserState createState() => _SearchListUserState(
        userID: userID,
        recent: recent,
      );
}

final format = DateFormat.MMMMd('bs');
DateTime selectedDateP;
String formatted;
final formatP = DateFormat('yyyy-MM-dd');

class _SearchListUserState extends State<SearchListUser> {
  String userID, recent;
  _SearchListUserState({this.userID, this.recent});

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

    if (recent != ''&& recent != null) {
      listOfRecent = recent.split(', ');
    }
    return Column(
      children: <Widget>[
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
                      hintText: 'Izaberite Datum polaska robe',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      onceBtnPressed = 0;
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
                            labelText: 'Izaberite Mjesto odakle roba polazi',
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: () {
                          onceBtnPressed = 0;
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
                            labelText: 'Izaberite Mjesto gdje roba dolazi',
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: () {
                          onceBtnPressed = 0;
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
            if (onceBtnPressed == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UsersHome(
                      userID: userID,
                      datum: formatted,
                      polaziste: initialStart,
                      dolaziste: intialEnd,
                      filtered: filtered)));
              onceBtnPressed = 1;
            }
            Timer(Duration(seconds: 5), () {
              onceBtnPressed = 0;
            });
          },
        )
      ],
    );
  }
}

class RouteSearch extends SearchDelegate<SearchListUser> {
  String userID, recent;

  RouteSearch({this.userID, this.recent});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          result = query;
          if (result.isNotEmpty) {
            result = result.substring(0, 1).toUpperCase() +
                result.substring(1, result.length);
          }
          filtered = false;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UsersHome(
                    userID: userID,
                    recent: recent,
                  )));
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return DestinationCircle(
      largeCircle: StyleColors().textColorGray20,
      smallCircle: StyleColors().textColorGray50,
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
    bool isRecent = true;
    if (query.isNotEmpty) {
      isRecent = false;
    }
    final suggestionList = query.isEmpty
        ? listOfRecent
        : citiesList.where((p) => p.toLowerCase().startsWith(query)).toList();

    return new ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: StyleColors().textColorGray12),
          ),
        ),
        child: ListTile(
          onTap: () {
            result = suggestionList[index].toString();
            filtered = false;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UsersHome(
                      userID: userID,
                      recent: recent,
                    )));
          },
          leading: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: isRecent
                    ? Icon(
                        Icons.schedule,
                        color: Colors.black,
                        size: 15.0,
                      )
                    : Icon(
                        Icons.gps_fixed,
                        color: Colors.black,
                        size: 15.0,
                      ),
              ),
              Container(
                child: Icon(
                  Icons.brightness_1,
                  color: StyleColors().textColorGray20,
                  size: 30.0,
                ),
              )
            ],
          ),
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey),
                )
              ])),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
