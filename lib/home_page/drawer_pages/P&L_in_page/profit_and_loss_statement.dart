import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ================= 顏色定義 =================
const Color kYellow = Color(0xFFFFC107);
const Color kPink = Color(0xFFEE4976);
const Color kBlue = Color(0xFF29B6F6);
const Color kOrange = Color(0xFFFF9800);


// ================= 主畫面 (取代原本嘅 MainScreen) =================
class ProfitAndLossStatement extends StatefulWidget {
  const ProfitAndLossStatement({super.key});

  @override
  State<ProfitAndLossStatement> createState() => _ProfitAndLossStatementState();
}

class _ProfitAndLossStatementState extends State<ProfitAndLossStatement> {
  int _currentTab = 0; // 0: Expe(支出), 1: Inco(收入), 2: Bala(結餘)

  // 用於記錄同一個 Tab 下嘅子畫面切換
  int _expeSubIndex = 0; // 0: 圓餅圖, 1: 柱狀圖
  int _balaSubIndex = 0; // 0: 月度折線圖, 1: 年度折線圖

  // 根據當前 Tab 決定顯示邊個畫面
  Widget _getCurrentScreen() {
    switch (_currentTab) {
      case 0:
        return _expeSubIndex == 0
            ? ExpensePieScreen(onToggle: () => setState(() => _expeSubIndex = 1))
            : ExpenseBarScreen(onToggle: () => setState(() => _expeSubIndex = 0));
      case 1:
        return const IncomePieScreen();
      case 2:
        return _balaSubIndex == 0
            ? BalanceLineScreen(onToggle: () => setState(() => _balaSubIndex = 1))
            : BalanceLineYearScreen(onToggle: () => setState(() => _balaSubIndex = 0));
      default:
        return const ExpensePieScreen(onToggle: null);
    }
  }

  // 根據當前 Tab 決定頂部按鈕嘅顏色
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
      // 將 TopTabs 放入 AppBar 嘅中間
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          width: 260, // 限制闊度，令佢唔會撐爆個 Mon
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

// ================= 共用組件 (UI 殼) =================

// 頂部 Tab (Expe / Inco / Bala) - 已加入點擊功能
class TopTabs extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  final ValueChanged<int> onTabSelected; // 新增回調

  const TopTabs({
    super.key,
    required this.selectedIndex,
    required this.selectedColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTab('Expe...', 0),
          _buildTab('Inco...', 1),
          _buildTab('Bala...', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index), // 觸發切換
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(6) : Radius.zero,
              right: index == 2 ? const Radius.circular(6) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 時間 Filter Tab (MTH / Last 6 / Year / Custom)
class TimeFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  const TimeFilterTabs({super.key, required this.selectedIndex, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['MTH', 'Last 6 ...', 'Year', 'Custom'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            bool isSelected = selectedIndex == index;
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: isSelected ? selectedColor : Colors.transparent,
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// 日期/貨幣 Selector
class DateCurrencySelector extends StatelessWidget {
  final String dateText;
  const DateCurrencySelector({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_left, size: 24),
              Text(dateText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_right, size: 24),
            ],
          ),
          const Row(
            children: [
              Text('All (TWD)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ],
      ),
    );
  }
}

// 底部清單 Item
class DetailListItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String amount;
  const DetailListItem({super.key, required this.icon, required this.iconBgColor, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black54, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ================= 畫面 1: 支出 (年 - 圓餅圖) =================
class ExpensePieScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  const ExpensePieScreen({super.key, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(selectedIndex: 2, selectedColor: kYellow),
        const DateCurrencySelector(dateText: '2026'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(color: kPink, value: 80.3, showTitle: false, radius: 40,borderSide: const BorderSide(color: Colors.black, width: 2), ),
                                PieChartSectionData(color: kYellow, value: 19.7, showTitle: false, radius: 40,borderSide: const BorderSide(color: Colors.black, width: 2), ),
                              ],
                            ),
                          ),
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Total expense', style: TextStyle(fontSize: 14, color: Colors.black87)),
                                Text('\$9,540.8', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onToggle != null)
                      IconButton(
                        icon: const Icon(Icons.bar_chart),
                        onPressed: onToggle,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black54,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildLegend(kPink, '膳食  80.3%'),
                          const SizedBox(width: 20),
                          _buildLegend(kYellow, 'Trasp...  19.7%'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLegend(kOrange, 'Snacks  0%'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Icon(Icons.sort, size: 20),
                          ],
                        ),
                      ),
                      const DetailListItem(icon: Icons.restaurant, iconBgColor: kPink, title: '膳食', amount: '\$7,665.6'),
                      const DetailListItem(icon: Icons.directions_bus, iconBgColor: kYellow, title: 'Trasportations', amount: '\$1,875.2'),
                      const DetailListItem(icon: Icons.shopping_bag_outlined, iconBgColor: kOrange, title: 'Snacks', amount: '\$0'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ================= 畫面 2: 結餘 (月 - 折線圖) =================
class BalanceLineScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  const BalanceLineScreen({super.key, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(selectedIndex: 0, selectedColor: kPink),
        const DateCurrencySelector(dateText: 'Sep 2026'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Expense '),
                    TextSpan(text: '-210.4', style: TextStyle(color: kYellow, fontWeight: FontWeight.bold)),
                  ])),
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Income '),
                    TextSpan(text: '900', style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              Row(
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Balance '),
                    TextSpan(text: '689.6', style: TextStyle(color: kPink, fontWeight: FontWeight.bold)),
                  ])),
                  if (onToggle != null)
                    IconButton(
                      icon: const Icon(Icons.auto_graph),
                      onPressed: onToggle,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Sep 20', 'Sep 5', 'Sep 3', 'Sep 1'];
                        if (value.toInt() >= 0 && value.toInt() < texts.length) {
                          return Text(texts[value.toInt()], style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(left: BorderSide(), bottom: BorderSide())),
                lineBarsData: [
                  LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 880), FlSpot(2, 10), FlSpot(3, 10)], isCurved: false, color: kPink, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 880), FlSpot(2, 20), FlSpot(3, 20)], isCurved: false, color: kBlue, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 20), FlSpot(2, 50), FlSpot(3, 50)], isCurved: false, color: kYellow, dotData: const FlDotData(show: true)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.sort, size: 20),
                    ],
                  ),
                ),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 20', amount: '\$-6'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 8', amount: '\$0'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 5', amount: '\$885.2'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 4', amount: '\$-47.4'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ================= 畫面 3: 收入 (年 - 圓餅圖) =================
class IncomePieScreen extends StatelessWidget {
  const IncomePieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(selectedIndex: 2, selectedColor: kBlue),
        const DateCurrencySelector(dateText: '2026'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: [
                            PieChartSectionData(color: kBlue, value: 100, showTitle: false, radius: 40,borderSide: const BorderSide(color: Colors.black, width: 2), ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total income', style: TextStyle(fontSize: 14, color: Colors.black87)),
                            Text('\$7,792', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildLegend(kBlue, 'Salary  100%'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Icon(Icons.sort, size: 20),
                          ],
                        ),
                      ),
                      const DetailListItem(icon: Icons.account_balance_wallet, iconBgColor: kBlue, title: 'Salary', amount: '\$7,792'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ================= 畫面 4: 結餘 (年 - 折線圖) =================
class BalanceLineYearScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  const BalanceLineYearScreen({super.key, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(selectedIndex: 2, selectedColor: kPink),
        const DateCurrencySelector(dateText: '2026'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Expense '),
                    TextSpan(text: '-9,540.8', style: TextStyle(color: kYellow, fontWeight: FontWeight.bold)),
                  ])),
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Income '),
                    TextSpan(text: '7,792', style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              Row(
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Balance '),
                    TextSpan(text: '-1,748.8', style: TextStyle(color: kPink, fontWeight: FontWeight.bold)),
                  ])),
                  if (onToggle != null)
                    IconButton(
                      icon: const Icon(Icons.show_chart),
                      onPressed: onToggle,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Sep', 'Jun', 'Mar'];
                        if (value.toInt() >= 0 && value.toInt() < texts.length) {
                          return Text(texts[value.toInt()], style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(left: BorderSide(), bottom: BorderSide())),
                lineBarsData: [
                  LineChartBarData(spots: const [FlSpot(0, 900), FlSpot(1, -100), FlSpot(2, -100)], isCurved: false, color: kPink, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 900), FlSpot(1, 500), FlSpot(2, 500)], isCurved: false, color: kBlue, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 300), FlSpot(1, 1000), FlSpot(2, 1000)], isCurved: false, color: kYellow, dotData: const FlDotData(show: true)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.sort, size: 20),
                    ],
                  ),
                ),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep', amount: '\$689.6'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Aug', amount: '\$-1,097.4'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Jul', amount: '\$-1,171.8'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Jun', amount: '\$-464'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ================= 畫面 5: 支出 (年 - 柱狀圖) =================
class ExpenseBarScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  const ExpenseBarScreen({super.key, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(selectedIndex: 2, selectedColor: kYellow),
        const DateCurrencySelector(dateText: '2026'),
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
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Shopping', 'Food & drink', 'Transportation'];
                        if (value.toInt() >= 0 && value.toInt() < texts.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(texts[value.toInt()], style: const TextStyle(fontSize: 10)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(left: BorderSide(), bottom: BorderSide())),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0, color: kYellow, width: 30, )]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80.3, color: kPink, width: 30, )]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 19.7, color: kBlue, width: 30, )]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.sort, size: 20),
                    ],
                  ),
                ),
                const DetailListItem(icon: Icons.circle, iconBgColor: kPink, title: 'Food & drink', amount: '\$7,665.6'),
                const DetailListItem(icon: Icons.circle, iconBgColor: kBlue, title: 'Transportation', amount: '\$1,875.2'),
                const DetailListItem(icon: Icons.circle, iconBgColor: kYellow, title: 'Shopping', amount: '\$0'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}