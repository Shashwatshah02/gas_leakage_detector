import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_detector/Home.dart';
import 'package:gas_leakage_detector/Humidity.dart';
import 'package:gas_leakage_detector/Images.dart';
import 'package:gas_leakage_detector/Leakage.dart';
import 'package:gas_leakage_detector/Location.dart';

import 'Temperature.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final collection = FirebaseFirestore.instance.collection('users');
  final document = FirebaseFirestore.instance.collection('users').doc('pi');
  List<String> imageUrls = [];
  bool torch1 = false;
  bool capture_img = false;
  String temperature = '0';

  late DocumentSnapshot docSnapshot;
  bool isLoading = true;
  late Map<String, dynamic> firestoreData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot doc = await document.get();
      Map<String, dynamic> firestoreData = doc.data() as Map<String, dynamic>;

      setState(() {
        torch1 = firestoreData['torch'];
        capture_img = firestoreData['click_image'];
        imageUrls = List<String>.from(firestoreData[
            'view_images']); // Assuming view_images is a List<String>
        temperature = firestoreData['temp'];
        isLoading = false;
      });
    } catch (e) {
      log("Error getting document: $e");
    }
  }

  Future<void> _setData({bool? click_image, bool? torch}) async {
    firestoreData['torch'] = torch ?? torch1;
    firestoreData['click_image'] = click_image ?? capture_img;
    document.set(firestoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _fetchData();
          });
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: const Color(0xff51C3C9),
                padding: const EdgeInsets.all(16.0),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TemperaturePage(
                                    valueToShow: docSnapshot.get('temp'))));
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.opacity_rounded,
                      'Humidity',
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HumidityPage(
                                    valueToShow: docSnapshot.get('hum'))));
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.warning_rounded,
                      'Check Gas Leakage',
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeakagePage(
                                    valueToShow: docSnapshot.get('leakage'))));
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.camera_alt_rounded,
                      'Capture Image',
                      onPressed: () {
                        setState(() {
                          capture_img = !capture_img;
                          _setData(click_image: capture_img);
                        }); // Handle image capture button press
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.image_rounded,
                      'View Image',
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImagePage(
                                    valueToShow:
                                        docSnapshot.get('view_images'))));
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.lightbulb_rounded,
                      'Switch On Torch',
                      onPressed: () {
                        setState(() {
                          torch1 = !torch1;
                          _setData(torch: torch1);
                        }); // Handle torch button press
                      },
                    ),
                    _buildButton(
                      context,
                      Icons.location_on_rounded,
                      'Check Location',
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPage(
                              latValue: docSnapshot.get('lat'),
                              lngValue: docSnapshot.get('lng'),
                            ),
                          ),
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
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                    ),
                  ],
                ),
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
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0),
          const SizedBox(height: 10.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
