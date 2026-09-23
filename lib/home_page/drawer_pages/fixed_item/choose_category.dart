import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart'; // ← 加,撈返現有嘅掣,唔自己整新樣

/// 揀分類頁:撳一個分類格 → Navigator.pop 帶住 (id, isExpense) 返去上一頁。
class ChooseCategory extends StatefulWidget {
  final bool initialIsExpense; // ← 加

  const ChooseCategory({super.key, this.initialIsExpense = true}); // ← 改

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  late bool _isExpense = widget.initialIsExpense; // ← 改

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final items = _isExpense
        ? provider.activeExpenseCategories
        : provider.activeIncomeCategories;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose category'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ← 改:原本呢度係兩個 duplicate 又冇 onTap 嘅 Expense/Income Column,換成揀掣 + 單一 grid
            ExpenseIncomeButton(
              initialIsExpense: _isExpense,
              onChanged: (v) => setState(() => _isExpense = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return GestureDetector( // ← 加:原本冇 onTap,撳咩都冇反應
                    onTap: () => Navigator.pop(
                      context,
                      (id: item.id, isExpense: _isExpense),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Icon(categoryIconData(item.iconKey)),
                            const SizedBox(height: 5),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              softWrap: false,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}