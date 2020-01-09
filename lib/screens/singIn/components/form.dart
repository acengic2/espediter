import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/snackBar.dart';
import 'package:spediter/screens/singIn/components/btnLogin.dart';

class FormLogIn extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final db = Firestore.instance;

var _focusNode = new FocusNode();
var focusNode = new FocusNode();

String _email = '', _password = '', userExist, passExist, id, userID;
int onceToast = 0, onceBtnPressed = 0;

class _FormState extends State<FormLogIn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          // form key na osnovu kojeg kupimo podatke sa forme
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom: 24.0, left: 24.0, right: 24.0, top: 24.0),
                child:

                    // EMAIL textform field

                    TextFormField(
                  focusNode: focusNode,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: true,
                  enableInteractiveSelection: false,
                  autovalidate: false,

                  // dekoracija fielda

                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0)),
                      ),
                      labelText: 'email',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                  // VALIDACIJA fielda

                  validator: (input) {
                    //  polje ne smije biti prazno

                    if (input == '') {
                      if (onceToast == 0) {
                        SnackBar1(
                          message: 'Email polje je prazno',
                        );
                        onceToast = 1;
                      }
                      return '';
                    }

                    // email mora biti validan [____@___.___]

                    else if (!EmailValidator.validate(input, true)) {
                      if (onceToast == 0) {
                        SnackBar1(
                          message: 'Email nije validan',
                        );
                        onceToast = 1;
                      }
                      return '';
                    }

                    // da li taj email stvarno postoji u bazi

                    else if (userExist != 'User postoji') {
                      if (onceToast == 0) {
                        SnackBar1(
                          message: 'User sa unesenim emailom ne postoji',
                        );
                        onceToast = 1;
                      }
                      return '';
                    }
                    return null;
                  },

                  // na promjenu u polju setamo state
                  // email == input
                  onChanged: (input) {
                    setState(() {
                      _email = input;
                    });
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                child:

                    // PASSWORD textform field
                    TextFormField(
                  focusNode: _focusNode,
                  obscureText: true,

                  //  dekoracija fielda
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0)),
                      ),
                      labelText: 'lozinka',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                  // VALIDACIJA fielda

                  validator: (input) {
                    // polje ne smije biti prazno

                    if (input == '') {
                      if (onceToast == 0) {
                        SnackBar1(message: 'Password polje je prazno');
                        onceToast = 1;
                      }
                      return '';
                    }

                    // pass mora biti veci od 6 karaktera

                    else if (input.length < 6) {
                      if (onceToast == 0) {
                        SnackBar1(
                            message: 'Password mora biti veći od 6 karaktera');
                        onceToast = 1;
                      }
                      return '';
                    }

                    // da li ta sifra postoji u bazi i da li odgovara unesenom mailu

                    else if (passExist != 'Pass postoji') {
                      if (onceToast == 0) {
                        SnackBar1(message: 'Password nije tačan');
                        onceToast = 1;
                      }
                      return '';
                    }
                  },

                  //  setanje state-a
                  // password == input
                  onChanged: (input) {
                    setState(() {
                      _password = input;
                    });
                  },
                ),
              ),

              // container -> constrainedBox -> u kojem se nalazi button PRIJAVA

              Container(
                margin: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 284.0,
                ),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: ButtonLogin()),
              ),

              /// FUTURE BUILDER
              ///
              /// ovdje provjeravamo da li password zaista postoji u bazi
              /// dok se provjerava printamo [Loading]
              /// ukoliko postoji =>  String [passExist] = Pass postoji
              /// ukoliko ne postoji =>  String [passExist] = Pass ne postoji

              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: doesPassAlreadyExist(_password),
                    builder: (context, AsyncSnapshot<bool> result) {
                      if (!result.hasData) {
                        onceToast = 0;
                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // future still needs to be finished (loading)

                      if (result.data) {
                        passExist = 'Pass postoji';
                        onceToast = 0;
                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // result.data is the returned bool from doesNameAlreadyExists

                      else {
                        passExist = 'Pass ne postoji';
                        onceToast = 0;
                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ),
                ],
              ),

              /// FUTURE BUILDER
              ///
              /// Ovdje provjeravamo da li Email/User zaista postoji u bazi
              /// dok se provjerava printamo [Loading]
              /// ukoliko postoji =>  String [userExist] = User postoji
              /// ukoliko ne postoji =>  String [userExist] = User ne postoji

              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: doesNameAlreadyExist(_email),
                    builder: (context, AsyncSnapshot<bool> result) {
                      if (!result.hasData) {
                        onceToast = 0;
                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // future still needs to be finished (loading)

                      if (result.data) {
                        onceToast = 0;
                        onceBtnPressed = 0;
                        userExist = 'User postoji';

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // result.data is the returned bool from doesNameAlreadyExists

                      else {
                        onceToast = 0;

                        onceBtnPressed = 0;
                        userExist = 'User ne postoji';
                        passExist = 'Pass ne postoji';

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ), //FutureBuilder
                ], //<Widget>
              ), //Column
            ], //<Widget>
          ), //Column
        )
      ],
    ); //FORM
  }

  /// provjera emaila
  ///
  /// ovdje nam se nalazi logika za provjeru email-a,
  /// odnosno da li user zaista postoji u bazi
  /// metoda je tipa bool
  /// spajamo se na kolekciju [LoggedUsers], gdje postavljamo query
  /// da li je email == unesenom email-u
  /// limitiramo nasu pretragu na 1 document i vracamo
  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('LoggedUsers')
        .where('email', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  /// provjera sifre
  ///
  /// ovdje nam se nalazi logika za provjeru passworda,
  /// odnosno da li pass zaista postoji u bazi
  /// metoda je tipa bool
  /// spajamo se na kolekciju [LoggedUsers], gdje postavljamo query
  /// da li je pass == unesenom passwordu
  /// limitiramo nasu pretragu na 1 document i vracamo
  Future<bool> doesPassAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('LoggedUsers')
        .where('password', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }
}
