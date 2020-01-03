import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/Exercise.dart';
import 'package:exercise_go/Controller/database_helper.dart';
import 'package:exercise_go/View/exercise_list.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExerciseListState();
  }
}

class ExerciseListState extends State<ExerciseList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Exercise> exerciseList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Go'),
      ),
      body: getExerciseListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateListView();
        },
      ),
    );
  }

  ListView getExerciseListView() {
    return ListView.builder(itemBuilder: (BuildContext context, int position) {
      return Text(
        this.exerciseList[position].title,
      );
    });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Exercise>> todoListFuture = databaseHelper.getExerciseList();
      todoListFuture.then((todoList) {
        setState(() {
          this.exerciseList = exerciseList;
          this.count = todoList.length;
        });
      });
    });
  }
}
