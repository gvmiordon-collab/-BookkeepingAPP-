import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

  final TextEditingController _reminderController = TextEditingController();

  var reminder = 'reminder' ;

  @override
  void dispose() {
    _reminderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4, // 金額呢邊佔多啲空間
                child: AutoSizeText(
                  '\$ ${widget.userQuestions}',
                  style: const TextStyle(
                    fontSize: 25,        // 未縮之前嘅「原本」大小
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 14,       // ← 呢個就係「最細」嘅下限，自己試到岩為止
                  overflow: TextOverflow.ellipsis, // 就算到咗下限都仲塞唔落,咁就用...代替
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _reminderController,
                  decoration: const InputDecoration(
                    hintText: 'reminder',
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const Text(
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
