
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookkeeping/calculator/footnote_model.dart';

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


  final List<String> footnote =[
    'FOOD',
    'McDonald',
    'one',
    'two',

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                      hintText: 'footnote',
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // 💡 總數加 1，用來放置最後那個特別的 footnote
              itemCount: footnote.length + 1,
              itemBuilder: (BuildContext context, int index) {
                // 💡 如果 index 等於原本列表的長度，代表到了最後一個位置
                if (index == footnote.length) {
                  // 這裡回傳你「特地設計」的 Widget
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        // 這裡可以寫點擊這個特別按鈕後的動作（例如：新增標籤）
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                            return Container(
                              
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: ListView.builder(
                                itemCount: footnote.length,
                                  itemBuilder: (BuildContext context, int index){
                                return Padding(
                                  padding:  EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'footnote',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        height: 1, // 控制分界線佔用的空間高度
                                      ),
                                    ],
                                  ),

                                );
                              },
                              ),
                            );
                            }
                            );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // 換個特別的顏色
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 16,), // 加個 + 號圖標

                            Text(
                              '新增',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                // 💡 其他一般情況，依然回傳原本的 FootnoteModel
                return FootnoteModel(footnote: footnote[index]);
              },
            ),
          ),


        ],
      ),
    );
  }
}
