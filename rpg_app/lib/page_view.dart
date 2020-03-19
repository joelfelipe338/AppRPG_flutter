import 'package:flutter/material.dart';
import 'package:rpg_app/Tabs/setup_page.dart';
import 'package:rpg_app/Tabs/tela_inicial.dart';

class CustomPageView extends StatelessWidget {


  final Map<String, dynamic> usuario;
  String usuarioID;
  CustomPageView(this.usuario, this.usuarioID);

  final _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TelaInicial(usuario, usuarioID, _pageController),
        SetupPage(usuario, usuarioID, _pageController),
      ],
    );
  }
}
