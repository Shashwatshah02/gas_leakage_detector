import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_detector/Control.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool upOn = false;
  bool downOn = false;
  bool leftOn = false;
  bool rightOn = false;

  final document = FirebaseFirestore.instance.collection('users').doc('pi');

  late DocumentSnapshot docSnapshot;

  late Map<String, dynamic> firestoreData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    super.initState();
  }

  // Fetch data from Firestore
  Future<void> _fetchData() async {
    document.get().then(
      (DocumentSnapshot doc) {
        firestoreData = doc.data() as Map<String, dynamic>;
        upOn = firestoreData['forward'];
        downOn = firestoreData['backward'];
        leftOn = firestoreData['left'];
        rightOn = firestoreData['right'];
      },
      onError: (e) => log("Error getting document: $e"),
    );
  }

  // Set data to Firestore
  Future<void> _setData(
      {bool? forward, bool? backward, bool? left, bool? right}) async {
    firestoreData['forward'] = forward ?? upOn;
    firestoreData['backward'] = backward ?? downOn;
    firestoreData['left'] = left ?? leftOn;
    firestoreData['right'] = right ?? rightOn;
    document.set(firestoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 300.0,
                padding: const EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                color: const Color(0xff51C3C9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('images/Robot.jpeg'),
                      radius: 60.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Welcome, Rachel Green',
                      style: GoogleFonts.arvo(
                        textStyle: const TextStyle(
                            fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 260),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ControlPage()));
                    },
                    child: const Text(
                      'Control Center',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 350.0),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        upOn = !upOn;
                        _setData(forward: upOn);
                      });
                    },
                    child: const Icon(Icons.arrow_upward_sharp),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 550.0),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        downOn = !downOn;
                        _setData(backward: downOn);
                      });
                    },
                    child: const Icon(Icons.arrow_downward_sharp),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 450.0, right: 250.0),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        leftOn = !leftOn;
                        _setData(left: leftOn);
                      });
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 450.0, left: 250.0),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        rightOn = !rightOn;
                        _setData(right: rightOn);
                      });
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('images/shape.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
