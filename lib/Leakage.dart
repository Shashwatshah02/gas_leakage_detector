import 'package:flutter/material.dart';

class LeakagePage extends StatelessWidget {
  final String valueToShow;

  const LeakagePage({Key? key, required this.valueToShow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gas Leakage'),
      ),
      body: Center(
        child: Text(
          valueToShow + 'V',
          style: TextStyle(
            fontSize: 48.0, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
