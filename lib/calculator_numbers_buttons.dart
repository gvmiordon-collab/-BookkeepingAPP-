import 'package:flutter/material.dart';

class CalculatorNumbersButtons extends StatelessWidget {
  
  final color;
  final textColor;
  final String buttonText;

  
  const CalculatorNumbersButtons({
    super.key,
    required this.color,
    required this.textColor,
    required this.buttonText,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

