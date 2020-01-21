import 'package:flutter/material.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/theme/style.dart';

typedef OnDelete();
typedef OnAdd();
String izBaze;

class InterdestinationEditForm extends StatefulWidget {
  final Interdestination interdestination;

  final OnDelete onDelete;
  final String item;
  final OnAdd onAdd;

  InterdestinationEditForm({
    Key key,
    this.interdestination,
    this.onDelete,
    this.item,
    this.onAdd,
  }) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState(item: item);

  // bool isValid() => state.validate();
}

class _UserFormState extends State<InterdestinationEditForm> {
  @override
  void initState() {
    super.initState();
    // getValues();
  }

  TextEditingController controller;

  String item;
  _UserFormState({this.item});

  @override
  Widget build(BuildContext context) {
    controller = new TextEditingController(text: item);

    return Container(
        margin: EdgeInsets.only(left: 18.0, right: 16.0),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  DestinationLine(),
                  DestinationCircle(
                    largeCircle: StyleColors().textColorGray20,
                    smallCircle: StyleColors().textColorGray50,
                  ),
                  DestinationLine(),
                ],
              )),
          Expanded(
              flex: 9,
              child: Container(
                  height: 36.0,
                  margin: EdgeInsets.only(
                    bottom: 8,
                    left: 12,
                    right: 5,
                  ),
                  child: TextFormField(
                    // key: UniqueKey(),
                    onTap: widget.onAdd,
                    maxLength: 29,
                    textCapitalization: TextCapitalization.sentences,
                    // controller: controller,
                    initialValue: widget.item,
                    onChanged: (val) =>
                        widget.interdestination.interdestinationData = val,
                    //(val) => {
                    //      if (val == widget.item) {

                    //      } else {
                    //      }
                    // },
                    validator: (val) =>
                        val.length > 3 ? null : 'Unesite ime grada',
                    decoration: InputDecoration(
                        counterText: '',
                        hasFloatingPlaceholder: false,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide:
                              BorderSide(color: StyleColors().textColorGray12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(
                                color: StyleColors().textColorGray12)),
                        labelText: 'Unesite interdestinaciju',
                        labelStyle:
                            TextStyle(color: StyleColors().textColorGray50),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 2.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }

  ///form validator
  // bool validate() {
  //   var valid = form.currentState.validate();
  //   if (valid) form.currentState.save();
  //   return valid;
  // }

  getPrints() {
    String adi = controller.text;

    print(adi + "    ======= OVDJE SAMMMMM!!!");
  }

  getValues() {
    getPrints();
    setState(() {
      izBaze = controller.text;
    });
  }
}

///
///Danis je uradio rekonstrukciju citavih crud methoda. Krenuo je ponovno od create i radio update
///Danisov code je zipan posebno i nalazi se kod Danisa i Adija na Desktopu.
///
///Drugi nacin:
///
/// Prepisali i prepravili InterdestiancijeForm sa create. To je ovaj fail. InterdestiantionEditForm.
/// Na editROuteForm smo zvali ovu classu i pokusali ubaciti edit. \
/// Mislimo da je problem u controlleru tj. u initial value (item)
/// non-stop renderuje item kada se pozove state.
///
/// Problem: u kupljenju interdestinacija izmedu sljedecih klasa
///   EditRouteForm.dart
///   InterdestinationEditForm.dart
///
///   koje treba da kupi iz DAO classe
///   Interdestination.dart
///
///  Sta nismo probali:
///  Nismo probali dodati delete na (X)
///
///
///
/// Kako trenutno radi:
/// ispisuje sve interdestinacije i moguce je dodati nove
/// nije moguce izbrisati ili editovati interdestinacije
