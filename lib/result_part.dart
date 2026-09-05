import 'package:flutter/material.dart';

class ResultPart extends StatefulWidget {
  final String userQuestions;
  final String finalQuestions;
  const ResultPart({
    super.key,
    required this.userQuestions,
    required this.finalQuestions,
  });

  @override
  State<ResultPart> createState() => _ResultPartState();
}

class _ResultPartState extends State<ResultPart> {


  var reminder = 'reminder' ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                 '\$ ${widget.userQuestions}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

             /* VerticalDivider(      距離問題 遟啲搞
                color: Colors.red,    **記得加IntrinsicHeight 係ROW 之前**
                thickness: 1,
                width: 20,
                indent: 10,
                endIndent: 10,
              ),  */


              Text(
                  reminder, // DO it later
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Text(
             'add later',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
