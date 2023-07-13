import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void requestLocationPermission(BuildContext context) async {
  await Geolocator.requestPermission().then((value) {
    if (value == LocationPermission.denied) {
      showLocationPermissionDialog(context);
    }
  });
}

Future<LocationPermission> checkLocationPermission(BuildContext context) async {
  final per = await Geolocator.checkPermission().then((value) {
    if (value == LocationPermission.denied) {
      requestLocationPermission(context);
    }
    return value;
  });
  return per;
}

void showLocationPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('位置情報の許可が必要です'),
        content: Text('位置情報を取得するためには、位置情報の許可が必要です。設定画面で許可してください。'),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
            },
            icon: Icon(Icons.settings),
            label: Text('設定'),
          )
        ],
      );
    },
  );
}
