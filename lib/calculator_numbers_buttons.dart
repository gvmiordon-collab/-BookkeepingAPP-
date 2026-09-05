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
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(30),
          ),

          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

