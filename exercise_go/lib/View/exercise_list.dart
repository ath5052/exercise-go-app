import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/exercise.dart';
import 'package:exercise_go/Model/exercise_detail.dart';
import 'package:exercise_go/Controller/database_helper.dart';

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
            navigateToDetail(Exercise('', '', ''), 'Add Exercise');
          });
        },
        tooltip: 'Add Exercise',
        child: Icon(Icons.add),
      ),
    );
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

  void navigateToDetail(Exercise exercise, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ExerciseDetail(exercise, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
}
