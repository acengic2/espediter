import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spediter/screens/singIn/components/form.dart';
import 'package:spediter/screens/singIn/components/logo.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreiraj Rutu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        // ... lokalizacija jezika
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('bs', null), // Bosnian
        const Locale('en'), // English
      ],
      home: Scaffold(
        // prazan prostor prilikom podizanja tastature
        resizeToAvoidBottomPadding: false,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 72.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Logo and Headline
                      Logo(),
                      // column -> forma za popunjavanje email-a i passworda
                      FormLogIn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), //  detektor klika za zatvaranje tastature
      ),
    );
  }
}
