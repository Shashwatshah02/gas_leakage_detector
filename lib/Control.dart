import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_detector/Home.dart';
import 'package:gas_leakage_detector/Humidity.dart';
import 'package:gas_leakage_detector/Leakage.dart';

import 'Temperature.dart';

class ControlPage extends StatefulWidget {
  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final wheel = FirebaseFirestore.instance.collection('wheels');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Page'),
      ),
      body: Container(
        color: Color(0xff51C3C9),
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: [
            _buildButton(
              context,
              Icons.thermostat_rounded,
              'Temperature',
              onPressed: () async {
                DocumentSnapshot docSnapshot =
                    await wheel.doc('temperature').get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TemperaturePage(
                            valueToShow: docSnapshot.get('temp'),
                          )),
                );
              },
            ),
            _buildButton(
              context,
              Icons.opacity_rounded,
              'Humidity',
              onPressed: () async {
                DocumentSnapshot docSnapshot =
                    await wheel.doc('humidity').get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HumidityPage(
                            valueToShow: docSnapshot.get('hum'),
                          )),
                );
              },
            ),
            _buildButton(
              context,
              Icons.warning_rounded,
              'Check Gas Leakage',
              onPressed: () async {
                DocumentSnapshot docSnapshot = await wheel.doc('leakage').get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeakagePage(
                            valueToShow: docSnapshot.get('leakage'),
                          )),
                );
              },
            ),
            _buildButton(
              context,
              Icons.camera_alt_rounded,
              'Capture Image',
              onPressed: () {
                // Handle image capture button press
              },
            ),
            _buildButton(
              context,
              Icons.image_rounded,
              'View Image',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ControlPage()),
                );
              },
            ),
            _buildButton(
              context,
              Icons.lightbulb_rounded,
              'Switch On Torch',
              onPressed: () {
                // Handle torch switch button press
              },
            ),
            _buildButton(
              context,
              Icons.location_on_rounded,
              'Check Location',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ControlPage()),
                );
              },
            ),
            _buildButton(
              context,
              Icons.arrow_back_rounded,
              'Back',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label,
      {void Function()? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0),
          SizedBox(height: 10.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
