import 'package:flutter/material.dart';

class DateButton extends StatefulWidget {
  const DateButton({super.key});

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          //color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      const Icon( // this is the button but we do it later
                        Icons.arrow_left,
                        fontWeight: FontWeight.bold,
                        size: 30,
                      ),
                      const Icon(
                          Icons.calendar_today,
                          fontWeight: FontWeight.bold,
                        size: 23,
                      ),
                      Text(
                          'Today Thu, Sep 03, 2026',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const Icon( // this is the button but we do it later
                        Icons.arrow_right,
                        fontWeight: FontWeight.bold,
                        size: 30,
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
