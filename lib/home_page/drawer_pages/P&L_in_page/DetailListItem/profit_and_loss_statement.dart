import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← 加
import 'package:bookkeeping/providers/transaction_provider.dart'; // ← 加
import 'package:bookkeeping/providers/category_provider.dart'; // ← 加
import 'pnl_colors.dart';
import 'pnl_logic.dart'; // ← 加
import 'pnl_shared_widgets.dart';
import 'expense_pie_screen.dart';
import 'expense_bar_screen.dart';
import 'income_pie_screen.dart';
import 'balance_line_screen.dart';
import 'balance_line_year_screen.dart';

class ProfitAndLossStatement extends StatefulWidget {
  const ProfitAndLossStatement({super.key});

  @override
  State<ProfitAndLossStatement> createState() => _ProfitAndLossStatementState();
}

class _ProfitAndLossStatementState extends State<ProfitAndLossStatement> {
  int _currentTab = 0;
  int _expeSubIndex = 0;
  int _balaSubIndex = 0;
  int _timeFilterIndex = 2; // 0 MTH, 1 Last 6, 2 Year, 3 Custom(預設 = Year)
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  // ← 改:刪走原本嘅 _monthShort,月份名同範圍計算全部搬咗去 pnl_logic.dart
  PnlRangeMode get _mode => PnlLogic.modeFromIndex(_timeFilterIndex);

  String get _dateLabel => PnlLogic.labelFor(_mode, _selectedMonth); // ← 改:原本固定 'Sep 2026' 嗰種格式

  // ← 改:◀ ▶ 跟時間篩選跳(Year 跳一年,其他跳一個月)
  void _shift(int delta) => setState(() {
    _selectedMonth = PnlLogic.shiftAnchor(_mode, _selectedMonth, delta);
  });

  void _goToPreviousMonth() => _shift(-1);

  void _goToNextMonth() => _shift(1);

  Widget _getCurrentScreen(PnlReport report) { // ← 改:收 report
    switch (_currentTab) {
      case 0:
        return _expeSubIndex == 0
            ? ExpensePieScreen(
          onToggle: () => setState(() => _expeSubIndex = 1),
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        )
            : ExpenseBarScreen(
          onToggle: () => setState(() => _expeSubIndex = 0),
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
      case 1:
        return IncomePieScreen(
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
      case 2:
        return _balaSubIndex == 0
            ? BalanceLineScreen(
          onToggle: () => setState(() => _balaSubIndex = 1),
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        )
            : BalanceLineYearScreen(
          onToggle: () => setState(() => _balaSubIndex = 0),
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
      default:
        return ExpensePieScreen(
          onToggle: null,
          report: report, // ← 加
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
    }
  }

  Color _getTabColor() {
    switch (_currentTab) {
      case 0: return kYellow;
      case 1: return kBlue;
      case 2: return kPink;
      default: return kYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ← 加:由 provider 攞交易 + 分類,轉做 pnl_logic 嘅輸入,一次過計好 report 派俾各個 screen
    final txs = context.watch<TransactionProvider>().transactions;
    final cats = context.watch<CategoryProvider>().categories; // 包括封存咗嗰啲(舊交易要用)
    final report = PnlLogic.buildReport(
      mode: _mode,
      anchor: _selectedMonth,
      transactions: [
        for (final t in txs)
          PnlTx(
            date: t.date,
            amount: t.amount,
            isExpense: t.isExpense,
            categoryId: t.categoryId,
          ),
      ],
      categories: [
        for (final c in cats)
          PnlCategory(
            id: c.id,
            label: c.label,
            iconKey: c.iconKey,
            groupKey: c.groupKey,
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          width: 260,
          child: TopTabs(
            selectedIndex: _currentTab,
            selectedColor: _getTabColor(),
            onTabSelected: (index) {
              setState(() {
                _currentTab = index;
              });
            },
          ),
        ),
      ),
      body: _getCurrentScreen(report), // ← 改
    );
  }
}