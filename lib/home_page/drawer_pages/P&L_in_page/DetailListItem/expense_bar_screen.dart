import 'package:flutter/material.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';
import 'pnl_widgets.dart';

class ExpenseBarScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final PnlReport report; // ← 加:數據
  final int timeFilterIndex;
  final ValueChanged<int> onTimeFilterChanged;
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ExpenseBarScreen({
    super.key,
    this.onToggle,
    required this.report, // ← 加
    required this.timeFilterIndex,
    required this.onTimeFilterChanged,
    required this.dateText,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(
          selectedIndex: timeFilterIndex,
          onTabSelected: onTimeFilterChanged,
          selectedColor: kYellow,
        ),
        DateCurrencySelector(
          dateText: dateText,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 10),
            child: onToggle != null
                ? IconButton(
              icon: const Icon(Icons.pie_chart_outline),
              onPressed: onToggle,
            )
                : const Icon(Icons.pie_chart_outline),
          ),
        ),
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PnlBarView(groups: report.expenseGroups), // ← 改:原本成個 BarChart 寫死
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PnlDetailsBox( // ← 改:原本寫死三行 Column;scrollable 因為行數而家唔固定
            title: 'Details',
            scrollable: true,
            rows: pnlCategoryRows(report.expenseCategories),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}