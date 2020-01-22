import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:spediter/components/crud/firebaseCrud.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/components/noInternetConnectionScreen/noInternetOnLogin.dart';
import 'package:spediter/components/routingAndChecking.dart';
import 'package:spediter/components/vehicle.dart';
import 'package:spediter/screens/userScreens/usersHome.dart';
import 'package:spediter/theme/style.dart';
import 'package:spediter/utils/screenUtils.dart';
import 'package:flutter/rendering.dart';
import 'interdestinatonForm.dart';

void main() => runApp(CreateRoute());

class CreateRoute extends StatelessWidget {
  final String userID;
  CreateRoute({this.userID});
  // This widget is the root of your application.
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
        const Locale('bs'), // Bosnian
        const Locale('en'), // English
      ],
      home: CreateRouteScreenPage(userID: userID),
    );
  }
}

class CreateRouteScreenPage extends StatefulWidget {
  final String userID;
  CreateRouteScreenPage({Key key, this.userID}) : super(key: key);

  @override
  _CreateRouteScreenPageState createState() =>
      _CreateRouteScreenPageState(userID: userID);
}

class _CreateRouteScreenPageState extends State<CreateRouteScreenPage> {
  /// lista medjudestinacija
  List<InterdestinationForm> interdestinations = [];

  _CreateRouteScreenPageState({this.userID});

  /// VARIJABLE

  final format = DateFormat.MMMMd('bs');
  final formatTime = DateFormat("HH:mm");
  final formatP = DateFormat('yyyy-MM-dd');

  /// key za formu
  final _formKey = GlobalKey<FormState>();

  /// instanca za bazu
  final db = Firestore.instance;

  /// fokusi

  /// fokus za krajnju destinaciju
  var focusPercentage = new FocusNode();
  var focusCapacity = new FocusNode();
  var focusGoods = new FocusNode();
  var focusDimensions = new FocusNode();
  var focusStarting = new FocusNode();
  var focusEnding = new FocusNode();

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  ///maska za tone  0.0
  var controller = new MaskedTextController(
    mask: '0.0',
  );

  var percentageController = new MaskedTextController(mask: '000');

  /// Stringovi
  String userUid;
  String userID;
  String id;
  String listOfInterdestinations = "";
  String goodsVar = '',
      dimensionsVar = '',
      selectedDateStringP,
      selectedDateStringD,
      endingDestination,
      startingDestination,
      vehicleVar,
      stringKonacnoP,
      stringKonacnoD,
      timeP,
      formatted,
      formatted2,
      timeD,
      arrivalTimestamp,
      companyName1,
      urlLogo;
  int percentageVar;
  String capacityVar;
  String t11;
  String t22;

  /// DateTime tip datuma (radi validacije)
  DateTime selectedDateP;
  DateTime selectedDateD;
  DateTime t1;
  DateTime t2;

  /// Timestamp var [unos u bazu zbog ordera ispisa]
  int dateOfSubmit = DateTime.now().millisecondsSinceEpoch;

  /// counteri za velicinu ekrana (responsive)
  /// i za postojanje ruta kod kompanije
  bool _screenUtilActive = true;
  bool imaliRuta = true;

  /// DROPDOWN LISTA VOZILA
  List<Vehicle> _vehicle = Vehicle.getVehicle();
  List<DropdownMenuItem<Vehicle>> _dropdownMenuItems;
  Vehicle _selectedVehicle;

  /// counter da li je btn diiseblan ili ne
  bool _isBtnDisabled = true;

  /// initState metoda - lifecycle metoda koja se izvrsi prije nego se load-a sam screen
  /// u njoj pozivamo metodu [getUserID()] , seta mo [Toast] counter na 0,
  /// ubacujemo u dropdown listu [_dropdownMenuItems] vozila,
  /// aktiviramo [BackButtonInterceptor] i dodajemo mu f-ju [myInterceptor]
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_vehicle);
    super.initState();
    getUserid();
    onceToast = 0;
    // BackButtonInterceptor.add(myInterceptor);
  }

  /// lista vozila
  List<DropdownMenuItem<Vehicle>> buildDropdownMenuItems(List vehicles) {
    List<DropdownMenuItem<Vehicle>> items = List();
    for (Vehicle vehicle in vehicles) {
      items.add(DropdownMenuItem(value: vehicle, child: Text(vehicle.name)));
    }
    return items;
  }

  /// onDelete f-ja za interdestinacije
  @override
  Widget build(BuildContext context) {
    /// RESPONSIVE
    ///
    /// iz klase [ScreenUtils]
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            RouteAndCheck().checkAndNavigate(context, userID);
          },
        ),
        title: const Text('Kreiranje Rute',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body:

          /// GestureDetector na osnovu kojeg zavaramo tastaturu na klik izvan njenog prostora
          Builder(
        builder: (context) => new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            onceToast = 0;
          },
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// POCETAK FORME
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        ///DATUM I VRIJEME POLASKA
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 8, left: 16.0, right: 16.0, top: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(15.0)),
                                    resetIcon: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                      hintText: 'Datum polaska',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                    format: format,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      DateTime picked = await showDatePicker(
                                          locale: Locale('bs'),
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2018),
                                          lastDate: DateTime(2100));
                                      if (picked == null) {
                                        picked = DateTime.now();
                                        _isBtnDisabled = false;
                                      }

                                      setState(() {
                                        selectedDateP = picked;
                                        if (selectedDateP == null) {
                                          selectedDateP = DateTime.now();
                                          _isBtnDisabled = false;

                                        } else {
                                          selectedDateP = picked;
                                          _isBtnDisabled = false;

                                        }
                                      });
                                      setState(() {
                                        formatted =
                                            formatP.format(selectedDateP);
                                        if (selectedDateP == null) {
                                          selectedDateP = DateTime.now();
                                          _isBtnDisabled = false;
                                        } else {
                                          selectedDateP = picked;
                                          _isBtnDisabled = false;
                                        }
                                      });
                                      return selectedDateP;
                                    },
                                    onChanged: (input) {
                                      print(formatted);
                                      print(selectedDateP);
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      _isBtnDisabled = false;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  margin:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    resetIcon: null,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(15.0)),
                                    //textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: "Vrijeme polaska",
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                    ),
                                    format: formatTime,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      setState(() {
                                        timeP = time.toString();
                                        _isBtnDisabled = false;
                                      });
                                      if (timeP == 'null') {
                                        timeP = '';
                                        _isBtnDisabled = false;
                                      } else if (timeP != 'null') {
                                        _isBtnDisabled = false;
                                        return DateTimeField.convert(time);
                                      }
                                    },
                                    onChanged: (input) {
                                      t2 = input;
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      _isBtnDisabled = false;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DESTINACIJA POLASKA
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
                                      margin: EdgeInsets.only(
                                          left: 9, bottom: 8, right: 5),
                                      height: 36,
                                      child: TextFormField(
                                        maxLength: 32,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            hasFloatingPlaceholder: false,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.12))),
                                            labelText: 'Startna destinacija',
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        onChanged: (input) {
                                          setState(() {
                                            onceToast = 0;
                                            onceBtnPressed = 0;
                                            startingDestination = input;
                                            areFieldsEmpty();
                                          });
                                        },
                                      )))
                            ])),

                        /// MEDJUDESTINACIJA
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      addAutomaticKeepAlives: true,
                                      itemCount: interdestinations.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return interdestinations[index];
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),

                        FutureBuilder(
                          future: getPosts123(userID),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    companyName = snapshot
                                        .data[index].data['company_name'];
                                    urlLogo =
                                        snapshot.data[index].data['url_logo'];

                                    return SizedBox();
                                  });
                            }
                            return SizedBox();
                          },
                        ),

                        ///KRAJNJA DESTINACIJA
                        Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      DestinationLine(),
                                      DestinationCircle(
                                        largeCircle:
                                            StyleColors().destinationCircle2,
                                        smallCircle:
                                            StyleColors().destinationCircle1,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 9, bottom: 8, right: 5),
                                      height: 36,
                                      child: TextFormField(
                                        maxLength: 32,
                                        onTap: onAddForm,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            hasFloatingPlaceholder: false,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.12))),
                                            labelText: 'Krajnja destinacija',
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        onChanged: (input) {
                                          setState(() {
                                            onceToast = 0;
                                            onceBtnPressed = 0;
                                            endingDestination = input;
                                            areFieldsEmpty();
                                          });
                                        },
                                      )))
                            ])),

                        /// DATUM I VRIJEME DOLASKA
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 11.5, left: 16.0, right: 16.0, top: 2),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    resetIcon: null,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(15.0)),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                      hintText: 'Datum dolaska',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                    format: format,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      DateTime picked = await showDatePicker(
                                          locale: Locale('bs'),
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2018),
                                          lastDate: DateTime(2100));
                                      if (picked == null) {
                                        picked = DateTime.now();
                                        _isBtnDisabled = false;
                                      }
                                      setState(() {
                                        selectedDateD = picked;
                                        if (selectedDateD == null) {
                                          selectedDateD = DateTime.now();
                                          _isBtnDisabled = false;
                                        } else {
                                          selectedDateD = picked;
                                          _isBtnDisabled = false;
                                        }
                                      });
                                      setState(() {
                                        formatted2 =
                                            formatP.format(selectedDateD);
                                        if (selectedDateD == null) {
                                          selectedDateD = DateTime.now();
                                          _isBtnDisabled = false;
                                        } else {
                                          selectedDateD = picked;
                                          _isBtnDisabled = false;
                                        }
                                      });
                                      return selectedDateD;
                                    },
                                    onChanged: (input) {
                                      print(formatted2);
                                      print(selectedDateD);
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      _isBtnDisabled = false;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  margin:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    resetIcon: null,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(15.0)),
                                    decoration: InputDecoration(
                                        hintText: "Vrijeme dolaska",
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.12)),
                                        )),
                                    format: formatTime,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time1 = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      setState(() {
                                        timeD = time1.toString();
                                        _isBtnDisabled = false;
                                      });
                                      if (timeD == 'null') {
                                        timeD = '';
                                        _isBtnDisabled = false;
                                      } else if (timeD != 'null') {
                                        _isBtnDisabled = false;
                                        return DateTimeField.convert(time1);
                                      }
                                    },
                                    onChanged: (input) {
                                      t1 = input;
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      _isBtnDisabled = false;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DIVIDER
                        Divider1(
                          thickness: 1,
                          height: 1,
                        ),
                        Divider1(
                          thickness: 8,
                          height: 8,
                        ),

                        /// Popunjenost u procentimaaaaaaaaaaaaaaaaa
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 2, left: 16.0, right: 16.0, top: 11.5),
                          child: TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            controller: percentageController,
                            focusNode: focusPercentage,
                            decoration: InputDecoration(
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
                                labelText: 'Popunjenost u procentima',
                                hintText: '0 - 100',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                if (input != '') {
                                  percentageVar = int.parse(input);
                                } else {
                                  percentageVar = null;
                                }
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),
                        ////// kapacitet u tonamaaaaaaaa
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                          child: TextFormField(
                            maxLength: 3,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            controller: controller,
                            focusNode: focusCapacity,
                            decoration: InputDecoration(
                              counterText: '',
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
                                labelText: 'Kapacitet u tonama',
                                hintText: '1.5',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              print(input);
                              setState(() {
                                capacityVar = input;

                                double capacityDouble =
                                    double.parse(capacityVar);
                                if (capacityDouble >= 10) {
                                  capacityDouble = capacityDouble / 10.0;
                                }
                                capacityVar = capacityDouble.toString();

                                print(capacityVar);
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        /// VRSTE VOZILAAAA

                        ResponsiveContainer(
                          heightPercent:
                              (68.0 / MediaQuery.of(context).size.height) * 100,
                          widthPercent: 100.0,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Color.fromRGBO(0, 0, 0, 0.12)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5.0),
                              child: DropdownButton(
                                // JUSUF - Izbacio ubacio hint i disabledHint:
                                hint: Text('Vrsta Vozila'),
                                disabledHint: Text('Vrsta Vozila'),
                                value: _selectedVehicle,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Roboto",
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                isExpanded: true,
                                items: _dropdownMenuItems,
                                underline: Container(color: Colors.white),
                                onChanged: onChangeDropdownItem,
                              ),
                            ),
                          ),
                        ),

                        // VRSTE ROBEEEEEEEEEE
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusGoods,
                            decoration: InputDecoration(
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
                                labelText: 'Vrsta robe',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                goodsVar = input;
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        ///DIMENZIJEEE
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 8),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusDimensions,
                            decoration: InputDecoration(
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
                                labelText: 'Dimenzije',
                                hintText: '16m x 2.5m x 3m',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                dimensionsVar = input;
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        /// BUTTOON
                        Container(
                          margin: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 56.0,
                            top: 8,
                          ),
                          height: 50,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: RaisedButton(
                                disabledColor: Color.fromRGBO(219, 219, 219, 1),
                                disabledTextColor: Color.fromRGBO(0, 0, 0, 1),
                                color: Color.fromRGBO(3, 54, 255, 1),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  'KREIRAJ RUTU',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: _isBtnDisabled
                                    ? null
                                    : () async {
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }

                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');

                                          if (result.isNotEmpty &&
                                              result[0]
                                                  .rawAddress
                                                  .isNotEmpty) {}
                                        } on SocketException catch (_) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoInternetConnectionLogInSrceen()));
                                        }

                                        /// VALIDACIJA POLJA
                                        if (percentageVar < 0 ||
                                            percentageVar > 100) {
                                          if (onceToast == 0) {
                                            final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Color.fromRGBO(
                                                  28, 28, 28, 1.0),
                                              content: Text(
                                                  'Unesite broj od 0 do 100'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                            onceToast = 1;
                                            Timer(Duration(seconds: 2), () {
                                              onceToast = 0;
                                            });
                                          }
                                        } else {
                                          validateDatesAndTimes(context);
                                        }
                                      }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        // ),]
      ),
    );
  }

  void onDelete(Interdestination _interdestination) {
    setState(() {
      var find = interdestinations.firstWhere(
        (it) => it.interdestination == _interdestination,
        orElse: () => null,
      );
      if (find != null)
        interdestinations.removeAt(interdestinations.indexOf(find));
    });
  }

  /// onAddForm f-ja pomocu koje dodajemo novu interdestinaciju
  ///
  /// setState u kojem prosljedjujemo metodu onDelete i onAdd
  void onAddForm() {
    setState(() {
      var _interdestination = Interdestination();
      interdestinations.add(InterdestinationForm(
        interdestination: _interdestination,
        onDelete: () => onDelete(_interdestination),
        onAdd: () => onAddForm(),
      ));
    });
  }

  validateDatesAndTimes(BuildContext context) {
    t11 = DateFormat.Hm().format(t1);
    t22 = DateFormat.Hm().format(t2);
    DateTime now = DateTime.now();

    arrivalTimestamp = formatted2 + ' ' + t11;
    int aTimestamp = DateTime.parse(arrivalTimestamp).millisecondsSinceEpoch;

    selectedDateP = new DateTime(
        selectedDateP.year, selectedDateP.month, selectedDateP.day);
    selectedDateD = new DateTime(
        selectedDateD.year, selectedDateD.month, selectedDateD.day);
    if (selectedDateD.isBefore(selectedDateP)) {
      print('Datum dolaska ne može biti manji od datuma polaska.');
      if (onceToast == 0) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content: Text('Datum polaska ne može biti veći od datuma dolaska.'),
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
    } else if (selectedDateP.isAtSameMomentAs(selectedDateD)) {
      if (DateFormat.Hm().format(t2).compareTo(DateFormat.Hm().format(t1)) >
          0) {
        print(
            'Vrijeme polaska ne može biti veće od vremena dolaska, ako su datumi jednaki.');
        if (onceToast == 0) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
            content: Text(
                'Vrijeme polaska ne može biti veće od vremena dolaska, ako su datumi jednaki.'),
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
      } else if (DateFormat.Hm()
              .format(t2)
              .compareTo(DateFormat.Hm().format(t1)) ==
          0) {
        print('Datumi i vremena ne mogu biti jednaki.');
        if (onceToast == 0) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
            content: Text('Datumi i vremena ne mogu biti jednaki.'),
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
      } else {
        print('Validacija ispravna');
        if (onceBtnPressed == 0) {
          print('btn kreiraj');
          onSave();
          FirebaseCrud().createData(
              percentageVar,
              capacityVar,
              endingDestination,
              startingDestination,
              formatted,
              formatted2,
              t11,
              t22,
              dimensionsVar,
              goodsVar,
              vehicleVar,
              userID,
              listOfInterdestinations,
              dateOfSubmit,
              aTimestamp,
              companyName1,
              urlLogo,
              context);
          onceBtnPressed = 1;
        }
      }
    } else if (selectedDateD.isBefore(DateTime(now.year, now.month, now.day))) {
      print('Datum dolaska ne može biti manji od današnjeg datuma.');
      if (onceToast == 0) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content:
              Text('Datum dolaska ne može biti manji od današnjeg datuma.'),
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
    } else if (selectedDateD
        .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      if (DateFormat.Hm()
              .format(t1)
              .compareTo(DateFormat.Hm().format(DateTime.now())) <
          0) {
        print(
            'Vrijeme dolaska ne može biti manji od trenutnog vremena, ako je datum dolaska jednako današnjem datumu.');
        if (onceToast == 0) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
            content: Text(
                'Datum dolaska je jednak današnjem datumu, ali vrijeme dolaska ne može biti manje od trenutnog vremena.'),
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
      } else if (DateFormat.Hm()
              .format(t1)
              .compareTo(DateFormat.Hm().format(DateTime.now())) ==
          0) {
        print(
            'Vrijeme dolaska ne može biti jednako trenutnom vremenu, ako je datum dolaska jednak današnjem datumu.');
        if (onceToast == 0) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
            content: Text(
                'Datum dolaska i vrijeme dolaska ne mogu biti jednaki današnjem datumu i trenutnom vremenu.'),
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
      } else {
        print('Validacija ispravna');
        if (onceBtnPressed == 0) {
          print('btn kreiraj');
          onSave();
          FirebaseCrud().createData(
              percentageVar,
              capacityVar,
              endingDestination,
              startingDestination,
              formatted,
              formatted2,
              t11,
              t22,
              dimensionsVar,
              goodsVar,
              vehicleVar,
              userID,
              listOfInterdestinations,
              dateOfSubmit,
              aTimestamp,
              companyName1,
              urlLogo,
              context);
          onceBtnPressed = 1;
        }
      }
    } else {
      print('Validacija ispravna');
      if (onceBtnPressed == 0) {
        print('btn kreiraj');
        onSave();
        FirebaseCrud().createData(
            percentageVar,
            capacityVar,
            endingDestination,
            startingDestination,
            formatted,
            formatted2,
            t11,
            t22,
            dimensionsVar,
            goodsVar,
            vehicleVar,
            userID,
            listOfInterdestinations,
            dateOfSubmit,
            aTimestamp,
            companyName1,
            urlLogo,
            context);
        onceBtnPressed = 1;
      }
    }
  }

  Future getPosts123(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Company')
        .where('company_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }

  /// metoda koja provjerava da li je aktivan counter za screen aktivan
  setScreenSize() {
    if (!_screenUtilActive)
      Constant.setScreenAwareConstant(context);
    else
      Constant.setDefaultSize(context);
    setState(() {
      _screenUtilActive = !_screenUtilActive;
    });
  }

  /// metoda pomocu koje uzimamo ID od trenutno logovane kompanije/usera
  ///
  /// ulazimo u [Auth] dio firebase i na osnovu toga izvlacimo sve info o user u nasem slucaju kompaniji
  /// nakon cega dohvatamo kolekciju [LoggedUsers] i uzimamo [user.uid] i spremamo ga u varijablu [userID]
  getUserid() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    Firestore.instance
        .collection('LoggedUsers')
        .document(user.uid)
        .snapshots()
        .toString();
    userID = user.uid;
  }

  ///on save forms
  void onSave() {
    if (interdestinations.length > 0) {
      var allValid = true;
      interdestinations.forEach((form) => allValid = allValid);
      if (allValid) {
        var data = interdestinations.map((it) => it.interdestination).toList();
        print(data.length);
        for (int i = 0; i < data.length; i++) {
          if ('${data[i].interdestinationData}' != '')
            listOfInterdestinations += '${data[i].interdestinationData}, ';
          else
            listOfInterdestinations += '';
        }
      }
    }
  }

// funckija koja provjerava da li su polja prazna i enable/disable btn
  void areFieldsEmpty() {
    if ((percentageVar != null) &&
        (dimensionsVar != '' && dimensionsVar != null) &&
        (capacityVar != null && capacityVar != '') &&
        //(goodsVar != '' && goodsVar != null) &&
        (endingDestination != '' && endingDestination != null) &&
        (startingDestination != '' && startingDestination != null) &&
        (selectedDateD != null) &&
        (selectedDateP != null) &&
        (timeD != null && timeD != '' && timeD != 'Vrijeme dolaska') &&
        (timeP != null && timeP != '' && timeP != 'Vrijeme polaska') &&
        (_selectedVehicle != null)) {
      _isBtnDisabled = false;
    } else {
      _isBtnDisabled = true;
    }
  }

  /// na promjenu dropdown-a
  onChangeDropdownItem(Vehicle vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      vehicleVar = _selectedVehicle.name;
    });
    onceToast = 0;
    onceBtnPressed = 0;
    areFieldsEmpty();
    FocusScope.of(context).requestFocus(focusGoods);
  }
}
