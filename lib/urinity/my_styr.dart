import 'package:flutter/material.dart';

class MyStyle {
  Color darkcolor = Colors.blue;
  Color promaryColor = Colors.green;
  SizedBox mySizebox() => SizedBox(
        width: 10,
        height: 15,
      );
  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
      );
  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
      );
  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration(String nampic) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$nampic'), fit: BoxFit.cover),
    );
  }

  Container showLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logoman.png'),
    );
  }
}
