import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String usuario;
  ChatMessage(this.data, this.usuario);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: usuario == data["usuario"] ?  MainAxisAlignment.end :  MainAxisAlignment.start,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.all(5.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: usuario == data["usuario"]
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  usuario == data["usuario"] ? Container() : Text(
                    data["usuario"],
                    style: TextStyle(color: Colors.indigo),
                  ),
                  Text(data["message"]),
                ],
              ),
            ))
      ],
    );
  }
}
