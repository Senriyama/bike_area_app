import 'package:bike_area_mobile/point_class.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bike_area_mobile/api_request.dart';

class UploadWidget extends StatefulWidget {
  final LatLng init_location;
  final Points init_points;
  UploadWidget({required this.init_location, required this.init_points});

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  late Marker marker;

  Points init_points = Points();
  Points showedpoints = Points();
  bool _isuploading = false;
  bool _uploadSuccess = false;

  void initState() {
    super.initState();
    init_points = widget.init_points;
    showedpoints = init_points;
  }

  // show upload confirmation dialog
  void showUploadDialog(LatLng location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Confirmation'),
          content: Text('Do you want to upload this location?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startUpload(location);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _startUpload(LatLng location) {
    setState(() {
      _isuploading = true;
      _uploadSuccess = false;
    });
    postPoints(1, location.latitude, location.longitude).then((value) {
      setState(() {
        _isuploading = false;
        _uploadSuccess = true;
        // SnackBar to show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // upload success message with green background color
            backgroundColor: Colors.green,
            content: Text(
              'Upload Success',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    }).catchError((error) {
      setState(() {
        _isuploading = false;
        _uploadSuccess = false;
      });
      // SnackBar to show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // upload error message with red color
          backgroundColor: Colors.red,
          content: Text(
            'Upload Error',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Picker'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: widget.init_location, // 初期のカメラ位置
              zoom: 15.0,
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onTap: (LatLng location) {
              setState(() {
                selectedLocation = location;
                marker = Marker(
                  markerId: MarkerId('selected-location'),
                  position: selectedLocation!,
                );
                showedpoints = init_points;
                showedpoints.markers.add(marker);
              });
            },
            markers: showedpoints.markers,
          ),
          // Upload button with Icon
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (selectedLocation != null) {
                  showUploadDialog(selectedLocation!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a location'),
                    ),
                  );
                }
              },
              child: Icon(Icons.upload),
            ),
          ),
          // show progress indicator
          if (_isuploading)
            Positioned.fill(
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
