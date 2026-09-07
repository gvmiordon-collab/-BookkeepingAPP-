import 'package:bookkeeping/calculator/result_part.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator/date_button.dart';
import 'package:bookkeeping/calculator/calculator_number_buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

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
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 1. 自動生成的返回鍵圖標如果是預設的，也可以自訂成你的黑箭頭：
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        // 2. 將按鈕放入 title
        title: const ExpenseIncomeButton(),
        // 3. 強制不論 Android 或 iOS 都居中對齊
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

