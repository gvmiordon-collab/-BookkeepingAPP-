import 'package:flutter/material.dart';

class ExpenseIncomeButton extends StatefulWidget {
  final bool initialIsExpense;
  final ValueChanged<bool>? onChanged;

  const ExpenseIncomeButton({
    super.key,
    this.initialIsExpense = true,
    this.onChanged,
  });

  @override
  State<ExpenseIncomeButton> createState() => _ExpenseIncomeButtonState();
}

class _ExpenseIncomeButtonState extends State<ExpenseIncomeButton> {
  late bool isExpenseSelected = widget.initialIsExpense;

  void _select(bool expense) {
    setState(() => isExpenseSelected = expense);
    widget.onChanged?.call(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _select(true),
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
          GestureDetector(
            onTap: () => _select(false),
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