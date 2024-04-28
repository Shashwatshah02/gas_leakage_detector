import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_leakage_detector/Intro.dart';
import 'package:gas_leakage_detector/Login.dart';
import 'package:gas_leakage_detector/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const IPD());
}

class IPD extends StatelessWidget {
  const IPD({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionPage(),
      ),
    );
  }
}
