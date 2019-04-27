import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:martin/steps/stepTwo.dart';

import '../utils.dart' as utils;

class StepOnePage extends StatefulWidget {

  final Map steps;
  final int idx = 0;
  StepOnePage({Map steps, int idx}) : this.steps = steps;

  @override
  _StepPageState createState() => _StepPageState(steps);
}

class _StepPageState extends State<StepOnePage> {

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
                "What is the safe word?",
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