import 'package:flutter/material.dart';

class CalculatorNumbersButtons extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String buttonText;
  final VoidCallback? buttomTopped;

  
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
            // ← 加 FittedBox:掣因為矮機 / 系統字體放大變細嗰陣,28 號字會自動縮到擺得落,
            // 掣夠大嗰陣(縮放 = 1)同原本一樣
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
      ),
    );
  }
}

