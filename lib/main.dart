import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import './utils.dart' as utils;
import './bdaycheck.dart' as bday;

void main() async {
  Map steps = await utils.loadSteps();
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
    // if(bDay.difference(now).inDays > 0) {
    //   page = bday.PrebdayPage(); 
    // }
    
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
  Position currentLoc;
  String answer = "";
  String answerStatus;
  TextEditingController _ansController = TextEditingController();
  bool near = true;

  _StepPageState(this.steps, this.idx);

  Future _incIndex() async {
    var step = this.steps['steps'][this.idx];
    
    var rightAns = false;
    var ans = step['answer']['content'];
    var type = step['answer']['type'];
    switch (type) {
        case 'text':
          print(step['answer']['content']);
          if(this._ansController.text.toLowerCase() == ans.toString().toLowerCase()) {
              print('NAILED IT');
              rightAns = true;
          }
          break;
        case 'gps':
          double distanceInMeters = await Geolocator().distanceBetween(this.currentLoc.latitude, this.currentLoc.latitude, ans['lat'], ans['lng']);
          
          break;
        default:
          break;
    }
    
    if (rightAns) {
      // TODO check if at last step
      setState(() {
        this.idx++;
        this._ansController.text = "";
        if (type == 'text') {
          this.near = false;
        } else {
          this.near = true;
        }
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

  void _setLoc(Position data) {
    setState(() {
      this.currentLoc = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    utils.getLiveLocation().onData((data) async {
      print(data);
      var ans = this.steps['steps'][this.idx]['answer']['content'];
      double distanceInMeters = await Geolocator().distanceBetween(this.currentLoc.latitude, this.currentLoc.latitude, ans['lat'], ans['lng']);
      if(distanceInMeters < 30) {
        setState(() {
          this.near = true;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Martin's Mystery Menagerie")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Padding(
              child: Text(
                this.steps['steps'][this.idx]['question'],
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(bottom: 15.0)
            ),
            TextField(
              controller: _ansController,
              enabled: this.near,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal)
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, size: 24.0),
                  onPressed: () {
                    setState(() {
                      this._ansController.text = "";
                    });
                  },
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

