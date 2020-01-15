import 'package:flutter/material.dart';
import 'package:spediter/components/destinationCircles.dart';
import 'package:spediter/components/destinationLines.dart';
import 'package:spediter/components/inderdestination.dart';
import 'package:spediter/theme/style.dart';

typedef OnDelete();
typedef OnAdd();

class InterdestinationEditForm extends StatefulWidget {
  final Interdestination interdestination;
  final state = _UserFormState();
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
  _UserFormState createState() => state;

  // bool isValid() => state.validate();
}  

class _UserFormState extends State<InterdestinationEditForm> {


  @override
  Widget build(BuildContext context) {
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
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.item,
                    // onChanged: (val) =>
                    //     widget.interdestination.interdestinationData = val,
                    validator: (val) =>
                        val.length > 3 ? null : 'Unesite ime grada',
                    decoration: InputDecoration(
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
                        labelText: 'Dodaj među destinaciju',
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
}
