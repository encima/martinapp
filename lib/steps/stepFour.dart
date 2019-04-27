import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:martin/steps/stepThree.dart';

import '../utils.dart' as utils;

class StepFourPage extends StatefulWidget {

  final Map steps;
  final int idx = 0;
  StepFourPage({Map steps, int idx}) : this.steps = steps;

  @override
  _StepPageState createState() => _StepPageState(steps);
}

class _StepPageState extends State<StepFourPage> {

  Map steps;

  String answer = "horseshoe";
  String answerStatus;
  TextEditingController _ansController = TextEditingController();
  double near = 1000;
  StreamSubscription<Position> positionStream;

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

    var geolocator = Geolocator();
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Martin's Mystery Menagerie")
      ),
      body:
       Builder(
        builder: (context) =>  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text(
                "In the old town, many have shouted 'What the Dickens?', because it is not an easy place to find. \n One must twist and turn around many corners...",
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(bottom: 15.0)
            ),
            MaterialButton(
              child: Text("Am I Here?"),
              onPressed: () async {
                Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                var distBetween = await geolocator.distanceBetween(position.latitude, position.longitude, 47.3722513, 8.5421044);
                if(distBetween < 50) {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("You made it!" + distBetween.toString() + "m more!"),
                  ));
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return StepThreePage();
                  }));
                } else {
                  print("Noch nicht");
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("Not yet..." + distBetween.toString() + "m more!"),
                  ));
                }
              },
            ),            
          ],
        ),
      )
       )
    );
  }
}