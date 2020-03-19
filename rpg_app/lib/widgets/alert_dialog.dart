import "package:flutter/material.dart";

Widget alert(String title, String subtitle){
  return AlertDialog(
    title: Text(title),
    content: Text(subtitle),
  );
}
