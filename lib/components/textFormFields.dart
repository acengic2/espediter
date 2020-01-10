import 'package:flutter/material.dart';

void main() => runApp(TextFormF());

typedef AreFieldsEmpty();

class TextFormF extends StatefulWidget {
 final FocusNode focusNode;
 final String initialValue, hintText, labelText, vars;
 final int onceToast, onceBtnPressed;
 
      TextFormF(
      {this.initialValue,
      this.hintText,
      this.onceToast,
      
      this.focusNode,
      this.labelText,
      this.onceBtnPressed,
      this.vars});

  @override
  _TextFormFState createState() => _TextFormFState(
      initialValue: initialValue,
      focusNode: focusNode,
      hintText: hintText,
      labelText: labelText,
      vars: vars,
      onceBtnPressed: onceBtnPressed,
      onceToast: onceToast,
     
    );
}

class _TextFormFState extends State<TextFormF> {
  FocusNode focusNode;
  String initialValue, hintText, labelText, vars;
  int onceToast, onceBtnPressed;
 
  _TextFormFState(
      {this.initialValue,
      this.hintText,
      this.onceToast,
      
      this.focusNode,
      this.labelText,
      this.onceBtnPressed,
      this.vars});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        initialValue: initialValue,
        focusNode: focusNode,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12))),
            labelText: labelText,
            labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
            hasFloatingPlaceholder: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        onChanged: (input) {
          setState(() {
            vars = input;
            onceToast = 0;
            onceBtnPressed = 0;
            
          });
          
        },
      ),
    );
  }
  
}


