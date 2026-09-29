import 'package:flutter/material.dart';
import 'pnl_colors.dart';
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
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month); // ← 加

  static const _monthShort = [ // ← 加
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _dateLabel => // ← 加
  '${_monthShort[_selectedMonth.month - 1]} ${_selectedMonth.year}';

  void _goToPreviousMonth() => setState(() { // ← 加
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
  });

  void _goToNextMonth() => setState(() { // ← 加
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
  });

  Widget _getCurrentScreen() {
    switch (_currentTab) {
      case 0:
        return _expeSubIndex == 0
            ? ExpensePieScreen(
          onToggle: () => setState(() => _expeSubIndex = 1),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel, // ← 加
          onPrevious: _goToPreviousMonth, // ← 加
          onNext: _goToNextMonth, // ← 加
        )
            : ExpenseBarScreen(
          onToggle: () => setState(() => _expeSubIndex = 0),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
      case 1:
        return IncomePieScreen(
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
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        )
            : BalanceLineYearScreen(
          onToggle: () => setState(() => _balaSubIndex = 0),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
      default:
        return ExpensePieScreen(
          onToggle: null,
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
          dateText: _dateLabel,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        );
    }
  }
  // _getTabColor() / build() 唔使郁

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
      body: _getCurrentScreen(),
    );
  }
}