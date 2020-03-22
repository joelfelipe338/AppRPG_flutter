import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {

  Function enviar;
  TextComposer(this.enviar);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(
                border: null,
                hintText: "   Digite Aqui...",
              ),
              onChanged: (text){
                setState(() {
                  _isComposing = true;
                });
              },
            ),

          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              widget.enviar(_textController.text);
              _textController.text = "";
            }: null,
          )
        ],
      ),
    );
  }
}
