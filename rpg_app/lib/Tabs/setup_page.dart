import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/Screens/login_page.dart';
import 'package:rpg_app/widgets/custom_drawer.dart';
import 'package:rpg_app/widgets/snackbar.dart';



class SetupPage extends StatefulWidget {

  final Map<String, dynamic> usuario;
  String usuarioID;
  PageController controller;
  SetupPage(this.usuario, this.usuarioID, this.controller);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  String _chave = "";
  bool _verSenha = false;
  bool _admin = false;
  bool _carregando = false;
  final _controlerLogin = TextEditingController();
  final _controlerSenha = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.usuario["usuario"] == "admin") _admin = true;
      Firestore.instance.collection("usuarios").document(widget.usuarioID).get().then((snap){
        setState(() {
        _chave = _admin ? snap.data["chave"].toString() : "";
        _controlerLogin.text = widget.usuario["login"];
        _controlerSenha.text = widget.usuario["senha"];
      });
      });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Configurações"),
        centerTitle: true,
      ),
      drawer: CustomDrawer(widget.usuario, widget.usuarioID, widget.controller),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarAlteracoes,
        tooltip: "Salvar Alterações",
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.check),
      ),
      backgroundColor:  Colors.amber,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _admin ? _gerarSenha() : Container(),
              alterar("Login"),
              alterar("Senha"),
            ],
          ),
        ],
      )
    );
  }

  void _logout()async{
    setState(() {
      _carregando = true;
    });
    await _saveData();
    Future.delayed(Duration(seconds: 1)).then((value){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=>LoginPage()),
          ModalRoute.withName("/"));
      setState(() {
        _carregando = false;
      });
    });
  }

  void _salvarAlteracoes(){
    Firestore.instance.collection("usuarios").document(widget.usuario["id"]).updateData(
        {"login": _controlerLogin.text,
          "senha": _controlerSenha.text}
    );
    _scaffoldKey.currentState.showSnackBar(snackbar(Colors.lightGreen, "Alterações Salvas"));
  }

  Widget _gerarSenha(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            color: Colors.grey,
            elevation: 3,
            onPressed: _gerarChave,
            child: Text("Gerar chave : "),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 36.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Center(child: Text(_chave, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget alterar(String text){
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Mudar $text", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 36.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: TextField(
                    obscureText: (text == "Login" || _verSenha == true) ? false : true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),

                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(13.0),
                      suffixIcon: text =="Senha" ?
                      IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        color: _verSenha
                            ? Colors.amberAccent
                            : Colors.grey,
                        onPressed: () {
                          setState(() {
                            _verSenha = !_verSenha;
                          });
                        },
                      ) : null,
                    ),
                    controller: text == "Login" ?
                    _controlerLogin: _controlerSenha,
                  )
                ),
              )
          )
        ],
      ),
    );
  }

  void _gerarChave(){
    int num = 0;
    setState(() {
     for (int i = 0; i < 5; i++){
       num += (Random().nextInt(9)+1) * pow(10, i);
      }
     _chave = num.toString();
     Firestore.instance.collection("usuarios").document(widget.usuarioID).updateData({"chave": num});
    });
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
