import 'package:flutter/material.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';
import 'pnl_widgets.dart';

class ExpensePieScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final PnlReport report; // ← 加:數據
  final int timeFilterIndex;
  final ValueChanged<int> onTimeFilterChanged;
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ExpensePieScreen({
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    PnlPieView( // ← 改:原本寫死 80.3 / 19.7 同 '$9,540.8'
                      groups: report.expenseGroups,
                      centerLabel: 'Total expense',
                      total: report.totalExpense,
                    ),
                    if (onToggle != null)
                      IconButton(
                        icon: const Icon(Icons.bar_chart),
                        onPressed: onToggle,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                PnlLegendBox(groups: report.expenseGroups), // ← 改:原本寫死 膳食 / Trasp... / Snacks
                const SizedBox(height: 16),
                PnlDetailsBox( // ← 改:原本寫死三行
                  title: 'Details',
                  rows: pnlCategoryRows(report.expenseCategories),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}