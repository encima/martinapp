import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:martin/steps/stepTwo.dart';

import '../utils.dart' as utils;

class StepThreePage extends StatefulWidget {

  final Map steps;
  final int idx = 0;
  StepThreePage({Map steps, int idx}) : this.steps = steps;

  @override
  _StepPageState createState() => _StepPageState(steps);
}

class _StepPageState extends State<StepThreePage> {

  Map steps;

  String answer = "horseshoe";
  String answerStatus;
  TextEditingController _ansController = TextEditingController();
  bool near = true;

  _StepPageState(this.steps);

  Future _incIndex() async {
    
    var rightAns = false;
    if(this._ansController.text.toLowerCase() == this.answer.toString().toLowerCase()) {
        print('NAILED IT');
        rightAns = true;
    }
    
    if (rightAns) {
       Navigator.push(context, MaterialPageRoute(builder: (_) {
            return StepTwoPage();
          }));
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

  @override
  Widget build(BuildContext context) {

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
                "A state, but not of mind. A girls name, but partly for men. \n Take a look at the menu and order this drink...",
                maxLines: null,
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(bottom: 15.0)
            ),
            Padding(
              child: Text(
                "The drink you order here is important. Order any other drink and I am afraid you will not receive the clue for the next step...",
                maxLines: null,
                textAlign: TextAlign.left,
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
                hintText: "Enter the code here...",
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