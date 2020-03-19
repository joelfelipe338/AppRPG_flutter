import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/Screens/chat.dart';
import 'package:rpg_app/Screens/ficha.dart';
import 'package:rpg_app/widgets/custom_drawer.dart';

class TelaInicial extends StatefulWidget {
  final Map<String, dynamic> usuario;
  String usuarioID;
  PageController controller;
  TelaInicial(this.usuario, this.usuarioID, this.controller);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  Map<String, dynamic> _usuario;
  bool _admin = false;
  Map<String, dynamic> _containerPAH = {
    "width" : 0.0,
    "height": 0.0,
    "align" : Alignment.center,
    "marginH": 50.0,
    "marginV" : 70.0,
  };
  List<String> _armamentos;
  List<String> _armaduras;
  List<String> _pericias;
  List<String> _habilidades;
  List<String> _acessorios;
  List<String> _pets;
  Map<String,dynamic> _ficha;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.usuario["usuario"] == "admin") _admin = true;
    _usuario = widget.usuario;
    _usuario["id"] = widget.usuarioID;
    _saveDataLogin();
    setState(() {
      _ficha = widget.usuario["ficha"];
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          setState(() {
            _containerPAH["width"] = 0.0;
            _containerPAH["height"] = 0.0;
          _containerPAH["marginH"] = 50.0;
          _containerPAH["marginV"] = 70.0;
          });
          return false;
        },
        child: Stack(
          children: <Widget>[
        Image.asset(
        "images/imageLogin2.jpg",
          fit: BoxFit.cover,
          height: 10000.0,
        ),
        Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(_usuario["login"]),
                centerTitle: true,

               actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Chat(_usuario, _usuario["id"])));
                    },
                  )
                ],
              ),
              drawer: CustomDrawer(widget.usuario, widget.usuarioID, widget.controller),
              backgroundColor: Colors.transparent,
              body: _tela(),
              floatingActionButton: FloatingActionButton(
                onPressed: ()async{
                 final rec = await Navigator.push(context,
                  MaterialPageRoute(builder:(context) => Ficha(_usuario,_usuario["id"])));
                 if(rec != null){
                   setState(() {
                     _ficha = rec;
                   });
                 }
                },
                backgroundColor: Colors.orange,
                child: Icon(Icons.star, color: Colors.yellowAccent,),
              ),
            ),
          ],
        ));
  }

  Widget _tela() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child:  Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[_caracteristicas(),
                 _atributos()
                ],
              ),
              Container(
                height: 270.0,
                  width:330.0,
                  margin: EdgeInsets.only(top: 10.0),
                  child:Stack(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _pah(_armamentos, _armaduras, "Armamentos", "Armaduras",Alignment.topLeft,Alignment.bottomLeft),
                        _pah(_pericias, _habilidades, "Pericias", "Habilidades",Alignment.topCenter, Alignment.bottomCenter),
                        _pah(_acessorios, _pets, "Acessorios", "PETS", Alignment.topRight,Alignment.bottomRight)
                      ],
                    ),Align(
                      alignment: _containerPAH["align"],
                      child: AnimatedContainer(
                        margin: EdgeInsets.symmetric(horizontal:_containerPAH["marginH"],
                            vertical: _containerPAH["marginV"]),
                        duration: Duration(milliseconds: 500),
                        width: _containerPAH["width"],
                        height: _containerPAH["height"],
                        decoration: BoxDecoration(color:Colors.blue,borderRadius: BorderRadius.all(Radius.circular((20.0)))),
                      ),
                    )
                  ],)
              )
            ],

        ));
  }

  Widget _pah(List<String> listaPrimaria, List<String> listaSecundaria,
      String tituloPrimario, String tituloSecundario,
      Alignment alignPrimario, Alignment alignSecundario) {
    return Column(
      children: <Widget>[
        Text(tituloPrimario,style: TextStyle(fontWeight: FontWeight.bold),),
        GestureDetector(
          onTap: (){
            setState(() {
              _containerPAH["align"] = alignPrimario;
              _containerPAH["height"] = 280.0;
              _containerPAH["width"] = 330.0;
              _containerPAH["marginH"] = 0.0;
              _containerPAH["marginV"] = 0.0;
            });
          },
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset("images/person.png",height: 100.0,)
          ),
        ),
        Text(tituloSecundario,style: TextStyle(fontWeight: FontWeight.bold),),
        GestureDetector(
          onTap: (){
            setState(() {
              _containerPAH["align"] = alignSecundario;
              _containerPAH["height"] = 280.0;
              _containerPAH["width"] = 330.0;
              _containerPAH["marginH"] = 0.0;
              _containerPAH["marginV"] = 0.0;
            });
          },
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset("images/person.png",height: 100.0,)
          ),
        )
      ],
    );
  }

  Widget _caracteristicas() {
    return Expanded(
        flex: 2,
        child: Container(
          child: Column(
            children: <Widget>[

              Row(
                children: <Widget>[
                  Expanded(child: Text(
                    _ficha["nick"] ?? "Nome Jogador",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0),
                  ),),
                  Text("Elemento: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                  Text(_ficha["elemento"] ?? "Null",style: TextStyle(fontSize: 16.0),),
                ],

              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Idade",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["idade"].toString() ?? "0",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Peso",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["peso"].toString() ?? "0.0",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Altura",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["altura"].toString() ?? "0.0",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Titulo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["titulo"] ?? "Null",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Classe",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["classe"] ?? "Null",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "Raça",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _ficha["raca"] ?? "Null",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _itemAtributo("Força", _ficha["forca"] ?? 0),
                          _itemAtributo("Agilidade",_ficha["agilidade"] ??  0),
                          _itemAtributo("Destreza",_ficha["destreza"] ??  0),
                          _itemAtributo("Esquiva",_ficha["esquiva"] ??  0),
                          _itemAtributo("Constituição",_ficha["constituicao"] ??  0),
                          _itemAtributo("Sabedoria",_ficha["sabedoria"] ??  0),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Column(
                      children: <Widget>[
                        _itemAtributo("Armadura", _ficha["armadura"] ?? 0),
                        _itemAtributo("Inteligencia", _ficha["inteligencia"] ?? 0),
                        _itemAtributo("Sorte",_ficha["sorte"] ??  0),
                        _itemAtributo("Percepção",_ficha["percepcao"] ??  0),
                        _itemAtributo("Resistencia",_ficha["resistencia"] ??  0),
                        _itemAtributo("Carisma",_ficha["carisma"] ??  0),
                      ],
                    ),
                  ))
                ],
              ),
            ],
          ),
        ));
  }

  Widget _itemAtributo(String titulo, int valor) {
    return Row(
      children: <Widget>[
        Text(
          "$titulo : ",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Text("${valor.toString()}", style: TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _atributos() {
    return Expanded(
        flex: 1,
        child: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image:
                        DecorationImage(fit: BoxFit.cover,image:_ficha["imagePerfil"] == "" ? AssetImage("images/person.png")
                        : FileImage(File(_ficha["imagePerfil"]))),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            _ficha["nivel"].toString() ?? "0",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.coins,
                      color: Colors.yellow,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(_ficha["ouro"].toString() ?? "0"),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red,),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: StreamBuilder(
                      stream: Firestore.instance.collection("usuarios").document(widget.usuarioID).snapshots(),
                      builder: (context, snapshot){
                        return Container(width: 70,height: 10.0,
                          decoration: BoxDecoration(border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                            style: BorderStyle.solid
                          ),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          child: FractionallySizedBox(

                              widthFactor: 1,
                              child: Align(alignment: Alignment.bottomLeft,child: Container(
                                width: snapshot.data.data["ficha"]["vidaTotal"] > 0 ?
                                (snapshot.data.data["ficha"]["vidaAtual"] / snapshot.data.data["ficha"]["vidaTotal"])*70: 0,
                                color: Colors.red,height: 10.0,))
                          ),);
                      },
                    )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.bong,color:Colors.blue),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection("usuarios").document(widget.usuarioID).snapshots(),
                        builder: (context, snapshot){
                          return Container(width: 70,height: 10.0,
                            decoration: BoxDecoration(border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                                style: BorderStyle.solid
                            ),borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Align(alignment: Alignment.bottomLeft,child: Container(
                                  width: snapshot.data.data["ficha"]["manaTotal"] > 0 ?
                                  (snapshot.data.data["ficha"]["manaAtual"] / snapshot.data.data["ficha"]["manaTotal"])*70: 0,
                                  color: Colors.blue,height: 10.0,))
                            ),);
                        },
                      )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.settings),
                  Text(
                    _ficha["ataque"].toString() ?? "0",
                    textAlign: TextAlign.center,
                  ),
                  Icon(Icons.settings),
                  Text(
                    _ficha["defesa"].toString() ?? "0",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.settings),
                  Text(
                    _ficha["critico"].toString() ?? "0",
                    textAlign: TextAlign.center,
                  ),
                  FaIcon(FontAwesomeIcons.bolt, color: Colors.blue,),
                  Text(
                    _ficha["magia"].toString() ?? "0",
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Future<File> _getFileLogin() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/usuario.json");
  }

  Future<File> _saveDataLogin() async {
    String data = json.encode(_usuario);
    final file = await _getFileLogin();
    return file.writeAsString(data);
  }

  Future<String> _readDataLogin() async {
    try {
      final file = await _getFileLogin();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}
