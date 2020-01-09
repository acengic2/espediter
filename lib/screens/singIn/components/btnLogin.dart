import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/loading.dart';
import 'package:spediter/components/noInternetConnectionScreen/noInternetOnLogin.dart';
import 'package:spediter/components/snackBar.dart';
import 'package:spediter/theme/style.dart';

class ButtonLogin extends StatelessWidget {
  var err;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '', _password = '', userExist, passExist, id, userID;
  int onceToast = 0, onceBtnPressed = 0;

  @override
  Widget build(BuildContext context) {
    /// SIGNIN metoda
    ///
    /// metoda koja prima email i password
    /// async metoda
    /// ukoliko su validacije koje smo kreirali na textFormFields prosle
    /// onda prelazimo na upis email-a i passworda u bazu [Auth dio baze]
    /// nakon upisa povratnu informaciju spremamo u result, zatim sve informacije vezane za usera spremamo
    /// u varijablu [FirebaseUser user], nakon cega izvlacimo ID, email, i user info
    /// ukoliko sve ovo bude uspjesno, navigiramo na slj screen [ShowLoadingScreen]
    /// cjelokupna metoda upisa je umotana u try-catch blok
    /// catch-amo error ukoliko ga ima i printamo u konzolu
    signIn(_email, _password, userExist) async {
      final _formState = _formKey.currentState;
      if (_formState.validate()) {
        try {
          AuthResult result = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          FirebaseUser user = result.user;
          String userEmail = user.email;
          userID = user.uid;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ShowLoading(user: user, email: userEmail, userID: userID)));
        } catch (e) {
          err = e.message;
        }
      }
    }

    return RaisedButton(
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

      color: StyleColors().blueColor,

      // na press btn-a
      onPressed:
          // provjera internet konekcije

          () async {
        try {
          final result = await InternetAddress.lookup('google.com');

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
        } on SocketException catch (_) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoInternetConnectionLogInSrceen()));
        }

        // zatvaranje tastature na klik dugmeta

        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        // provjera da li su oba polja prazna -> email && password

        if (_email == '' && _password == '') {
          if (onceToast == 0) {
            SnackBar1(message: 'Oba polja su prazna');

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
            signIn(_email, _password, userExist);
            onceBtnPressed = 1;
          }
        }
      },
    );
  }
}
