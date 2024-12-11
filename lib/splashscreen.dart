import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

//IM-2021-084 Nadun Sooriyaarachchi
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CalculatorScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon in the center
                Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'CalcMate',
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                Text(
                  'Designed & Developed by',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nadun Sooriyaarachchi',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Creattion',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
