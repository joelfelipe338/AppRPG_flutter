import 'package:flutter/material.dart';
import 'package:rpg_app/loading.dart';

void main(){

  runApp(MaterialApp(
    home: Loading(),
    theme: ThemeData(
        fontFamily: "BreatheFire",
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        )
    ),
  ));


}