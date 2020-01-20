import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:spediter/components/crud/firebaseCrud.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/components/divider.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/components/noInternetConnectionScreen/noInternetOnLogin.dart';
import 'package:spediter/screens/companyScreens/createRoute/createRouteScreen.dart';

import 'package:spediter/screens/companyScreens/editCompany/interdestinationEditForm.dart';
import 'package:spediter/theme/style.dart';
import 'package:spediter/utils/screenUtils.dart';

class EditRouteForm extends StatefulWidget {
  final DocumentSnapshot post;
  final String userID;

  EditRouteForm({this.post, this.userID});

  @override
  _EditRouteFormState createState() => _EditRouteFormState();
}

class _EditRouteFormState extends State<EditRouteForm> {
  final DocumentSnapshot post;
  String userID;
  _EditRouteFormState({this.post, this.userID});

  /// lista medjudestinacija
  List<InterdestinationEditForm> interdestinations = [];

  /// VARIJABLE
  ///
  /// formati za datume
  /// jezik i ispis na kartici
  /// format za vrijeme
  /// format za datum - upis u bazu prilikom preuzimanja
  final format = DateFormat.MMMMd('bs');
  final formatTime = DateFormat("HH:mm");
  final formatP = DateFormat('yyyy-MM-dd');

  var _textController = TextEditingController();

  /// key za formu
  final _formKey = GlobalKey<FormState>();

  /// Timestamp var [unos u bazu zbog ordera ispisa]
  int dateOfSubmit = DateTime.now().millisecondsSinceEpoch;

  /// instanca za bazu
  final db = Firestore.instance;

  /// fokusi
  var focusPercentage = new FocusNode();
  var focusCapacity = new FocusNode();
  var focusGoods = new FocusNode();
  var focusDimensions = new FocusNode();
  var focusStarting = new FocusNode();
  var focusEnding = new FocusNode();
  var focusInterdestination = new FocusNode();

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  // var percentageController = new MaskedTextController(mask: '000');

  /// Stringovi
  String userUid;

  String id;
  String listOfInterdestinations = "";
  String goodsVar,
      dimensionsVar,
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
      timeD;
  int percentageVar;
  String capacityVar;
  String t11;
  String t22;
  String inter;
  static String datumA = '1996-03-11';
  static String vrijemeA = '09:00';

  int arrivalT = DateTime.parse(datumA + ' ' + vrijemeA).millisecondsSinceEpoch;
  List<String> interdestinacije;

  double capacityDouble;

  /// DateTime tip datuma (radi validacije)
  DateTime selectedDateP;
  DateTime selectedDateD;
  DateTime t1;
  DateTime t2;

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
  /// u njoj pozivamo metodu [getUserID()] , setamo [Toast] counter na 0,
  /// ubacujemo u dropdown listu [_dropdownMenuItems] vozila,

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_vehicle);
    super.initState();
    getUserid();
    onceToast = 0;
    populateTheVariables();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
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
                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: DateTimeField(
                                  initialValue: DateTime.parse(formatted),
                                  textCapitalization: TextCapitalization.words,
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
                                          color: StyleColors().textColorGray12),
                                    ),
                                    hintText: 'Datum polaska',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
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
                                    print(formatted);
                                    onceToast = 0;
                                    onceBtnPressed = 0;
                                    areFieldsEmpty();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 36.0,
                                margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: DateTimeField(
                                  initialValue:
                                      DateTime.parse(formatted + ' ' + t22),
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
                                          color: StyleColors().textColorGray12),
                                    ),
                                  ),
                                  format: formatTime,
                                  onShowPicker: (context, currentValue) async {
                                    // currentValue = DateTime.now();s
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    setState(() {
                                      timeP = time.toString();
                                    });
                                    if (timeP == 'null') {
                                      timeP = '';
                                    } else if (timeP != 'null') {
                                      return DateTimeField.convert(time);
                                    }
                                  },
                                  onChanged: (input) {
                                    t2 = input;
                                    t22 = DateFormat.Hm().format(t2);
                                    onceToast = 0;
                                    onceBtnPressed = 0;
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
                          margin: EdgeInsets.only(
                              bottom: 2, left: 16.0, right: 16.0, top: 2),
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
                                      initialValue: startingDestination,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          hasFloatingPlaceholder: false,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: StyleColors()
                                                    .textColorGray12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: StyleColors()
                                                      .textColorGray12)),
                                          labelText: 'Startna destinacija',
                                          labelStyle: TextStyle(
                                              color: StyleColors()
                                                  .textColorGray50),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
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
                          
                      getInterdestinations(),

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

                      ///KRAJNJA DESTINACIJA
                      Container(
                          margin: EdgeInsets.only(
                              bottom: 2, left: 16.0, right: 16.0, top: 2),
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
                                      initialValue: endingDestination,
                                      onTap: onAddForm,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          hasFloatingPlaceholder: false,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: StyleColors()
                                                    .textColorGray12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: StyleColors()
                                                      .textColorGray12)),
                                          labelText: 'Krajnja destinacija',
                                          labelStyle: TextStyle(
                                              color: StyleColors()
                                                  .textColorGray50),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
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
                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: DateTimeField(
                                  initialValue: DateTime.parse(formatted2),
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
                                          color: StyleColors().textColorGray12),
                                    ),
                                    hintText: 'Datum dolaska',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
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
                                      selectedDateD = picked;
                                      if (selectedDateD == null) {
                                        selectedDateD = DateTime.now();
                                      } else {
                                        selectedDateD = picked;
                                      }
                                    });
                                    setState(() {
                                      formatted2 =
                                          formatP.format(selectedDateD);
                                      if (selectedDateD == null) {
                                        selectedDateD = DateTime.now();
                                      } else {
                                        selectedDateD = picked;
                                      }
                                    });
                                    return selectedDateD;
                                  },
                                  onChanged: (input) {
                                    onceToast = 0;
                                    onceBtnPressed = 0;
                                    areFieldsEmpty();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 36.0,
                                margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: DateTimeField(
                                  initialValue:
                                      DateTime.parse(formatted2 + ' ' + t11),
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
                                            color:
                                                StyleColors().textColorGray12),
                                      )),
                                  format: formatTime,
                                  onShowPicker: (context, currentValue) async {
                                    final time1 = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    setState(() {
                                      timeD = time1.toString();
                                    });
                                    if (timeD == 'null') {
                                      timeD = '';
                                    } else if (timeD != 'null') {
                                      return DateTimeField.convert(time1);
                                    }
                                  },
                                  onChanged: (input) {
                                    t1 = input;
                                    t11 = DateFormat.Hm().format(t1);
                                    onceToast = 0;
                                    onceBtnPressed = 0;
                                    areFieldsEmpty();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// DIVIDER
                      Divider1(thickness: 1, height: 1),
                      Divider1(thickness: 8, height: 8),

                      /// Popunjenost u procentimaaaaaaaaaaaaaaaaa
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 2, left: 16.0, right: 16.0, top: 11.5),
                        child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          // controller: controllerAvail,
                          initialValue: widget.post.data['availability'],
                          focusNode: focusPercentage,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: StyleColors().textColorGray12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: StyleColors().textColorGray12)),
                              labelText: 'Popunjenost u procentima',
                              hintText: '0-100',
                              labelStyle: TextStyle(
                                  color: StyleColors().textColorGray50),
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
                          initialValue: widget.post.data['capacity'],
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          // controller: controller,
                          focusNode: focusCapacity,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: StyleColors().textColorGray12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: StyleColors().textColorGray12)),
                              labelText: 'Kapacitet u tonama',
                              hintText: '1.5',
                              labelStyle: TextStyle(
                                  color: StyleColors().textColorGray50),
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          onChanged: (input) {
                            setState(() {
                              capacityVar = input;
                              if (capacityVar.contains(',')) {
                                capacityVar =
                                    capacityVar.replaceFirst(',', '.');
                              }
                              capacityDouble = double.parse(capacityVar);
                              if (capacityDouble >= 10) {
                                capacityDouble = capacityDouble / 10.0;
                              }
                              capacityVar = capacityDouble.toString();
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
                                  color: StyleColors().textColorGray12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: DropdownButton(
                              hint: Text(widget.post.data['vehicle']),
                              disabledHint: Text('Vrsta Vozila'),
                              value: _selectedVehicle,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Roboto",
                                  color: StyleColors().textColorGray50),
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
                          initialValue: widget.post.data['goods'],
                          focusNode: focusGoods,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: StyleColors().textColorGray12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: StyleColors().textColorGray12)),
                              labelText: 'Vrsta robe',
                              labelStyle: TextStyle(
                                  color: StyleColors().textColorGray50),
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
                          initialValue: dimensionsVar,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: focusDimensions,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(
                                    color: StyleColors().textColorGray12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: StyleColors().textColorGray12)),
                              labelText: 'Dimenzije',
                              hintText: '16m x 2.5m x 3m',
                              labelStyle: TextStyle(
                                  color: StyleColors().textColorGray50),
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          onChanged: (input) {
                            if (input == null) {
                              setState(() {
                                dimensionsVar = widget.post.data['dimensions'];
                              });
                            } else {
                              setState(() {
                                dimensionsVar = input;
                              });
                            }

                            onceToast = 0;
                            onceBtnPressed = 0;
                            areFieldsEmpty();
                          },
                        ),
                      ),

                      /// BUTTOON
                      Container(
                        margin: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
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
                                'SAČUVAJ PROMJENE',
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
                                            result[0].rawAddress.isNotEmpty) {}
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
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
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
                                      }
                                      else {
                                        if (onceBtnPressed == 0) {
                                          validateDatesAndTimes(context);
                                        }
                                      }
                                    }),
                        ),
                      ),

                      /// BUTTOON
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          left: 16.0,
                          right: 16.0,
                          bottom: 56.0,
                        ),
                        height: 50,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: RaisedButton(
                              disabledColor: Color.fromRGBO(219, 219, 219, 1),
                              disabledTextColor: Color.fromRGBO(0, 0, 0, 1),
                              color: Color.fromRGBO(174, 7, 37, 1),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                'ZAVRŠITE RUTU',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {
                                if (onceBtnPressed == 0) {
                                  //onSave();
                                  FirebaseCrud().finishRoute(arrivalT, widget.post, context, userID);
                                  onceBtnPressed = 1;
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      // ),]
    );
  }

  validateDatesAndTimes(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime departureDateTime = DateTime.parse(formatted + ' ' + t22);
    DateTime arrivalDateTime = DateTime.parse(formatted2 + ' ' + t11);
    print(departureDateTime);
    print(arrivalDateTime);
    print(departureDateTime.isBefore(arrivalDateTime));
    if (arrivalDateTime.isBefore(departureDateTime)) {
      print(
          'Datum i vrijeme dolaska ne mogu biti prije datuma i vremena polaska.');
      if (onceToast == 0) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content: Text(
              'Datum i vrijeme dolaska ne mogu biti prije datuma i vremena polaska.'),
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
    } else if (departureDateTime.isAtSameMomentAs(arrivalDateTime)) {
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
    } else if (arrivalDateTime.isBefore(now)) {
      print(
          'Datum i vrijeme dolaska ne mogu biti prije današnjeg datuma i sadašnjeg vremena.');
      if (onceToast == 0) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content: Text(
              'Datum i vrijeme dolaska ne mogu biti prije današnjeg datuma i sadašnjeg vremena.'),
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
    } else if (arrivalDateTime.isAtSameMomentAs(now)) {
      print(
          'Datum i vrijeme dolaska ne mogu biti jednaki današnjem datumu i sadašnjem vremenu.');
      if (onceToast == 0) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
          content: Text(
              'Datum i vrijeme dolaska ne mogu biti jednaki današnjem datumu i sadašnjem vremenu.'),
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
        onSave();
        FirebaseCrud().updateData(
            widget.post,
            percentageVar,
            capacityVar,
            endingDestination,
            startingDestination,
            inter,
            formatted,
            formatted2,
            t11,
            t22,
            dimensionsVar,
            goodsVar,
            vehicleVar,
            userID,
            dateOfSubmit,
            context);
        onceBtnPressed = 1;
      }
    }
  }

  Widget getInterdestinations() {
    inter = widget.post.data['interdestination'];

    if (inter == '') {
      return Container(
        height: 0,
        width: 0,
      );
    } else {
      inter = inter.substring(0, inter.length - 2);

      interdestinacije = inter.split(', ');
      var _interdestination = Interdestination();
      return Column(
          children: interdestinacije
              .map((item) => InterdestinationEditForm(
                    item: item,
                    interdestination: _interdestination,
                    onDelete: () => onDelete(_interdestination),
                    onAdd: () => onAddForm(),
                  ))
              .toList());
    }
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
    _isBtnDisabled = false;

  }


  /// onAddForm f-ja pomocu koje dodajemo novu interdestinaciju
  ///
  /// setState u kojem prosljedjujemo metodu onDelete i onAdd
  void onAddForm() {
    setState(() {
      var _interdestination = Interdestination();
      interdestinations.add(InterdestinationEditForm(
        interdestination: _interdestination,
        onDelete: () => onDelete(_interdestination),
        onAdd: () => onAddForm(),
      ));
    });
    _isBtnDisabled = false;
  }

  ///on save forms
  void onSave() {
    if (interdestinations.length > 0) {
      var data = interdestinations.map((it) => it.interdestination).toList();
      for (int i = 0; i < data.length; i++) {
        if ('${data[i].interdestinationData}' != '')
          listOfInterdestinations += '${data[i].interdestinationData}, ';
        else
          listOfInterdestinations += '';
      }
    }
    inter = inter + ", " + listOfInterdestinations;
    print(inter + " DaAAAAAaaa");
  }

  // funckija koja provjerava da li su polja prazna i enable/disable btn
  areFieldsEmpty() {
    if ((percentageVar != null) ||
        (dimensionsVar != '' && dimensionsVar != null) ||
        (capacityVar != null && capacityVar != '') ||
        (goodsVar != '' && goodsVar != null) ||
        (endingDestination != '' && endingDestination != null) ||
        (startingDestination != '' && startingDestination != null) ||
        (selectedDateD != null) ||
        (selectedDateP != null) ||
        (timeD != null && timeD != '' && timeD != 'Vrijeme dolaska') ||
        (timeP != null && timeP != '' && timeP != 'Vrijeme polaska') ||
        (_selectedVehicle != null)) {
      _isBtnDisabled = false;
    } else {
      _isBtnDisabled = true;
    }
  }

  populateTheVariables() {
    formatted = widget.post.data['departure_date'];
    t22 = widget.post.data['departure_time'];
    startingDestination = widget.post.data['starting_destination'];
    endingDestination = widget.post.data['ending_destination'];
    formatted2 = widget.post.data['arrival_date'];
    t11 = widget.post.data['arrival_time'];
    percentageVar = int.parse(widget.post.data['availability']);
    capacityVar = widget.post.data['capacity'];
    vehicleVar = widget.post.data['vehicle'];
    goodsVar = widget.post.data['goods'];
    dimensionsVar = widget.post.data['dimensions'];
  }

  ///dispose back btn-a nakon njegovog koristenja
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
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

  /// lista vozila
  List<DropdownMenuItem<Vehicle>> buildDropdownMenuItems(List vehicles) {
    List<DropdownMenuItem<Vehicle>> items = List();
    for (Vehicle vehicle in vehicles) {
      items.add(DropdownMenuItem(value: vehicle, child: Text(vehicle.name)));
    }
    return items;
  }
}
