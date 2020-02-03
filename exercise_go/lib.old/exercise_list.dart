import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/exercise.dart';
import 'package:exercise_go/View/exercise_detail.dart';
import 'package:exercise_go/Controller/database_helper.dart';
import 'package:grouped_list/grouped_list.dart';
import "package:collection/collection.dart";
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
  static var now = new DateTime.now();
  static int year = now.year;
  static int month = now.month;
  static int day = now.day;
  static int weekday = now.weekday;

  var weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> dayList = new List<String>();
  Map<String, List<Exercise>> exerciseMap = new Map<String, List<Exercise>>();

  static String getYearMonth(String date) {
    return date.substring(0, 4) + '-' + date.substring(4, 6);
  }


  var testmap;

  void test(){
    testmap = groupBy(dayList, (obj) => obj[date]);
  }



  static String getDay(String date) {
    return date.substring(6, 8);
  }

  static String getWeekDay(String date) {
    return date.substring(8, 11);
  }

  String date = year.toString() + "-" + month.toString();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (exerciseList == null) {
      exerciseList = List<Exercise>();
      updateListView();
    }
    print(exerciseList);
    //test();

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Go'),
      ),
      body: getExerciseListView(),
     // getGroupListView(),
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

  Padding getPadding() {}

  Row getDateTilteRow(int index) {
    return new Row(
      children: <Widget>[
        Text(
          getDay(dayList[index]),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        SizedBox(width: 20), // give it width
        Column(
          children: <Widget>[
            Text(
              getYearMonth(dayList[index]),
            ),
            Text(
              //weekdays[weekday - 1],
              getWeekDay(dayList[index]),
              //dayList[index],
            )
          ],
        )
      ],
    );
  }

  GroupedListView getGroupListView() {
    return new GroupedListView<dynamic, String>(
      elements: this.exerciseList,
      groupBy: (element) => element['date'],
      groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ))),
      itemBuilder: (c, element) {
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Icon(Icons.account_circle),
              title: Text(element['title']),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        );
      },
    );
  }

  ListView getExerciseContent(int index) {
    List<Exercise> exercise = new List<Exercise>();
    exercise.clear();
    exercise = new List<Exercise>.from(exerciseMap[dayList[index]]);
    return new ListView.builder(
        itemCount: exercise.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext ctx, int i) {
          return new ListTile(
            //children: <Widget>[
            key: Key("${index}"),
            title: Text('Title =' + exercise[i].title),
            // ],
          );
        });
  }

  void addDayList(Exercise exercise) {
    print(exercise.title);
    String date = exercise.date;
    List<Exercise> exerciseListGroupByDate = new List<Exercise>();
    List<Exercise> listCopy = new List<Exercise>();

    if (!dayList.contains(date)) dayList.add(date);

    if (exerciseMap[date]?.isNotEmpty ?? false)
      exerciseListGroupByDate = exerciseMap[date];

    if (!exerciseListGroupByDate.contains(exercise))
      exerciseListGroupByDate.add(exercise);
    listCopy.clear();
    listCopy = new List<Exercise>.from(exerciseListGroupByDate);
    exerciseMap.update(date, (v) => listCopy, ifAbsent: () => listCopy);
    exerciseListGroupByDate.clear();
    //listCopy.clear();
  }

  ListView getExerciseListView() {
    exerciseList.forEach((Exercise exercise) => addDayList(exercise));
    setState(() {});
    return ListView.builder(
      itemCount: dayList.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return new Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getDateTilteRow(index),
              SizedBox(height: 10), // give it width
              Container(height: 1.5, color: Colors.black),
              SizedBox(height: 10), // give it width
              getExerciseContent(index),
              //getDateExerciseContentRow(index),
            ],
          ),
        );
      },
    );
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
