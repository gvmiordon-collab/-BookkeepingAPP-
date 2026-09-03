import 'package:flutter/material.dart';

class CalculatorNumbersButtons extends StatelessWidget {
  
  final color;
  final textColor;
  final String buttonText;
  final buttomTopped;

  
  const CalculatorNumbersButtons({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText,
    this.buttomTopped,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttomTopped,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

