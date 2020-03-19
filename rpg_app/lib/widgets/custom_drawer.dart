import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/Screens/login_page.dart';
import 'package:rpg_app/widgets/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {


  final Map<String, dynamic> usuario;
  String usuarioID;
  PageController controller;
  CustomDrawer(this.usuario, this.usuarioID, this.controller);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
              margin: null,
              decoration: BoxDecoration(
                  image: DecorationImage(image: usuario["ficha"]["imageFundo"] == "" ?
                  AssetImage("images/imageLogin1.jpg"): NetworkImage(usuario["ficha"]["imageFundo"]),fit: BoxFit.fill)
              ),
              child:Column(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      backgroundImage:usuario["ficha"]["imagePerfil"] == "" ?
                      AssetImage("images/person.png"): FileImage(File(usuario["ficha"]["imagePerfil"])),
                      radius: 50.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      usuario["ficha"]["nick"] ?? "Nome Personagem",
                      style: TextStyle(
                          color: Colors.white, fontSize: 30.0),
                    ),
                  )
                ],
              )),
          Expanded(
              child:Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/madeira.jpg"),fit: BoxFit.cover)
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListView(
                    children: <Widget>[
                      DrawerTile(Icons.home, "Tela Inicial", controller, 0),
                      DrawerTile(Icons.settings, "Configurações", controller, 1),
                      Divider(),
                      GestureDetector(
                        onTap: ()async{
                          await _saveData();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context)=>LoginPage()),
                              ModalRoute.withName("/"));

                        }, child:ListTile(
                        title: Text("Logout",style: TextStyle(fontSize: 20.0,
                            color:Colors.amber),
                        ),
                        leading: Icon(Icons.exit_to_app,color: Colors.amber),
                      )
                      )
                    ],
                  ),
                )
              )

          ),

        ],
      ),
    );
  }


  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/usuario.json");
  }

  Future<File> _saveData() async {
    final file = await _getFile();
    file.delete();
  }

}
