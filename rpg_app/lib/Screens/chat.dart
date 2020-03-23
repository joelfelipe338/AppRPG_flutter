import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rpg_app/widgets/chat_message.dart';
import 'package:rpg_app/widgets/snackbar.dart';
import 'package:rpg_app/widgets/text_composer.dart';

class Chat extends StatefulWidget {

  final Map<String, dynamic> usuario;
  final String usuarioID;
  Chat(this.usuario,this.usuarioID);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
                child:StreamBuilder<QuerySnapshot>(
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
                ),
              ),
              TextComposer(_enviar)
            ],
          ),
        ],
      )
    );
  }

  void _enviar(String text)async{
    String message = text;
    String usuario = widget.usuario["usuario"];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Firestore.instance.collection("chat").add({
        "message": message,
        "usuario": usuario,
        "time" : Timestamp.now(),
      });
    } else{
      print("semConexao");
      _scaffoldkey.currentState.showSnackBar(snackbar(Colors.red,"Sem Conexão!"));
    }
  }
}
