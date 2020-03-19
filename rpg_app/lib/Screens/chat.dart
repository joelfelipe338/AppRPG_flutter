import 'package:flutter/material.dart';

class Chat extends StatefulWidget {

  final Map<String, dynamic> usuario;
  final String usuarioID;
  Chat(this.usuario,this.usuarioID);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
