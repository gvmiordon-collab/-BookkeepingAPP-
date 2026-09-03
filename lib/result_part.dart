import 'package:flutter/material.dart';

class ResultPart extends StatefulWidget {
  final String userQuestions;
  const ResultPart({
    super.key,
    required this.userQuestions,
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
              Container(
                child: Text(
                   '\$ ${widget.userQuestions}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                    reminder,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          Text(
              'Add later',
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
