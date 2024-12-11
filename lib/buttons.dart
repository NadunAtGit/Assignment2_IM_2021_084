import 'package:flutter/material.dart';

//IM-2021-084 Nadun Sooriyaarachchi
class Button1 extends StatelessWidget {
  final Color bgcolor;
  final Color fgcolor;
  final String buttontxt;
  final Widget? child;
  final VoidCallback onPressed;

  const Button1({
    required this.bgcolor,
    required this.fgcolor,
    required this.buttontxt,
    this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgcolor,
        foregroundColor: fgcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            buttontxt,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
    );
  }
}
