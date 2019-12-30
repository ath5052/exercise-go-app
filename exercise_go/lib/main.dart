import 'package:flutter/material.dart';
import 'listdisplay.dart';
import 'complexlistdisplay.dart';
import 'package:exercise_go/View/exercise_list.dart';

void main() => runApp(
    //MyApp()
    ExerciseGo()
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new ComplexListDisplay(),
    );
  }
}

class ExerciseGo extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Exercise Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExerciseList(),
    );
  }
}