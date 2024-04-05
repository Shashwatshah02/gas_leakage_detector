import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_detector/Control.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Control.dart';

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
  // final Up = FirebaseDatabase.instance.reference();
  // final Down = FirebaseDatabase.instance.reference();
  // final Left = FirebaseDatabase.instance.reference();
  // final Right = FirebaseDatabase.instance.reference();
  final wheel = FirebaseFirestore.instance.collection('wheels');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 300.0,
                padding: EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                color: Color(0xff51C3C9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/Robot.jpeg'),
                      radius: 60.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Welcome, Rachel Green',
                      style: GoogleFonts.arvo(
                        textStyle:
                            TextStyle(fontSize: 25.0, color: Colors.white),
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
                        MaterialPageRoute(builder: (context) => ControlPage()),
                      );
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
                      // Get the current document snapshot
                      DocumentSnapshot docSnapshot =
                          await wheel.doc('controller').get();

                      // Extract the current values from the snapshot
                      bool forward = docSnapshot.get('forward');
                      bool behind = docSnapshot.get('behind');
                      bool left = docSnapshot.get('left');
                      bool right = docSnapshot.get('right');

                      // Toggle the values
                      forward = !forward;
                      behind =
                          false; // Assuming you want only one direction to be true at a time
                      left = false;
                      right = false;

                      // Update the Firestore document with the new values
                      wheel.doc('controller').set({
                        'forward': forward,
                        'behind': behind,
                        'left': left,
                        'right': right,
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
                      // Get the current document snapshot
                      DocumentSnapshot docSnapshot =
                          await wheel.doc('controller').get();

                      // Extract the current values from the snapshot
                      bool forward = docSnapshot.get('forward');
                      bool behind = docSnapshot.get('behind');
                      bool left = docSnapshot.get('left');
                      bool right = docSnapshot.get('right');

                      // Toggle the values
                      forward = false;
                      behind =
                          !behind; // Assuming you want only one direction to be true at a time
                      left = false;
                      right = false;

                      // Update the Firestore document with the new values
                      wheel.doc('controller').set({
                        'forward': forward,
                        'behind': behind,
                        'left': left,
                        'right': right,
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
                      // Get the current document snapshot
                      DocumentSnapshot docSnapshot =
                          await wheel.doc('controller').get();

                      // Extract the current values from the snapshot
                      bool forward = docSnapshot.get('forward');
                      bool behind = docSnapshot.get('behind');
                      bool left = docSnapshot.get('left');
                      bool right = docSnapshot.get('right');

                      // Toggle the values
                      forward = false;
                      behind =
                          false; // Assuming you want only one direction to be true at a time
                      left = !left;
                      right = false;

                      // Update the Firestore document with the new values
                      wheel.doc('controller').set({
                        'forward': forward,
                        'behind': behind,
                        'left': left,
                        'right': right,
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
                      // Get the current document snapshot
                      DocumentSnapshot docSnapshot =
                          await wheel.doc('controller').get();

                      // Extract the current values from the snapshot
                      bool forward = docSnapshot.get('forward');
                      bool behind = docSnapshot.get('behind');
                      bool left = docSnapshot.get('left');
                      bool right = docSnapshot.get('right');

                      // Toggle the values
                      forward = false;
                      behind =
                          false; // Assuming you want only one direction to be true at a time
                      left = false;
                      right = !right;

                      // Update the Firestore document with the new values
                      wheel.doc('controller').set({
                        'forward': forward,
                        'behind': behind,
                        'left': left,
                        'right': right,
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
