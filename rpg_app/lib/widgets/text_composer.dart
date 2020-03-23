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
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(100.0), right: Radius.circular(100.0))
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: double.infinity,
                maxWidth: double.infinity,
                minHeight: 48.0,
                maxHeight: 52.0
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration.collapsed(
                      hintText: "Digite Aqui...",
                      hintStyle: TextStyle(color: Colors.grey)
                  ),
                  onChanged: (text){
                    setState(() {
                      _isComposing = true;
                    });
                  },
                ),
              ),
            )
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
