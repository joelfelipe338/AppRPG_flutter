import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {


  IconData icon;
  String text;
  PageController controller;
  int page;
  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.0,
      child: GestureDetector(
        onTap: (){
          controller.jumpToPage(page);
        },
        child: ListTile(
          title: Text(text,style: TextStyle(fontSize: 20.0,
              color: controller.page == page ? Colors.red : Colors.amber),
          ),
          leading: Icon(icon, color: controller.page == page ? Colors.red : Colors.amber),
        ),
      ),
    );
  }
}
