import 'dart:collection';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/screens/userScreens/citiesFromDB.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';
import 'package:spediter/theme/style.dart';

void main() => runApp(SearchListUser());

class SearchListUser extends StatefulWidget {

 final String userID;

  SearchListUser({this.userID});
  @override
  _SearchListUserState createState() => _SearchListUserState(userID: userID);
}

final format = DateFormat.MMMMd('bs');
DateTime selectedDateP;
String formatted;
final formatP = DateFormat('yyyy-MM-dd');

class _SearchListUserState extends State<SearchListUser> {

  String userID;
  _SearchListUserState({this.userID});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                    textCapitalization: TextCapitalization.words,
                    // style: TextStyle(
                    //     fontSize: ScreenUtil.instance.setSp(15.0)),
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
                      });

                      setState(() {
                        formatted = formatP.format(selectedDateP);

                        if (selectedDateP == null) {
                          selectedDateP = DateTime.now();
                        } else {
                          selectedDateP = picked;
                        }
                      });

                      return selectedDateP;
                    },
                    onChanged: (input) {
                      // onceToast = 0;

                      // areFieldsEmpty();
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
                          FocusScope.of(context).requestFocus(FocusNode());

                          showSearch(context: context, delegate: RouteSearch(userID: userID));
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
                        onChanged: (input) {
                          setState(() {
                            // onceToast = 0;
                            // onceBtnPressed = 0;
                            // endingDestination = input;
                            // areFieldsEmpty();
                          });
                        },
                      )))
            ])),
      ],
    );
  }
}

class RouteSearch extends SearchDelegate<UsersHome> {

  final UnmodifiableListView<UsersHome> routeList;

String userID;
RouteSearch({this.userID, this.routeList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear),
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CitiesFromDB(userID:userID);   
  }
   
}
