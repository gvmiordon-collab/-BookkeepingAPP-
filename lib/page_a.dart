import 'package:bookkeeping/result_part.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator_numbers_buttons.dart';
import 'package:bookkeeping/date_button.dart';
import 'package:math_expressions/math_expressions.dart';


class PageA extends StatefulWidget {
  const PageA({super.key});

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {

  String userQuestions = '';
  String finalQuestions = '';

  final List<String> button =[
    '7', '8', '9', '÷', 'AC',
    '4', '5', '6', '×', '<-',
    '1', '2', '3', '+', '=',
    '00', '0', '.', '-', 'OK',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: ResultPart(
                  finalQuestions: finalQuestions,
                  userQuestions: userQuestions
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Column(
              children: [
                const DateButton(), // 修正：加上括號來實例化元件
                Expanded( // 建議：用 Expanded 包住 GridView 以防溢出
                  child: GridView.builder(
                      itemCount: button.length, // 修正：設定 item 總數
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                      itemBuilder: (BuildContext context, int index) {

                        if(index ==4) { // Clean button (AC)
                          return CalculatorNumbersButtons(
                            buttomTopped: () {
                              setState(() {
                                userQuestions = '' ;
                                finalQuestions = '';
                              });
                            },
                            color: Colors.green,
                            textColor: Colors.white,
                            buttonText: button[index],
                          );

                        } else if(index == 9) { // Delete button (<-)
                          return CalculatorNumbersButtons(
                            buttomTopped: () {
                              setState(() {
                                if (userQuestions.isNotEmpty) {
                                  userQuestions = userQuestions.substring(0, userQuestions.length - 1);
                                }
                              });
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                            buttonText: button[index],
                          );

                        } else if(index == 14) { // Equal button (=)
                          return CalculatorNumbersButtons(
                            buttomTopped: () {
                              equalPressed();
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            buttonText: button[index],
                          );
                        }
                        else{
                          return CalculatorNumbersButtons(
                            buttomTopped: () {
                              setState(() {
                                userQuestions += button[index];
                              });
                            },
                            color: Colors.white,
                            textColor: Colors.black,
                            buttonText: button[index],
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ) ,
    );
  }

  void equalPressed() {
    if (userQuestions.isEmpty) return;
    setState(() {
      String expressionText = userQuestions
          .replaceAll('×', '*')
          .replaceAll('÷', '/');

      GrammarParser p = GrammarParser();
      Expression exp = p.parse(expressionText);

      ContextModel cm = ContextModel();
      RealEvaluator evaluator = RealEvaluator(cm);
      num eval = evaluator.evaluate(exp);

        finalQuestions = eval.toString();
        userQuestions = finalQuestions;
    });

  }
}

