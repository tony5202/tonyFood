import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/screen/home.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tony Food',
      home: Home(),
    );
  }
}
