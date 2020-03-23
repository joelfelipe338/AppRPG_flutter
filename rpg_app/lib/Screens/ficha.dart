import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rpg_app/widgets/snackbar.dart';

class Ficha extends StatefulWidget {
  
  Map<String,dynamic> usuario;
  String usuarioID;
  Ficha(this.usuario, this.usuarioID);
  
  @override
  _FichaState createState() => _FichaState();
}

class _FichaState extends State<Ficha> {

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _controllerNome = TextEditingController();
  final _controllerElemento = TextEditingController();
  final _controllerIdade = TextEditingController();
  final _controllerPeso = TextEditingController();
  final _controllerAltura = TextEditingController();
  final _controllerSexo = TextEditingController();
  bool _cadastro = false;
  bool _carregandoFoto = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _fotoAlterada = false;
  String _sexo = "sem genero";
  List<String> _sexoOptions = ["masculino","feminino","sem genero"];
  File _imgFile;
  Map<String, dynamic> _ficha;
  Map<String, dynamic> _fichaAux;
  Map<String, dynamic> _usuario;
  String _imageAux;
  int _pontos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _ficha = widget.usuario["ficha"];
    _fichaAux = json.decode(json.encode(_ficha));
    _usuario = widget.usuario;
    _imageAux = _usuario["ficha"]["imagePerfil"];

    Firestore.instance.collection("usuarios").document(widget.usuarioID).get().then((snap){
      setState(() {
        _cadastro = snap.data["cadastrado"];
        _fichaAux = snap.data["ficha"];
        _ficha = snap.data["ficha"];
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text("ficha"),centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: (){
            setState(() {
              _fichaAux["pontosLevel"] = _ficha["pontosLevel"];
              _zerar();
            });
          },
          icon: Icon(Icons.refresh),
        )
      ],),
       backgroundColor: Colors.grey,
       floatingActionButton: !_cadastro ? null : FloatingActionButton(
        onPressed: _fichaAux["pontosLevel"] > 0 ?null:_salvarDados,
        child: _fichaAux["pontosLevel"] > 0 ? Text(_fichaAux["pontosLevel"].toString()): Icon(Icons.check),
      ),
      body: _cadastro ? _telaEditar() : _telaCadastro(),
    );
  }

  void _salvarDados()async{
    var conected = await Connectivity().checkConnectivity();
    if(conected == ConnectivityResult.wifi || conected == ConnectivityResult.mobile){
      _fichaAux["manaAtual"] = _fichaAux["manaTotal"];
      _fichaAux["vidaAtual"] = _fichaAux["vidaTotal"];
      _fichaAux["pontosLevel"] = 0;
      _fichaAux["imagePerfil"] = _imageAux;
      _usuario["ficha"] = _fichaAux;

      _saveDataLogin();
      FirebaseStorage.instance.ref().child(
          DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(_imgFile).onComplete.then((snap){
        snap.ref.getDownloadURL().then((url){
          _fichaAux["imageNetwork"] = url;
        }).then((value){
          Firestore.instance.collection("usuarios").document(widget.usuarioID).updateData({
            "ficha": _fichaAux
          }).then((data){
            Navigator.pop(context, _fichaAux);
          });
        });
      });
    }else{
      _scaffoldkey.currentState.showSnackBar(snackbar(Colors.red, "Sem Conexão!"));
    }

  }
  Widget _telaCadastro() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child:  Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _foto,
                          child: Container(
                            height: 160.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(fit:BoxFit.cover,image: _imageAux != "" ?
                                FileImage(File(_imageAux))
                                    : AssetImage("images/person.png"))
                            ),
                            child: _carregandoFoto ? CircularProgressIndicator(): Container(),
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha os dados!";
                            }else{
                              return null;
                            }
                          },
                          controller: _controllerElemento,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Elemento",
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        padding: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (text){
                            if (text.isEmpty){
                              return "Preencha os dados!";
                            }else{
                              return null;
                            }
                          },
                          controller: _controllerNome,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Nome",
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _itemCadastro("Idade",TextInputType.number, _controllerIdade),
                      _itemCadastro("Peso",TextInputType.numberWithOptions(decimal: true), _controllerPeso),
                      _itemCadastro("Altura",TextInputType.numberWithOptions(decimal: true), _controllerAltura),
                      DropdownButton(
                        value: _sexo,
                        onChanged: (text){
                          setState(() {
                            _sexo = text;
                          });
                        },
                        isExpanded: true,
                        items: _sexoOptions.map((String item){
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )
              ],
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: (){
                if(_formKey.currentState.validate()){
                  _usuario["ficha"]["nick"] = _controllerNome.text;
                  _usuario["ficha"]["idade"] = int.parse(_controllerIdade.text);
                  _usuario["ficha"]["peso"] = int.parse(_controllerPeso.text);
                  _usuario["ficha"]["altura"] = int.parse(_controllerAltura.text);
                  _usuario["ficha"]["elemento"] = _controllerElemento.text;
                  _usuario["cadastrado"] = true;
                  Firestore.instance.collection("usuarios").document(widget.usuarioID).updateData(_usuario);
                  _saveDataLogin();
                  Navigator.pop(context, _usuario["ficha"]);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      )
    );
  }

  Widget _itemCadastro(String text, TextInputType keyboard, TextEditingController controller){
    return Container(
      height: 70.0,
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        validator: (text){
          if (text.isEmpty){
            return "Preencha os dados!";
          }else{
            return null;
          }
        },
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
            labelText: text,
        ),
      ),
    );
  }

  Widget _telaEditar(){
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(

          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _atributo(Icons.settings, "ataque"),
                      _atributo(Icons.settings, "defesa"),
                      _atributo(Icons.settings, "critico")
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:GestureDetector(
                    onTap: _foto,
                    child:  Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(image: _imageAux == ""?
                          AssetImage("images/person.png")
                              : FileImage(File(_imageAux))
                              ,fit: BoxFit.cover)
                      ),
                      child: _carregandoFoto ? CircularProgressIndicator() : Container(),
                    ),
                  )
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _atributo(Icons.settings, "vidaTotal"),
                      _atributo(Icons.settings, "manaTotal"),
                      _atributo(Icons.settings, "magia")
                    ],
                  )
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        _subAtributo("Força","forca"),
                        _subAtributo("Agilidade","agilidade"),
                        _subAtributo("Destreza","destreza"),
                        _subAtributo("Esquiva","esquiva"),
                        _subAtributo("Constituição","constituicao"),
                        _subAtributo("Sabedoria","sabedoria"),
                      ],
                    ),
                  )
                ),
                Expanded(
                  child:Card(
                    child:  Column(
                      children: <Widget>[
                        _subAtributo("Armadura","armadura"),
                        _subAtributo("Inteligência","inteligencia"),
                        _subAtributo("Sorte","sorte"),
                        _subAtributo("Percepção","percepcao"),
                        _subAtributo("Resistencia","resistencia"),
                        _subAtributo("Carisma","carisma"),
                      ],
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _atributo(IconData icon, String atributo){
    return Row(
      children: <Widget>[
        Icon(icon),
        Container(
          width: 40.0,
          decoration: BoxDecoration(shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),color: Colors.white),
          child: Text(
            _fichaAux[atributo].toString(),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  void _zerar(){setState(() {
    _fichaAux = json.decode(json.encode(_ficha));
  });

  }

  Widget _subAtributo(String titulo, String subAtributo){
    return Row(
      children: <Widget>[
        Expanded(flex: 3,child: Text(titulo),),
        Expanded(child: Text(_fichaAux[subAtributo].toString()),),
        IconButton(icon: Icon(Icons.arrow_upward),
          color: _fichaAux["pontosLevel"] > 0 ? Colors.blue : Colors.grey,
          onPressed: (){
            setState(() {
              if (_fichaAux["pontosLevel"] > 0) { _fichaAux["pontosLevel"] -= 1;
              _fichaAux[subAtributo] += 1;
              _atualizarAtributos();}

            });
          },)
      ],
    );
  }

  void _foto()async{
    _fotoAlterada = false;
    ImagePicker.pickImage(source: ImageSource.camera).then((file){
      if(file == null) return;
      setState(() {
        _imgFile = file;
        _imageAux = file.path;
      });
    });
  }

  void _atualizarAtributos(){
    setState(() {
      _fichaAux["ataque"] = (_fichaAux["forca"] + _fichaAux["agilidade"]);
      _fichaAux["defesa"] = (_fichaAux["esquiva"] + _fichaAux["destreza"]);
      _fichaAux["vidaTotal"] = (_fichaAux["constituicao"] + _fichaAux["sabedoria"]) * 5;
      _fichaAux["manaTotal"] = (_fichaAux["constituicao"] + _fichaAux["resistencia"]) * 5;
      _fichaAux["critico"] = (_fichaAux["sorte"] + _fichaAux["percepcao"]);
      _fichaAux["magia"] = (_fichaAux["inteligencia"] + _fichaAux["sabedoria"]);
    });
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
}
