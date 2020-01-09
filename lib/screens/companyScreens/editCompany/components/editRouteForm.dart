import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/components/vehicle.dart';
import 'package:spediter/screens/companyScreens/createRoute/form.dart';
import 'package:spediter/screens/companyScreens/editCompany/components/btnFinish.dart';
import 'package:spediter/screens/companyScreens/editCompany/components/btnSave.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
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
  List<InterdestinationForm> interdestinations = [];

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

  /// DateTime tip datuma (radi validacije)
  DateTime selectedDateP;
  DateTime selectedDateD;
  DateTime startDateCompare;
  DateTime endDateCompare;
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
  /// aktiviramo [BackButtonInterceptor] i dodajemo mu f-ju [myInterceptor]
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_vehicle);
    super.initState();
    getUserid();
    onceToast = 0;
    BackButtonInterceptor.add(myInterceptor);
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
                                  initialValue: DateTime.parse(
                                      widget.post.data['departure_date']),
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
                                          color: Color.fromRGBO(0, 0, 0, 0.12)),
                                    ),
                                    hintText: 'Datum polaska',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                  ),
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final DateTime picked =
                                        await showDatePicker(
                                            locale: Locale('bs'),
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime(2100));

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
                                    startDateCompare = input;
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
                                  initialValue: DateTime.parse(
                                      widget.post.data['departure_date'] +
                                          ' ' +
                                          widget.post.data['departure_time']),
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
                                          color: Color.fromRGBO(0, 0, 0, 0.12)),
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
                                    DestinationCircle(largeCircle: StyleColors().blueColor1, smallCircle: StyleColors().blueColor),
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
                                      initialValue: widget
                                          .post.data['starting_destination'],
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
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
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
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
                                    DestinationCircle(largeCircle: StyleColors().destinationCircle2, smallCircle: StyleColors().destinationCircle1,),
                                  ],
                                )),
                            Expanded(
                                flex: 9,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 9, bottom: 8, right: 5),
                                    height: 36,
                                    child: TextFormField(
                                      initialValue: widget
                                          .post.data['ending_destination'],
                                      onTap: onAddForm,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
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
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
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
                                  initialValue: DateTime.parse(
                                      widget.post.data['arrival_date']),
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
                                          color: Color.fromRGBO(0, 0, 0, 0.12)),
                                    ),
                                    hintText: 'Datum dolaska',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                  ),
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final DateTime picked =
                                        await showDatePicker(
                                            locale: Locale('bs'),
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime(2100));
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
                                    endDateCompare = input;
                                    selectedDateP = new DateTime(
                                        selectedDateP.year,
                                        selectedDateP.month,
                                        selectedDateP.day);
                                    selectedDateD = new DateTime(
                                        selectedDateD.year,
                                        selectedDateD.month,
                                        selectedDateD.day);
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
                                  initialValue: DateTime.parse(
                                      widget.post.data['arrival_date'] +
                                          ' ' +
                                          widget.post.data['arrival_time']),
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
                                                Color.fromRGBO(0, 0, 0, 0.12)),
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
                                      // if(timeD == def)
                                    });
                                    if (timeD == 'null') {
                                      timeD = '';
                                    } else if (timeD != 'null') {
                                      return DateTimeField.convert(time1);
                                    }
                                  },
                                  onChanged: (input) {
                                    t1 = input;
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
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(
                              width: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
                          bottom: BorderSide(
                              width: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
                        )),
                        child: Divider(
                          thickness: 8,
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                        ),
                      ),

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
                                    color: Color.fromRGBO(0, 0, 0, 0.12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.12))),
                              labelText: 'Popunjenost u procentima',
                              hintText: '0-100',
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
                            setState(() {
                              capacityVar = input;

                              double capacityDouble = double.parse(capacityVar);
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
                              hint: Text(widget.post.data['vehicle']),
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
                          initialValue: widget.post.data['goods'],
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
                          initialValue: dimensionsVar,
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
                          child: ButtonSave(),
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
                          child: ButtonFinishRoute(),
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

  ///on save forms
  void onSave() {
    if (interdestinations.length > 0) {
      var allValid = true;
      interdestinations.forEach((form) => allValid = allValid);
      if (allValid) {
        var data = interdestinations.map((it) => it.interdestination).toList();
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
    t11 = widget.post.data['departure_time'];
    percentageVar = int.parse(widget.post.data['availability']);
    capacityVar = widget.post.data['capacity'];
    vehicleVar = widget.post.data['vehicle'];
    goodsVar = widget.post.data['goods'];
    dimensionsVar = widget.post.data['dimensions'];
  }

  ///dispose back btn-a nakon njegovog koristenja
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
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

  /// bool f-ja koju smo ubacili u [BackButtonInterceptor], koja mora vratiti true ili false.
  /// u kojoj na klik back btn-a
  /// provjeravamo da li company ima rute ili ne i na osnovu toga ih
  /// redirectamo na [NoRoutes] ili na [ListOfRoutes]
  bool myInterceptor(bool stopDefaultButtonEvent) {
    CompanyRoutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NoRoutes()));
      }
    });
    return true;
  }
}