import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/Screens/login_page.dart';
import 'package:rpg_app/page_view.dart';
import 'package:rpg_app/Tabs/tela_inicial.dart';
import 'package:splashscreen/splashscreen.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Map<String,dynamic> _usuario;
  bool _dadosCarregados = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readData().then((value){
      setState(() {
        _usuario = json.decode(value);
        print(_usuario);
      });
    });
    print(_usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 3,
          navigateAfterSeconds:(_usuario == null || _usuario.isEmpty) ?
          LoginPage()
              : CustomPageView(_usuario,_usuario["id"]),
          loaderColor: Colors.transparent,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          child:  Center(
            child: Image.asset("images/dragon.gif"),
          ),)
      ],
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/usuario.json");
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

