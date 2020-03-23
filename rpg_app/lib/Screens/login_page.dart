import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpg_app/page_view.dart';
import 'package:rpg_app/Tabs/tela_inicial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/widgets/snackbar.dart';
import 'cadastro.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Map<String, dynamic> _usuario;
  final _controllerLogin = TextEditingController();
  final _controllerSenha = TextEditingController();
  final _controllerChave = TextEditingController();
  bool _verSenha = false;
  bool _carregando = false;
  bool _infoAlert = false;
  final _senhaFocus = FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "images/imageLogin2.jpg",
            fit: BoxFit.fill,
            height: 1000.0,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 160.0, //160
                  width: 200.0,
                  child: Image.asset(
                    "images/logoLogin.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: TextField(
                      onSubmitted: (text) {
                        if (_controllerSenha.text.isNotEmpty) {
                          _fazerLogin();
                        } else {
                          FocusScope.of(context).requestFocus(_senhaFocus);
                        }
                      },
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                      controller: _controllerLogin,
                      decoration: InputDecoration(
                          labelText: "Login",
                          labelStyle: TextStyle(
                              color: Colors.amberAccent, fontSize: 20.0),
                          border: OutlineInputBorder()),
                    )),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onSubmitted: (text) {
                                _fazerLogin();
                              },
                              focusNode: _senhaFocus,
                              obscureText: _verSenha ? false : true,
                              style: TextStyle(
                                color: Colors.deepOrange,
                              ),
                              controller: _controllerSenha,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    color: _verSenha
                                        ? Colors.amberAccent
                                        : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        _verSenha = !_verSenha;
                                      });
                                    },
                                  ),
                                  labelText: "Senha",
                                  labelStyle: TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 20.0),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        color: Colors.amberAccent,
                        child: Text("Entrar"),
                        onPressed: _fazerLogin,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        child: Text("Cadastrar"),
                        color: Colors.amberAccent,
                        onPressed: () {
                          setState(() {
                            _infoAlert = false;
                          });
                          _alertDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _carregando ? LinearProgressIndicator() : Container(),
        ],
      ),
    );
  }

  void _alertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Chave de Acesso"),
            content: Column(
              children: <Widget>[
                CupertinoTextField(
                  autofocus: true,
                  controller: _controllerChave,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: _infoAlert
                      ? Text("Chave Incorreta!",
                          style: TextStyle(color: Colors.red))
                      : Container(),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Voltar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Acessar"),
                onPressed: _fazerCadastro,
              ),
            ],
          );
        });
  }

  void _fazerCadastro() async {
    String _chave = "";
    Firestore.instance.collection("usuarios").getDocuments().then((snapshots) {
      snapshots.documents.forEach((usuario) {
        if (usuario.data["usuario"] == "admin") {
          _chave = usuario.data["chave"].toString();
        }
      });
      if (_chave == _controllerChave.text) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Cadastro()));
      } else {
        Navigator.pop(context);
        setState(() {
          _infoAlert = true;
        });
        _alertDialog();
        _controllerChave.text = "";
      }
    });
  }

  void _fazerLogin() async {
    bool _login = false;
    DocumentSnapshot _usuarioLogin;
    setState(() {
      _carregando = true;
    });
    QuerySnapshot snapshots =
        await Firestore.instance.collection("usuarios").getDocuments();
    snapshots.documents.forEach((usuario) {
      if (usuario.data["login"] == _controllerLogin.text &&
          usuario.data["senha"] == _controllerSenha.text) {
         _login = true;
         _usuarioLogin = usuario;
      }
    });
    if(_login){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CustomPageView(_usuarioLogin.data, _usuarioLogin.documentID)));
    }else{
      _scaffoldKey.currentState.showSnackBar(snackbar(Colors.black12, "Usuario ou senha invalidos@!"));
    }
    setState(() {
      _carregando = false;
      _controllerLogin.text = "";
      _controllerSenha.text = "";
    });
  }
}
