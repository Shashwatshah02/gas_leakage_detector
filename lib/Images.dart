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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < valueToShow.length; i++)
                Image.network(
                  valueToShow[i],
                  width: 300,
                  height: 300,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
