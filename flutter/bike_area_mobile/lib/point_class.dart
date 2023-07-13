import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bike_area_mobile/api_request.dart';
import 'package:bike_area_mobile/comments.dart';
import 'package:http/http.dart';

class Point {
  Point(
      {required this.pin_id,
      required this.label,
      required this.latitude,
      required this.longitude,
      required this.upload_time});
  int pin_id;
  int label;
  double latitude;
  double longitude;
  DateTime upload_time;

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      pin_id: json['pin_id'] as int,
      label: json['danger'] as int,
      latitude: json['lati'] as double,
      longitude: json['longi'] as double,
      upload_time: DateTime.parse(json['time']) as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pin_id': pin_id,
      'danger': label,
      'latitude': latitude,
      'longitude': longitude,
      'timetude': upload_time.toString(),
    };
  }
}

List<Point> parsePoints(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Point>((json) => Point.fromJson(json)).toList();
}

BitmapDescriptor getIcon(int label) {
  if (label == 0) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  } else if (label == 1) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  } else {
    return BitmapDescriptor.defaultMarker;
  }
}

class Points {
  List<Point> point_list = [];
  Set<Marker> markers = {};
  Client client = Client();
  Points();

  Future update_Points(BuildContext context) async {
    point_list = await fetchPoints1(client);
    markers = {};
    for (var point in point_list) {
      markers.add(
        Marker(
          markerId: MarkerId(point.pin_id.toString()),
          position: LatLng(point.latitude, point.longitude),
          icon: getIcon(point.label),
          onTap: () {
            // show comment list page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentListPage(
                    pin_id: point.pin_id, upload_time: point.upload_time),
              ),
            );
          },
        ),
      );
    }
  }
}
