import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  final String latValue;
  final String lngValue;

  const LocationPage({Key? key, required this.latValue, required this.lngValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Latitude :' + latValue,
              style: TextStyle(
                fontSize: 48.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Longitude :' + lngValue,
              style: TextStyle(
                fontSize: 48.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
