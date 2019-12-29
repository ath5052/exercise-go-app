import 'package:flutter/material.dart';

class ComplexListDisplay extends StatefulWidget {
  @override
  State createState() => new DyanmicList();
}

class DyanmicList extends State<ComplexListDisplay> {
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  static String title = "Title";
  ScrollController _scrollController = new ScrollController();
  static var now = new DateTime.now();
  static int year = now.year;
  static int month = now.month;
  static int day = now.day;
  static int weekday = now.weekday;
  var weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  Set<String> daySet;

  static bool single(int i) {
    if (i < 10) {
      return true;
    }
    return false;
  }

  static String day_str() {
    if (single(day))
      return "0" + day.toString();
    else
      return day.toString();
  }

  String today = year.toString() + month.toString() + day_str();

  String date = year.toString() + "-" + month.toString();

  //String today =
  //String today = now.year.toString() +"."+now.month.toString();

  void _addEvent() {
    daySet.add(today);
    litems.add(title + " " + (litems.length + 1).toString());
    ////debugPrint(litems[litems.length - 1]);
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Exercise Go"),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
              //flex: 100,
              child: new ListView.builder(
                  itemCount: litems.length,
                  controller: _scrollController,
                  //reverse: true,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return new Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  day_str(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(width: 20), // give it width
                                Column(
                                  children: <Widget>[
                                    Text(
                                      date,
                                    ),
                                    Text(
                                      weekdays[weekday - 1],
                                    )
                                  ],
                                )
                              ],
                            ),

                            SizedBox(height: 10), // give it width

                            Container(height: 1.5, color: Colors.black),

                            SizedBox(height: 10), // give it width

                            Row(
                              children: <Widget>[
                                Text(
                                  litems[Index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(width: 40), // give it width
                                Text('content',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20,
                                    )),
                              ],
                            )
                          ],
                        ));
                  }))
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _addEvent();
          setState(() {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
