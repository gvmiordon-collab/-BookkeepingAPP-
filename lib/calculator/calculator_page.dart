import 'package:bookkeeping/calculator/result_part.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator/date_button.dart';
import 'package:bookkeeping/calculator/calculator_number_buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart';
import 'package:bookkeeping/widgets/selectable_category_icon.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/home_page/drawer_pages/categories_model_in_page/add_a_new_category.dart';
import 'package:bookkeeping/utils/formatters.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  int? _selectedCategoryId; // 用 DB 嘅 id,唔用 index(list 會隨 Expense/Income、新增分類而變)
  bool isExpenseSelected = true;
  DateTime _selectedDate = DateTime.now(); // ⚠️ DateButton 未駁,暫時用今日

  final TextEditingController _footnoteController = TextEditingController();

  @override
  void dispose() {
    _footnoteController.dispose();
    super.dispose();
  }

  bool isCategoriesSelected = true;

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
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = isExpenseSelected
        ? categoryProvider.activeExpenseCategories
        : categoryProvider.activeIncomeCategories;
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
        title: ExpenseIncomeButton(
          onChanged: (v) => setState(() {
            isExpenseSelected = v;
            _selectedCategoryId = null; // 切換後 list 唔同咗,清走已揀分類
          }),
        ),  // 呢個ExpenseIncomeBUTTON 只會令到Flex:6 個Part 的Categories同埋result_part 的footnote出現改變
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length + 1, // +1 = 常駐嘅 Add
              itemBuilder: (BuildContext context, int index) {
                final cat = index == 0 ? null : categories[index - 1]; // null = Add 掣
                final IconData icon =
                cat == null ? Icons.add : categoryIconData(cat.iconCodePoint);
                final String label = cat == null ? 'Add' : cat.label;
                return GestureDetector(
                  onTap: () {
                    if (cat == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomCategories(isExpense: isExpenseSelected),
                        ),
                      );
                    } else {
                      setState(() => _selectedCategoryId = cat.id);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: SelectableCategoryIcon(
                          icon: icon,
                          size: 30,
                          selected: cat != null && cat.id == _selectedCategoryId,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
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
                userQuestions: userQuestions,
                footnoteController: _footnoteController,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Column(
              children: [
                DateButton(
                  date: _selectedDate,
                  onChanged: (d) => setState(() => _selectedDate = d),
                ),
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
                        } else if (index == 19) { // OK button
                          return CalculatorNumbersButtons(
                          buttomTopped: _savePressed,
                          color: Colors.white,   // 樣式冇郁,同原本一樣
                          textColor: Colors.black,
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

  /// 計算式 → 數字。語法錯 / 唔完整(例如 "5+")/ 除以 0 → 返回 null
  double? _evaluate(String expr) {
    if (expr.isEmpty) return null;
    try {
      final text = expr.replaceAll('×', '*').replaceAll('÷', '/');
      final Expression exp = GrammarParser().parse(text);
      final num result = RealEvaluator(ContextModel()).evaluate(exp);
      final value = result.toDouble();
      if (!value.isFinite) return null;               // 1÷0 → Infinity / NaN
      return double.parse(value.toStringAsFixed(2));  // ⚠️ 四捨五入兩位小數
    } catch (_) {
      return null;
    }
  }

  /// 5.0 → "5",5.50 → "5.5"
  String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }

  void equalPressed() {
    final value = _evaluate(userQuestions);
    if (value == null) return; // ⚠️ 出錯就靜靜雞唔郁
    setState(() {
      finalQuestions = fmtAmount(value);
      userQuestions = finalQuestions;
    });
  }

  Future<void> _savePressed() async {
    final amount = _evaluate(userQuestions); // ⚠️ 未撳 = 直接撳 OK 都會自動計
    final categoryId = _selectedCategoryId;
    if (amount == null || amount <= 0 || categoryId == null) return; // ⚠️

    final footnote = _footnoteController.text.trim();
    await context.read<TransactionProvider>().addTransaction(
      date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      amount: amount,
      isExpense: isExpenseSelected,
      categoryId: categoryId,
      footnote: footnote.isEmpty ? null : footnote,
    );
    if (!mounted) return;
    Navigator.pop(context); // ⚠️ 儲存完返 Home
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