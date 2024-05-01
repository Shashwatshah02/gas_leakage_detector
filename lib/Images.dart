import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final List valueToShow;

  const ImagePage({Key? key, required this.valueToShow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: valueToShow.map((item) {
            return Text(
              item,
              style: TextStyle(
                fontSize: 48.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
