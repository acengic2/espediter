import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/crud/signInMethods.dart';
import 'package:spediter/components/noInternetConnectionScreen/noInternetOnLogin.dart';

import '../../../theme/style.dart';

class FormLogIn extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final db = Firestore.instance;
var err;
final FirebaseAuth _auth = FirebaseAuth.instance;

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
                            BorderSide(color: StyleColors().textColorGray12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: StyleColors().blueColor),
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
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Email polje je prazno'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        onceToast = 1;
                      }
                      return '';
                    }

                    // email mora biti validan [____@___.___]

                    else if (!EmailValidator.validate(input, true)) {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Email nije validan'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        onceToast = 1;
                      }
                      return '';
                    }

                    // da li taj email stvarno postoji u bazi

                    else if (userExist != 'User postoji') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('User sa unesenim emailm ne postoji'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
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
                            BorderSide(color: StyleColors().textColorGray12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: StyleColors().blueColor),
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
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Password polje je prazno'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        onceToast = 1;
                      }
                      return '';
                    }

                    // pass mora biti veci od 6 karaktera

                    else if (input.length < 6) {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content:
                              Text('Password mora biti veci od 6 karaktera'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        onceToast = 1;
                      }
                      return '';
                    }

                    // da li ta sifra postoji u bazi i da li odgovara unesenom mailu

                    else if (passExist != 'Pass postoji') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Password nije tacan'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        onceToast = 1;
                      }
                      return '';
                    }
                    return null;
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
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),

                      child: Text(
                        'PRIJAVA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      color: Color.fromRGBO(3, 54, 255, 1.0),

                      // na press btn-a
                      onPressed:
                          // provjera internet konekcije

                          () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');

                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {}
                        } on SocketException catch (_) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NoInternetConnectionLogInSrceen()));
                        }

                        // zatvaranje tastature na klik dugmeta

                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        // provjera da li su oba polja prazna -> email && password

                        if (_email == '' && _password == '') {
                          if (onceToast == 0) {
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: StyleColors().snackBar,
                              content: Text('Oba polja su prazna'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            onceToast = 1;
                            Timer(Duration(seconds: 2), () {
                              onceToast = 0;
                            });
                          }
                        }

                        // ukoliko nisu prazna izvrsi slj funkcije -> [signIn]
                        // setamo counter [onceBtnPressed] na 1 nakon jednog klika kako bi
                        // zabranili mogucnost vise klikova

                        else {
                          if (onceBtnPressed == 0) {
                            SignInMethods().signIn(
                                                   _email, 
                                                   _password, 
                                                   _formKey,
                                                   userID, 
                                                   err, 
                                                   context
                                                   );
                            onceBtnPressed = 1;
                          }
                        }
                      },
                    ),
                  )),

              /// FUTURE BUILDER
              ///
              /// ovdje provjeravamo da li password zaista postoji u bazi
              /// dok se provjerava printamo [Loading]
              /// ukoliko postoji =>  String [passExist] = Pass postoji
              /// ukoliko ne postoji =>  String [passExist] = Pass ne postoji

              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: SignInMethods().doesPassAlreadyExist(_password),
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
                    future: SignInMethods().doesNameAlreadyExist(_email),
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

  

  
}
