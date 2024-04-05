import 'package:flutter/material.dart';

class TemperaturePage extends StatelessWidget {
  final String valueToShow;

  const TemperaturePage({Key? key, required this.valueToShow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature'),
      ),
      body: Center(
        child: Text(
          valueToShow.toString() + ' C',
          style: TextStyle(
            fontSize: 48.0, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
