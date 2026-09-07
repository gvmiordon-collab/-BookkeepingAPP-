import 'package:flutter/material.dart';

class ExpenseIncomeButton extends StatefulWidget {
  const ExpenseIncomeButton({super.key});

  @override
  State<ExpenseIncomeButton> createState() => _ExpenseIncomeButtonState();
}

class _ExpenseIncomeButtonState extends State<ExpenseIncomeButton> {
  bool isExpenseSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 整體的外框與圓角
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 確保寬度只佔用按鈕大小，才能在 AppBar 中置中
        children: [
          // Expense 按鈕
          GestureDetector(
            onTap: () => setState(() => isExpenseSelected = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isExpenseSelected ? const Color(0xFFFBC02D) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: const Text('Expense', style: TextStyle(color: Colors.black)),
            ),
          ),
          // Income 按鈕 (補全你的程式碼)
          GestureDetector(
            onTap: () => setState(() => isExpenseSelected = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: !isExpenseSelected ? const Color(0xFFFBC02D) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const Text('Income', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
