import 'package:flutter/material.dart';
import 'dart:async';

class ExerciseList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExerciseListState();
  }
}

class ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
      title: Text('Exercise Go'),
    ),
    body: getExerciseListView(),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        updateListView();
      },
    ),);
  }

  ListView getExerciseListView(){
    return ListView.builder(

        itemBuilder: (BuildContext context, int position){

        }
    );
  }

  void updateListView(){

  }

}
