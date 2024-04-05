import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('images/shape.png'),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 125.0),
                      child: Image.asset('images/Robot.jpeg',
                          height: 300.0, width: 300.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'GAS LEAKAGE DETECTOR',
                      style: GoogleFonts.arvo(
                        textStyle: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Interdum dictum tempus, interdum at dignissim metus. Ultricies sed nunc.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: Text('Get Started'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.cyan),
                          minimumSize: MaterialStatePropertyAll<Size>(
                              Size(293.0, 50.0))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
