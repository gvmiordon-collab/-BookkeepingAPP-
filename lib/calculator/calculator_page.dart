import 'package:bookkeeping/calculator/result_part.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator/date_button.dart';
import 'package:bookkeeping/calculator/calculator_number_buttons.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart';
import 'package:bookkeeping/widgets/selectable_category_icon.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/home_page/drawer_pages/categories_model_in_page/add_a_new_category.dart';
import 'package:bookkeeping/utils/formatters.dart';
import 'package:bookkeeping/database/app_database.dart' show TransactionEntry;
import 'package:bookkeeping/providers/asset_provider.dart';
import 'package:bookkeeping/calculator/calculator_logic.dart';   // ← 加
import 'package:bookkeeping/providers/footnote_provider.dart';   // ← 加

class CalculatorPage extends StatefulWidget {
  final TransactionEntry? editing; // null = 新增;有值 = 編輯嗰筆
  const CalculatorPage({super.key, this.editing});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  int? _selectedCategoryId; // 用 DB 嘅 id,唔用 index(list 會隨 Expense/Income、新增分類而變)
  bool isExpenseSelected = true;
  int? _selectedAssetId; // null = 未手動揀 → 用 AssetProvider.defaultAssetId(第一個帳戶)
  bool _saving = false;  // 防雙擊重複儲存
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _footnoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      isExpenseSelected = e.isExpense;
      _selectedCategoryId = e.categoryId;
      _selectedAssetId = e.assetId;
      _selectedDate = e.date;
      userQuestions = fmtAmount(e.amount);
      finalQuestions = userQuestions;
      _footnoteController.text = e.footnote ?? '';
    }
  }

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
    final assetProvider = context.watch<AssetProvider>();
    final assets = assetProvider.activeAssets;
    // 冇手動揀 → 第一個帳戶;所以就算用家冇 Cash 都唔會出錯
    final effectiveAssetId = _selectedAssetId ?? assetProvider.defaultAssetId;
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
          initialIsExpense: isExpenseSelected,
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
            child: PopupMenuButton<int>(
              enabled: assets.isNotEmpty, // ⚠️ 空 list 開 menu 會 assert 失敗
              icon: const Icon(Icons.more_vert, color: Colors.black),
              color: Colors.white,
              elevation: 2,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              itemBuilder: (context) => [
                for (var i = 0; i < assets.length; i++)
                  PopupMenuItem<int>(
                    value: assets[i].id, // 一定要有 value,否則會被當成 cancel
                    padding: EdgeInsets.zero,
                    child: _MenuRow(
                      text: assets[i].name,
                      showDivider: i < assets.length - 1,
                      selected: assets[i].id == effectiveAssetId,
                    ),
                  ),
              ],
              onSelected: (id) => setState(() => _selectedAssetId = id),
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
                cat == null ? Icons.add : categoryIconData(cat.iconKey);
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


  void equalPressed() {
    final value = CalculatorLogic.evaluate(userQuestions);   // ← 原本 _evaluate(...)
    if (value == null) return;
    setState(() {
      finalQuestions = fmtAmount(value);
      userQuestions = finalQuestions;
    });
  }

  Future<void> _savePressed() async {
    if (_saving) return;

    final categoryProvider = context.read<CategoryProvider>();
    final categories = isExpenseSelected
        ? categoryProvider.activeExpenseCategories
        : categoryProvider.activeIncomeCategories;

    final draft = CalculatorLogic.buildDraft(
      expression: userQuestions,
      date: _selectedDate,
      isExpense: isExpenseSelected,
      selectedCategoryId: _selectedCategoryId,
      availableCategoryIds: [for (final c in categories) c.id],
      selectedAssetId: _selectedAssetId,
      defaultAssetId: context.read<AssetProvider>().defaultAssetId,
      footnoteText: _footnoteController.text,
    );
    // ⚠️ null = 算式打錯 / 負數 / 當前類別冇任何分類 → 靜雞雞唔儲
    if (draft == null) return;

    final provider = context.read<TransactionProvider>();
    final editing = widget.editing;

    _saving = true;
    try {
      if (editing == null) {
        await provider.addTransaction(
          date: draft.date,
          amount: draft.amount,
          isExpense: draft.isExpense,
          categoryId: draft.categoryId,
          assetId: draft.assetId,
          footnote: draft.footnote,
        );
      } else {
        await provider.editTransaction(
          id: editing.id,
          date: draft.date,
          amount: draft.amount,
          isExpense: draft.isExpense,
          categoryId: draft.categoryId,
          assetId: draft.assetId,
          footnote: draft.footnote,
        );
      }
      if (draft.footnote != null) {                                          // ← 加
        await context.read<FootnoteProvider>().recordUsage(draft.footnote!);  // ← 加
      }                                                                       // ← 加
    } finally {
      _saving = false;
    }
    if (!mounted) return;
    Navigator.pop(context);
  }
}


class _MenuRow extends StatelessWidget {
  final String text;
  final bool showDivider;
  final bool selected;
  const _MenuRow({
    required this.text,
    required this.showDivider,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: showDivider
          ? const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      )
          : null,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            if (selected)
              const Positioned(
                right: 16,
                child: Icon(Icons.check, size: 20, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}