import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpg_app/Screens/login_page.dart';
import 'package:rpg_app/Tabs/tela_inicial.dart';
import 'package:rpg_app/widgets/snackbar.dart';

class Cadastro extends StatefulWidget {

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  
  final _controllerLogin = TextEditingController();
  final _controllerSenha = TextEditingController();
  final _controllerSenha2 = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {Navigator.pop(context);return false;},
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(),
          title: Text("Cadastro"),
          centerTitle: true,
        ),
        backgroundColor: Colors.amberAccent,
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom:20.0),
                        child: Text(
                          "Preencha os dados abaixo",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:20.0,bottom: 10.0),
                        child: Text("Digite o login :"),
                      ),
                      _entradaForm(_controllerLogin,false),
                      Padding(
                        padding: EdgeInsets.only( top:20.0,bottom: 10.0),
                        child: Text("Digite a senha :"),
                      ),
                      _entradaForm(_controllerSenha,true),
                      Padding(
                        padding: EdgeInsets.only(top:20.0,bottom: 10.0),
                        child: Text("Digite a senha novamente :"),
                      ),
                      _entradaForm(_controllerSenha2,true),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  _validar();
                                }
                              },
                              color: Colors.grey,
                              child: Text("Cadastrar"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
          ),
      ),
    );
  }
  
  void _validar(){
    bool _nomeExiste = false;
    Firestore.instance.collection("usuarios").getDocuments().then((documents){
      documents.documents.forEach((data){
        if(_controllerLogin.text == data.data["login"]){
         _nomeExiste = true;
        }
      });
    }).then((value){
      if(_controllerSenha2.text != _controllerSenha.text){
        _scaffoldKey.currentState.showSnackBar(snackbar(Colors.redAccent,"Senhas nao coincidem!"));
      }else if(_nomeExiste){
        _scaffoldKey.currentState.showSnackBar(snackbar(Colors.redAccent,"Nome indisponivel!"));
      }else{
        _scaffoldKey.currentState.showSnackBar(snackbar(Colors.lightGreen,"Criado com sucesso!"));
        Firestore.instance.collection("usuarios").add({
          "login": _controllerLogin.text,
          "senha": _controllerSenha.text,
          "usuario": "cliente",
          "id" : Firestore.instance.collection("usuarios").document().documentID,
          "cadastrado": false,
          "ficha": {
            "agilidade": 0,
            "altura": 0,
            "armadura" : 0,
            "ataque" :0,
            "carisma": 0,
            "classe" : "null",
            "constituicao": 0,
            "critico": 0,
            "defesa": 0,
            "destreza": 0,
            "elemento" :"null",
            "esquiva" :0,
            "forca" :0,
            "idade" :0,
            "imageFundo": "",
            "imagePerfil" :"",
            "inteligencia": 0,
            "magia": 0,
            "manaAtual": 0,
            "manaTotal": 0,
            "nick" :"null",
            "nivel": 1,
            "ouro": 0,
            "percepcao": 0,
            "peso": 0.0,
            "pontosLevel": 23,
            "raca": "null",
            "resistencia": 0,
            "sabedoria": 0,
            "sorte": 0,
            "titulo" :"null",
            "vidaAtual" :0,
            "vidaTotal" :0,
            "xp": 0
          }
        });
        Future.delayed(Duration(seconds: 2)).then((value){
          Navigator.push(context,
              MaterialPageRoute(builder :(context) => LoginPage()));
        });

      }
      _controllerLogin.text = "";
      _controllerSenha.text = "";
      _controllerSenha2.text = "";
    });

  }
  
  Widget _entradaForm(TextEditingController controller, bool senha) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        obscureText: senha ? true : false,
        validator: (text) {
          if (text.isEmpty) {
            return "Campo vazio";
          } else {
            return null;
          }
        },
        controller: controller,
      ),
    );
  }
  
  
}
