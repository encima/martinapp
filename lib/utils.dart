import 'dart:async' show Future, StreamSubscription;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
Future<String> _loadSteps() async {
  return await rootBundle.loadString('assets/hunt.json');
}
	
Future loadSteps() async {
  String stepsString = await _loadSteps();
  Map stepsJson = jsonDecode(stepsString);
  return stepsJson;
}

StreamSubscription<Position> getLiveLocation() {
  var geolocator = Geolocator()..forceAndroidLocationManager = true;
  
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  print("Getting location");
  Geolocator().checkGeolocationPermissionStatus().then((permission) {
    print(permission);
  });
  StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
      (Position _position) {
          print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
      });

  return positionStream;
}

Future<double> getDistance(Position p, double destLat, double destLng) async {
  return await Geolocator().distanceBetween(p.latitude, p.longitude, destLat, destLng);
}

Future nextStep(route, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("CURRENT_STEP", route);
  Navigator.pushNamed(context, route);
}
