import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exercise_go/Model/exercise.dart';
import 'package:exercise_go/Controller/database_helper.dart';
import 'package:intl/intl.dart';

class ExerciseDetail extends StatefulWidget {
  final String appBarTitle;
  final Exercise exercise;


  ExerciseDetail(this.exercise, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ExerciseDetailState(this.exercise, this.appBarTitle);
  }
}

class ExerciseDetailState extends State<ExerciseDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Exercise exercise;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ExerciseDetailState(this.exercise, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = exercise.title;
    descriptionController.text = exercise.description;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of exercise object
  void updateTitle() {
    exercise.title = titleController.text;
  }

  // Update the description of exercise object
  void updateDescription() {
    exercise.description = descriptionController.text;
  }

  String _add0(String s) {
    if(s.length<2)
      return s = '0' + s;
    else
      return s;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    String year = DateFormat.y().format(DateTime.now());
    String month = DateFormat.M().format(DateTime.now());
    String day = DateFormat.d().format(DateTime.now());
    String weekday = DateFormat.E().format(DateTime.now());

    exercise.date = year +  _add0(month) +  _add0(day) + weekday;
    exercise.exerciseId = year +  _add0(month) +  _add0(day) + exercise.title;

    int result;
    if (exercise.id != null) {
      // Case 1: Update operation
      result = await helper.updateExercise(exercise);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertExercise(exercise);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Exercise Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Exercise');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW exercise i.e. he has come to
    // the detail page by pressing the FAB of exerciseList page.
    if (exercise.id == null) {
      _showAlertDialog('Status', 'No Exercise was deleted');
      return;
    }

    // Case 2: User is trying to delete the old exercise that already has a valid ID.
    int result = await helper.deleteExercise(exercise.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Exercise Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Exercise');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
