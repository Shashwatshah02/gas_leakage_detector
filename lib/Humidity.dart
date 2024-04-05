import 'package:flutter/material.dart';

class HumidityPage extends StatelessWidget {
  final String valueToShow;

  const HumidityPage({Key? key, required this.valueToShow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity'),
      ),
      body: Center(
        child: Text(
          valueToShow + ' %',
          style: TextStyle(
            fontSize: 48.0, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
