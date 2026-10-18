import 'package:flutter/material.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';
import 'pnl_widgets.dart';

/// 逐日版:範圍(MTH / Last 6 / Year)入面每日一個點
class BalanceLineScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final PnlReport report; // ← 加:數據
  final int timeFilterIndex;
  final ValueChanged<int> onTimeFilterChanged;
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const BalanceLineScreen({
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
          selectedColor: kPink,
        ),
        DateCurrencySelector(
          dateText: dateText,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
        PnlBalanceSummary( // ← 改:原本寫死 -210.4 / 900 / 689.6
          report: report,
          onToggle: onToggle,
          toggleIcon: Icons.auto_graph,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PnlLineView(series: report.daily, leftReservedSize: 40), // ← 改:原本寫死 spots
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PnlDetailsBox( // ← 改:原本寫死四行 Column;scrollable 因為行數而家唔固定
            title: 'Date',
            scrollable: true,
            rows: pnlDateRows(report.daily),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}