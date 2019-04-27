import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import './utils.dart' as utils;
import 'package:martin/steps/stepOne.dart';
import 'package:martin/steps/stepTwo.dart';
import 'package:martin/steps/stepThree.dart';
import 'package:martin/steps/stepFour.dart';
import 'package:martin/steps/stepFive.dart';
import 'package:martin/steps/stepSix.dart';
import 'package:martin/steps/stepSeven.dart';
import './bdaycheck.dart' as bday;

void main() async {
  Map steps = await utils.loadSteps();
  runApp(MaterialApp(
    title: "Martin's Mystery Menagerie",
    initialRoute: '/',
    routes: {
      '/': (context) => MartinApp(steps: steps),
      '/stepOne': (context) => StepOnePage(steps: steps),
      '/stepTwo': (context) => StepTwoPage(steps: steps),
      '/stepThree': (context) => StepThreePage(steps: steps),
      '/stepFour': (context) => StepFourPage(steps: steps),
      '/stepFive': (context) => StepFivePage(steps: steps),
      '/stepSix': (context) => StepSixPage(steps: steps),
      '/stepSeven': (context) => StepSevenPage(steps: steps),
    },
  )
    
    
    );
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
    Widget page = StepPage(steps: this.steps);
    // if(bDay.difference(now).inDays > 0) {
    //   page = bday.PrebdayPage(); 
    // }
    
    return MaterialApp(
      title: 'Martin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: page,
    );
  }
}