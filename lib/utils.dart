import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
 
Future<String> _loadSteps() async {
  return await rootBundle.loadString('assets/hunt.json');
}
	
Future loadSteps() async {
  String stepsString = await _loadSteps();
  Map stepsJson = jsonDecode(stepsString);
  return stepsJson;
}
