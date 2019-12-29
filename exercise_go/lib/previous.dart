import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  List<String> _titles = [];
  static String title = "Title";
  static String content = "content";
  void _addEvent(){
    _titles.add(title+" "+_titles.length.toString());
    debugPrint(_titles[_titles.length-1]);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Go',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exercise Go'),
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(child: new ListView.builder(
                itemBuilder: (BuildContext context, int Index) {
                  return new Text(_titles[Index]);
                }
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addEvent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}