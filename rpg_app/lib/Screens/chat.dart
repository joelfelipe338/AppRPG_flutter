import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_app/widgets/chat_message.dart';
import 'package:rpg_app/widgets/text_composer.dart';

class Chat extends StatefulWidget {

  final Map<String, dynamic> usuario;
  final String usuarioID;
  Chat(this.usuario,this.usuarioID);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  List<dynamic> messages = [

    ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat RPG"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.lightBlue,),
          Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("chat").orderBy("time").snapshots(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                        return ListView.builder(
                          itemCount: documents.length ,
                          reverse: true,
                          itemBuilder: (context, index){
                            return ChatMessage(documents[index].data, widget.usuario["usuario"]);
                          },
                        );
                    }
                  },
                )
              ),
              TextComposer(_enviar)
            ],
          ),
        ],
      )
    );
  }

  void _enviar(String text){
    String message = text;
    String usuario = widget.usuario["usuario"];
    Firestore.instance.collection("chat").add({
      "message": message,
      "usuario": usuario,
      "time" : Timestamp.now(),
    });
  }
}
