import 'package:flutter/material.dart';
import 'package:exercise_go/View/exercise_master.dart';


void main() => runApp(
    //MyApp()
    ExerciseGo()
);

class ExerciseGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Go',
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExerciseMaster(),
    );
  }
}