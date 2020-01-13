import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/components/loadingScreens/loading.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class SignInMethods {
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
  signIn(
    String _email, 
    String _password, 
    GlobalKey<FormState> _formKey,
    String userID,
    String err,
    BuildContext context
    ) async {
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
