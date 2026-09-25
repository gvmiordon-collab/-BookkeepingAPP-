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

  Widget _getCurrentScreen() {
    switch (_currentTab) {
      case 0:
        return _expeSubIndex == 0
            ? ExpensePieScreen(
          onToggle: () => setState(() => _expeSubIndex = 1),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
        )
            : ExpenseBarScreen(
          onToggle: () => setState(() => _expeSubIndex = 0),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
        );
      case 1:
        return IncomePieScreen(
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
        );
      case 2:
        return _balaSubIndex == 0
            ? BalanceLineScreen(
          onToggle: () => setState(() => _balaSubIndex = 1),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
        )
            : BalanceLineYearScreen(
          onToggle: () => setState(() => _balaSubIndex = 0),
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
        );
      default:
        return ExpensePieScreen(
          onToggle: null,
          timeFilterIndex: _timeFilterIndex,
          onTimeFilterChanged: (i) => setState(() => _timeFilterIndex = i),
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