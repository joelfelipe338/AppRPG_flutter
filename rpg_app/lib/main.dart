import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/loading.dart';
import 'package:rpg_app/tela_inicial.dart';
import 'login_page.dart';

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