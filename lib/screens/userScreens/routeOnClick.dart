import 'package:flutter/material.dart';
 
void main() => runApp(RouteOnClick());
 
class RouteOnClick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
             /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
            // RouteAndCheck().checkAndNavigate(context, userID);
          },
        ),
        title: const Text('Truck Logistic',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body: Column(
         children: <Widget>[
           Container(
              height: 90,
              width: 380,
              color: Colors.blue,
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Container(
                margin: EdgeInsets.only(left: 10,top: 5),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Polazak iz Sarajeva',
                    style: TextStyle(
                       color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400),),
                    Text('Ponedjeljak, 24. Februar',
                    style: TextStyle(
                       color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),),
                    Text('14:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 19,
                      fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
           ),
           Container(
              height: 42,
              width: 380,
              color: Colors.grey,
              margin: EdgeInsets.only(left: 10,right: 10,),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Zvornik')
                  ],
                ),
              ),
           ),
           Container(
              height: 43,
              width: 380,
              color: Colors.grey,
              margin: EdgeInsets.only(left: 10,right: 10,),
               child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Loznica')
                  ],
                ),
              ),
           ),
           Container(
              height: 43,
              width: 380,
              color: Colors.grey,
              margin: EdgeInsets.only(left: 10,right: 10,),
               child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Šabac')
                  ],
                ),
              ),
           ),
          Container(
              height: 90,
              width: 380,
              color: Colors.red,
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Container(
                margin: EdgeInsets.only(left: 10,top: 5),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Zadnja destinacija Beograd',
                    style: TextStyle(
                       color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400),),
                    Text('Utorak, 25. Februar',
                    style: TextStyle(
                       color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),),
                    Text('16:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 19,
                      fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
           ),
         ],
      ),
      );
  }
}