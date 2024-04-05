import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Expanded(
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
                      const Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Let's help you detect Gas Leakage!",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Image(
                          image: AssetImage('images/robot.png'),
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Enter your full name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextField(
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Enter your phone number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Enter password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 325,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Confirm password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 293.0,
                          height: 50,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF50C2C9),
                            ),
                            child: const Text(
                              ''
                              'Register',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                    text: 'Sign In.',
                                    style: TextStyle(
                                      color: Color(0xFF50C2C9),
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
