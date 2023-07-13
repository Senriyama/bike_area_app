import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bike_area_mobile/notification.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bike_area_mobile/api_request.dart';

enum MovePattern { walk, bike, car }

// set parameters

LocationData initLocation = LocationData.fromMap({
  'latitude': 35.026866,
  'longitude': 135.7821307,
  'accuracy': 0.0,
  'altitude': 0.0,
  'speed': 0.0,
  'speedAccuracy': 0.0,
  'heading': 0.0,
  'time': 0.0,
});

class MoveState {
  // time to change move pattern
  int timeAlterPattern = 5;
  // speed to change move pattern
  int threWalk = 1;
  int threBike = 30;
  // search radius
  int searchRadius = 50;
  // counter to record each time
  int walk = 0;
  int bike = 0;
  int car = 0;
  double speed = 0;
  // current temporal move pattern
  MovePattern temporalPattern = MovePattern.walk;
  // current move pattern
  MovePattern currentPattern = MovePattern.walk;
  // last move pattern
  MovePattern lastPattern = MovePattern.walk;
  LocationData currentPosition = initLocation;
  final Location location = Location();
  http.Client client = http.Client();
  bool isParked = false;

  // update counters
  void add_walk() {
    walk++;
    bike = 0;
    car = 0;
  }

  void add_bike() {
    walk = 0;
    bike++;
    car = 0;
  }

  void add_car() {
    walk = 0;
    bike = 0;
    car++;
  }

  // change temporal and current move pattern
  void change_move_pattern(MovePattern movePattern) {
    this.temporalPattern = movePattern;
    if (movePattern == MovePattern.walk) {
      add_walk();
    } else if (movePattern == MovePattern.bike) {
      add_bike();
    } else if (movePattern == MovePattern.car) {
      add_car();
    }
    if (walk > timeAlterPattern) {
      lastPattern = currentPattern;
      currentPattern = MovePattern.walk;
      set_parking();
    } else if (bike > timeAlterPattern) {
      lastPattern = currentPattern;
      currentPattern = MovePattern.bike;
    } else if (car > timeAlterPattern) {
      lastPattern = currentPattern;
      currentPattern = MovePattern.car;
    }
  }

  // set parking notification
  void set_parking() {
    if ((currentPattern == MovePattern.walk &&
            lastPattern == MovePattern.bike) ||
        (currentPattern == MovePattern.walk &&
            lastPattern == MovePattern.car)) {
      isParked = true;
      // fetch nearby points and if not empty, notify
      fetchRadiusPoints1(client, searchRadius.toDouble(),
              currentPosition.latitude!, currentPosition.longitude!, 1)
          .then((value) => {
                if (value.isNotEmpty)
                  {
                    notifyNow(
                        title: 'Warning',
                        body: 'You might have parked in a non-safe area!')
                  }
              })
          .catchError((error) =>
              {SnackBar(content: Text('Error: Cannot fetch nearby points'))});
    }
  }

  // change move pattern and set parking notification
  void change_move_state() {
    if (speed < threWalk) {
      change_move_pattern(MovePattern.walk);
    } else if (speed < threBike) {
      change_move_pattern(MovePattern.bike);
    } else {
      change_move_pattern(MovePattern.car);
    }
  }

  // get current position and speed
  void set_location() async {
    try {
      loadPrefs();
      currentPosition = await location.getLocation();
      speed = currentPosition.speed! * 3.6;
      change_move_state();
    } catch (e) {
      print(e);
    }
  }

  // set background mode
  void set_background_mode() {
    location.enableBackgroundMode(enable: true);
  }

  // get latitude and longitude
  double get_latitude() {
    return currentPosition.latitude!;
  }

  double get_longitude() {
    return currentPosition.longitude!;
  }

  void loadPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      threWalk = prefs.getInt('walk_bike_threshould') ?? 1;
      threBike = prefs.getInt('bike_car_threshould') ?? 30;
      timeAlterPattern = prefs.getInt('time_to_notify') ?? 5;
      searchRadius = prefs.getInt('search_radius') ?? 50;
    });
  }
}
