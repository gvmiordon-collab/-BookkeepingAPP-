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

  final List<Map<String, dynamic>> categoryItems = [
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.add, 'label': 'Add'},
    // 之後想加多幾個分類，喺呢度加落去就得
  ];

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
        title: const ExpenseIncomeButton(),  // 呢個BUTTON 只會令到Flex:6 個Part 的Categories 出現改變
        // 3. 強制不論 Android 或 iOS 都居中對齊
        centerTitle: true,
        // ======== 在這裡加上右邊的三點按鈕 ========
        actions: [
          Theme(
            // 拎走 Flutter 預設嘅 popup 外層 8px padding + M3 陰影/變色
            data: Theme.of(context).copyWith(
              popupMenuTheme: const PopupMenuThemeData(
                menuPadding: EdgeInsets.zero, // Flutter 3.19+ 先有；舊版可刪呢行
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              color: Colors.white,
              elevation: 2,
              surfaceTintColor: Colors.transparent, // 防止 Material3 自動加色
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              itemBuilder: (context) =>  [
                PopupMenuItem<String>(
                 // value: 'edit_categories',
                  padding: EdgeInsets.zero,
                  child: _MenuRow(text: 'Cash', showDivider: true),
                ),
                PopupMenuItem<String>(
                  //value: 'tutorial',
                  padding: EdgeInsets.zero,
                  child: _MenuRow(text: 'Bank', showDivider: false),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit_categories':
                  // Navigator.push(...)
                    break;
                  case 'tutorial':
                  // Navigator.push(...)
                    break;
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: categoryItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (BuildContext context, int index) {
                final item = categoryItems[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey[300],
                      child: Icon(item['icon'] as IconData),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
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


class _MenuRow extends StatelessWidget {
  final String text;
  final bool showDivider;
  const _MenuRow({required this.text, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, // 按你圖入面嘅闊度自己調
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: showDivider
          ? const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      )
          : null,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}