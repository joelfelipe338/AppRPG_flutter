import 'package:flutter/material.dart';

Widget snackbar(Color cor, String text){

  return SnackBar(
    content: Text(text,textAlign: TextAlign.center,),
    backgroundColor: cor,
    duration: Duration(seconds: 2),
    shape:RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(100.0), topRight: Radius.circular(100.0))),
  );
}