import 'package:flutter/material.dart';
import 'package:rpg_app/setup_page.dart';


class MenuDrawer extends StatefulWidget {

  final Map<String, dynamic> usuario;
  final String usuarioID;
  final int menuAtual;
  MenuDrawer(this.usuario,this.usuarioID,this.menuAtual);


  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),
          Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),
          Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),
          Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),
          Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),Container(
            height: 42.0,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetupPage(widget.usuario,widget.usuarioID)));
              },
              child: ListTile(
                title: Text("Configurações",style: TextStyle(fontSize: 20.0, color: Colors.amber),),
                leading: Icon(Icons.settings, color: Colors.amber,),
              ),
            ),
          ),

        ],
      )
    );
  }
}

