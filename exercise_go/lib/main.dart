import 'package:flutter/material.dart';
import 'listdisplay.dart';
import 'complexlistdisplay.dart';

void main() => runApp(
    MyApp()
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new ComplexListDisplay(),
    );
  }
}

