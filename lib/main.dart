import 'dart:async';

import 'package:flutter/material.dart';

import './utils.dart' as utils;
import './bdaycheck.dart' as bday;

void main() async {
  Map steps = await utils.loadSteps();
  utils.getLiveLocation().onData((data) {
    print(data);
  });
  runApp(MartinApp(steps: steps));
}

class MartinApp extends StatefulWidget {

  final Map steps;
  MartinApp({Map steps}) : this.steps = steps;

  @override
  _MartinState createState() => _MartinState(steps);
}

class _MartinState extends State<MartinApp> {
  Map steps;


  _MartinState(this.steps);

  var now = new DateTime.now();
  var bDay = new DateTime(2019,5,6);
  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget page = StepPage(steps: this.steps, idx: 0);
    if(bDay.difference(now).inDays > 0) {
      page = bday.PrebdayPage(); 
    }
    
    return MaterialApp(
      title: 'Martin',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: page,
    );
  }
}

class StepPage extends StatefulWidget {

  final Map steps;
  final int idx = 0;
  StepPage({Map steps, int idx}) : this.steps = steps;

  @override
  _StepPageState createState() => _StepPageState(steps, idx);
}

class _StepPageState extends State<StepPage> {

  Map steps;
  int idx;
  String answer = "";
  String answerStatus;

  _StepPageState(this.steps, this.idx);

  void _incIndex() {
    var step = this.steps['steps'][this.idx];
    
    var rightAns = false;
    switch (step['answer']['type']) {
        case 'text':
          print(step['answer']['content']);
          if(this.answer.toLowerCase() == step['answer']['content'].toString().toLowerCase()) {
              print('NAILED IT');
              rightAns = true;
          }
          break;
        case 'gps':
          break;
        default:
          break;
    }
    
    if (rightAns) {
      // TODO check if at last step
      setState(() {
        this.idx++;
      });
    } else {
      setState(() {
        this.answerStatus = "Oooof, so close. Maybe? I have no idea what you entered.";        
      });
      Timer(new Duration(seconds: 5), () {
        setState(() {
          this.answerStatus = null;
        });
        
      });
    }
  }

  void _setAnswer(String input) {
    setState(() {
      this.answer = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Martin's Mystery Menagerie")
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText:this.steps['steps'][this.idx]['question'] 
              )
              
            ),
            TextField(
              onChanged: (text) {
                _setAnswer(text);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal)
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)
                ),
                hintText: "Well, what is it? Tell me here!",
                errorText: answerStatus
              ),
            ),
            
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incIndex,
        tooltip: 'I think I know...',
        child: Icon(Icons.forward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

