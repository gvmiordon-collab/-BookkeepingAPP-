import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator_numbers_buttons.dart';
import 'package:bookkeeping/date_button.dart';

class PageA extends StatefulWidget {
  const PageA({super.key});

  @override
  State<PageA> createState() => _PageAState();
}

class _PageAState extends State<PageA> {

  final List<String> button =[
    '7', '8', '9', '÷', 'AC',
    '4', '5', '6', '×', '<-',
    '1', '2', '3', '+', 'OK',
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
            flex: 3,
            child: Container(
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.greenAccent[100],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                const DateButton(), // 修正：加上括號來實例化元件
                Expanded( // 建議：用 Expanded 包住 GridView 以防溢出
                  child: GridView.builder(
                      itemCount: button.length, // 修正：設定 item 總數
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                      itemBuilder: (BuildContext context, int index) {
                        return CalculatorNumbersButtons(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          buttonText: button[index],
                        );
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
}
