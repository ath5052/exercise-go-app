import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/exercise.dart';
import 'package:exercise_go/View/exercise_detail.dart';
import 'package:exercise_go/Controller/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exercise_go/Model/date.dart';

class ExerciseMaster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExerciseMasterState();
  }
}

class ExerciseMasterState extends State<ExerciseMaster> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Exercise> exerciseList;
  List<String> dateList = new List<String>();
  int count = 0;
  Map<String, List<Exercise>> dateMap = new Map<String, List<Exercise>>();

  @override
  Widget build(BuildContext context) {
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

  Row getDateTitleRow(int index) {
    return new Row(
      children: <Widget>[
        Text(
          Date.getDay(dateList[index]),
          //dateMap['20200119Sun'][0].title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        SizedBox(width: 20), // give it width
        Column(
          children: <Widget>[
            Text(
              Date.getYearMonth(dateList[index]),
            ),
            Text(
              Date.getWeekday(dateList[index]),
            )
          ],
        )
      ],
    );
  }

  ListView getExerciseListView() {
    dateList.clear();
    return ListView.builder(
        itemCount: exerciseList.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (content, i) {
          if (!dateList.contains(exerciseList[i].date)) {
            dateList.add(exerciseList[i].date);
            return getDateList(i);
          }
          return getListDetail(i);
        });
  }

  InkWell getListDetail(int i) {
    return InkWell(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10), // give it width
          Row(children: <Widget>[
            SizedBox(width: 10),
            Text(
              exerciseList[i].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 40), // give it width
            Text(exerciseList[i].description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                )),
          ]),
        ],
      ),
      onTap: () {
        debugPrint('clicked');
        navigateToDetail(this.exerciseList[i], 'Edit Exercise');
      },
    );
  }


  Column getDateList(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15), // give it width
        Row(
          children: <Widget>[
            SizedBox(width: 10),
            Text(
              Date.getDay(exerciseList[i].date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(width: 20), // give it width
            Column(
              children: <Widget>[
                Text(
                  Date.getYearMonth(exerciseList[i].date),
                ),
                Text(
                  Date.getWeekday(exerciseList[i].date),
                )
              ],
            )
          ],
        ),

        SizedBox(height: 10), // give it width

        Container(height: 1.5, color: Colors.black),

        SizedBox(height: 10), // give it width

        getListDetail(i),
      ],
    );
  }

  ListView getExerciseContent(int index) {
    List<Exercise> exercise = new List<Exercise>();
    exercise.clear();
    exercise = new List<Exercise>.from(dateMap[dateList[index]]);
    return new ListView.builder(
        itemCount: exercise.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext ctx, int i) {
          return new ListTile(
            key: Key("${index}"),
            title: Text('Title =' + exercise[i].title),
          );
        });
  }

  void updateDateList(Exercise exercise) {
    String date = exercise.date;
    if (!dateList.contains(date)) {
      dateList.add(date);
    } else {
      print('updateDateList(): date already added');
    }
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
          this.exerciseList.sort((a, b) => a.exerciseId
              .toLowerCase()
              .toString()
              .compareTo(b.exerciseId.toLowerCase().toString()));
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
