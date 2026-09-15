import 'package:flutter/material.dart';

class DrawerButtons extends StatelessWidget {

   final String buttonText;
   final onTap;

  const DrawerButtons({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: AspectRatio(
          aspectRatio: 4/1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadiusGeometry.circular(30),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 20,
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
