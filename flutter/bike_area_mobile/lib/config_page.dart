import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _walk_bike_Controller = TextEditingController();
  final TextEditingController _bike_car_Controller = TextEditingController();
  final TextEditingController _time_to_notify_Controller =
      TextEditingController();
  final TextEditingController _search_radius_Controller =
      TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _walk_bike_Controller.text =
          _prefs.getInt('walk_bike_threshould')?.toString() ?? '10';
      _bike_car_Controller.text =
          _prefs.getInt('bike_car_threshould')?.toString() ?? '5';
      _time_to_notify_Controller.text =
          _prefs.getInt('time_to_notify')?.toString() ?? '3';
      _search_radius_Controller.text =
          _prefs.getInt('search_radius')?.toString() ?? '50';
    });
  }

  Future<void> _savePrefs() async {
    // validation check
    // input validation check
    if (!RegExp(r'^[0-9]+$').hasMatch(_walk_bike_Controller.text)) {
      showValidationDialog('Walk Bike Threshould must be integer');
      return;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_bike_car_Controller.text)) {
      showValidationDialog('Bike Car Threshould must be integer');
      return;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_time_to_notify_Controller.text)) {
      showValidationDialog('Time to Notify must be integer');
      return;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_search_radius_Controller.text)) {
      showValidationDialog('Search Radius must be integer');
      return;
    }
    // logical validation check
    if (int.parse(_walk_bike_Controller.text) >
        int.parse(_bike_car_Controller.text)) {
      showValidationDialog(
          'Walk Bike Threshould must be smaller than Bike Car Threshould');
      return;
    } else if (int.parse(_walk_bike_Controller.text) < 1) {
      showValidationDialog('Walk Bike Threshould must be bigger than 0');
      return;
    } else if (int.parse(_bike_car_Controller.text) < 1) {
      showValidationDialog('Bike Car Threshould must be bigger than 0');
      return;
    } else if (int.parse(_time_to_notify_Controller.text) < 1) {
      showValidationDialog('Time to Notify must be bigger than 0');
      return;
    } else if (int.parse(_search_radius_Controller.text) < 1) {
      showValidationDialog('Search Radius must be bigger than 0');
      return;
    }

    await _prefs.setInt(
        'walk_bike_threshould', int.parse(_walk_bike_Controller.text));
    await _prefs.setInt(
        'bike_car_threshould', int.parse(_bike_car_Controller.text));
    await _prefs.setInt(
        'time_to_notify', int.parse(_time_to_notify_Controller.text));
    await _prefs.setInt(
        'search_radius', int.parse(_search_radius_Controller.text));
    // success dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Config saved'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _walk_bike_Controller,
              decoration: InputDecoration(
                labelText: 'Walk Bike Threshould',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _bike_car_Controller,
              decoration: InputDecoration(
                labelText: 'Bike Car Threshould',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _time_to_notify_Controller,
              decoration: InputDecoration(
                labelText: 'Time to Notify',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _search_radius_Controller,
              decoration: InputDecoration(
                labelText: 'Search Radius',
              ),
            ),
            // save button
            ElevatedButton(
              onPressed: () {
                _savePrefs();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
