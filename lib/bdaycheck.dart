import 'dart:math';

import 'package:flutter/material.dart';

class PrebdayPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var preChecks = [
      "Why are you STILL checking?",
      "Nope, it is still not the 6th May",
      "Is it the 6th May and this is showing? Chris messed up",
      "Patience is a virtue",
      "Now you are just wasting battery power"
    ];
    var rand = new Random();

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
            Text(
              preChecks[rand.nextInt(preChecks.length-1)]
            ),
            EditableText(
              controller: TextEditingController(),
              focusNode: FocusNode(),
              cursorColor: Colors.white,
              backgroundCursorColor: Colors.black,
              style: Theme.of(context).textTheme.display1,
            ),
            
          ],
        ),
      ),
    );
  }

}
