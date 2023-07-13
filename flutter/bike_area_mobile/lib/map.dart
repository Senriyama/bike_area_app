import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bike_area_mobile/request_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bike_area_mobile/move_state.dart';
import 'package:bike_area_mobile/point_class.dart';
import 'package:bike_area_mobile/config_page.dart';
import 'package:bike_area_mobile/upload.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // notification key

  late GoogleMapController mapController;
  bool _permission = false;
  bool _periodic = false;
  MoveState moveState = MoveState();
  Points points = Points();
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _refreshPage() {
    checkLocationPermission(context).then((_) {
      Geolocator.checkPermission().then((value) {
        if (value == LocationPermission.always) {
          moveState.set_background_mode();
          setState(() {
            _permission = true;
            if (!_periodic) {
              _periodic = true;
              Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() {
                  moveState.set_location();
                  // TODO
                  points.update_Points(context);
                });
              });
            }
          });
        } else {
          setState(() {
            _permission = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission(context).then((value) {
      if (value == LocationPermission.always) {
        moveState.set_background_mode();
        setState(() {
          _permission = true;
        });
        if (!_periodic) {
          _periodic = true;
          Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {
              moveState.set_location();
              // TODO
              points.update_Points(context);
            });
          });
        }
      }
    });
  }

  Widget getPageWidget() {
    if (_permission) {
      var circle_color1 = Colors.green;
      switch (moveState.temporalPattern) {
        case MovePattern.walk:
          circle_color1 = Colors.green;
          break;
        case MovePattern.bike:
          circle_color1 = Colors.blue;
          break;
        case MovePattern.car:
          circle_color1 = Colors.red;
          break;
      }
      var circle_color2 = Colors.green;
      switch (moveState.currentPattern) {
        case MovePattern.walk:
          circle_color2 = Colors.green;
          break;
        case MovePattern.bike:
          circle_color2 = Colors.blue;
          break;
        case MovePattern.car:
          circle_color2 = Colors.red;
          break;
      }
      return Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  // LatLng(currentPosition.latitude!, currentPosition.longitude!),
                  LatLng(moveState.get_latitude(), moveState.get_longitude()),
              zoom: 15,
            ),
            markers: points.markers,
          ),
          Positioned(
            bottom: 150,
            right: 0,
            child: Column(
              children: [
                Text('緯度: ${moveState.get_latitude()}'),
                Text('経度: ${moveState.get_longitude()}'),
                Text('速度: ${moveState.speed}'),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: circle_color1,
                  ),
                  Text('一時状態: ${moveState.temporalPattern}'),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: circle_color2,
                  ),
                  Text('移動状態: ${moveState.currentPattern}'),
                  Text('walk: ${moveState.walk}'),
                  Text('bike: ${moveState.bike}'),
                  Text('car: ${moveState.car}'),
                ],
              ),
            ),
          ),
          Positioned(
              child: Container(
            color: Colors.white,
            child: Row(children: [
              //show Location Permission
              Text('Location Permission: '),
              CircleAvatar(
                radius: 10,
                backgroundColor: _permission ? Colors.green : Colors.red,
              ),
              // show Periodic Service
              Text('Periodic Service: '),
              CircleAvatar(
                radius: 10,
                backgroundColor: _periodic ? Colors.green : Colors.red,
              ),
            ]),
          )),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TODO upload page
                  IconButton(
                    icon: Icon(Icons.upload),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadWidget(
                                init_location: LatLng(moveState.get_latitude(),
                                    moveState.get_longitude()),
                                init_points: points)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfigPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          // refresh button
          Positioned(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _refreshPage();
              },
            ),
            bottom: 100,
            right: 10,
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('位置情報の許可を常に許可してください',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
          Center(
            child: ElevatedButton.icon(
              label: Text('設定'),
              icon: Icon(Icons.settings),
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _refreshPage();
              },
              icon: Icon(Icons.refresh),
              label: Text('再読み込み'),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Google Maps'),
        ),
        body: getPageWidget());
  }
}
