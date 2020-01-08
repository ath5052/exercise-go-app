import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/Exercise.dart';
import 'package:exercise_go/Controller/database_helper.dart';
import 'package:exercise_go/View/exercise_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


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
    if (exerciseList == null) {
      exerciseList = List<Exercise>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Go'),
      ),
      body: getExerciseListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            debugPrint('add button clicked');
            _updateTitle();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Exercise exercise;

  void _updateTitle() async {
    exercise.title = 'test';
    exercise.description = 'test';
    exercise.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    result = await databaseHelper.insertExercise(exercise);
  }

  ListView getExerciseListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
      return Text(
        this.exerciseList[position].title,
        //exerciseList?.elementAt(position) ??""
        //position.toString()
      );
    });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Exercise>> exerciseListFuture =
          databaseHelper.getExerciseList();
      exerciseListFuture.then((exerciseList) {
        setState(() {
          this.exerciseList = exerciseList;
          this.count = exerciseList.length;
        });
      });
    });
  }
}
