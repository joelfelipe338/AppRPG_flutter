import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String usuario;
  ChatMessage(this.data, this.usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        margin: usuario == data["usuario"] ?
        EdgeInsets.only(top: 5.0, bottom: 5.0,right: 10.0, left: 100.0) :
        EdgeInsets.only(top: 5.0, bottom: 5.0,right: 100.0, left: 10.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: usuario == data["usuario"] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                data["usuario"],
                style: TextStyle(color: Colors.indigo),
              ),
              Text(data["message"]),
            ],
          ),
        )
    );
  }
}
