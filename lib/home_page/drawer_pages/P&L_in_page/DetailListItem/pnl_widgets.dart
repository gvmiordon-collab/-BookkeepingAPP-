// lib/home_page/drawer_pages/P&L_in_page/DetailListItem/pnl_widgets.dart(新檔案)
// 五個 P&L screen 共用嘅「有數據」widget。純畫面:淨係收 pnl_logic.dart 計好嘅 PnlReport / PnlSeries 顯示,
// 唔做任何加總或者讀 DB。樣式(顏色、邊框、字體大小)全部照返你原本各個 screen 入面寫死嗰套。

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bookkeeping/utils/category_group.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/utils/formatters.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';

/// '$7,665.6' / '$-6'
String pnlMoney(double v) => '\$${fmtAmount(v, grouped: true)}';

// ---------- Pie ----------

/// 圓餅 + 中間疊字(Total expense / Total income)。按 group 分色。
class PnlPieView extends StatelessWidget {
  final List<PnlGroupTotal> groups;
  final String centerLabel;
  final double total;

  const PnlPieView({
    super.key,
    required this.groups,
    required this.centerLabel,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // ⚠️ 冇數據嗰陣畫一個灰色空圈(fl_chart 冇 section 會畫唔到嘢)
    final sections = groups.isEmpty
        ? [
      PieChartSectionData(
        color: Colors.grey.shade300,
        value: 1,
        showTitle: false,
        radius: 40,
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
    ]
        : [
      for (final g in groups)
        PieChartSectionData(
          color: categoryColorForGroup(g.groupKey),
          value: g.total,
          showTitle: false,
          radius: 40,
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
    ];

    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: sections,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(centerLabel, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                Text(pnlMoney(total), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 圓餅下面嗰個 legend 框:每個 group 一粒色 + 名 + 百分比。
/// ⚠️ 原本係寫死兩行 Row,而家 group 數量唔固定,改用 Wrap(自動換行);冇數據就成個框收埋。
class PnlLegendBox extends StatelessWidget {
  final List<PnlGroupTotal> groups;

  const PnlLegendBox({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: [
          for (final g in groups)
            _legendItem(
              categoryColorForGroup(g.groupKey),
              '${categoryGroupByKey(g.groupKey).label}  ${fmtAmount(g.percent)}%',
            ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ---------- Bar ----------

/// 長條圖:每個 group 一條,高度 = 佔總額嘅百分比(跟你原本 maxY: 100 嗰套)
class PnlBarView extends StatelessWidget {
  final List<PnlGroupTotal> groups;

  const PnlBarView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final labels = [for (final g in groups) categoryGroupByKey(g.groupKey).label];

    // ⚠️ 冇數據嗰陣放一條透明、高度 0 嘅 bar,保住個軸(BarChart 完全冇 group 可能會出事)
    final barGroups = groups.isEmpty
        ? [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 0, color: Colors.transparent, width: 30)],
      ),
    ]
        : [
      for (var i = 0; i < groups.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: groups[i].percent,
              color: categoryColorForGroup(groups[i].groupKey),
              width: 30,
            ),
          ],
        ),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i >= 0 && i < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(labels[i], style: const TextStyle(fontSize: 10)),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(left: BorderSide(), bottom: BorderSide()),
        ),
        barGroups: barGroups,
      ),
    );
  }
}

// ---------- Details 框 ----------

/// 「Details」/「Date」嗰個框。
/// [scrollable] = true:框要放喺 Expanded 入面(Bar / Balance screen),行數多就喺框入面捲動;
/// false:放喺 SingleChildScrollView 入面(Pie screen),跟內容撐高。
/// ⚠️ 原本 Bar / Balance screen 係寫死 4 行 Column,真數據行數唔固定,所以改用 ListView(外觀一樣)。
class PnlDetailsBox extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  final bool scrollable;

  const PnlDetailsBox({
    super.key,
    required this.title,
    required this.rows,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Icon(Icons.sort, size: 20),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: scrollable
          ? Column(
        children: [
          header,
          Expanded(child: ListView(padding: EdgeInsets.zero, children: rows)),
        ],
      )
          : Column(children: [header, ...rows]),
    );
  }
}

/// Expense / Income 嘅 Details 行:逐個 category,icon 底色跟 group
List<Widget> pnlCategoryRows(List<PnlCategoryTotal> items) => [
  for (final c in items)
    DetailListItem(
      icon: categoryIconData(c.iconKey),
      iconBgColor: categoryColorForGroup(c.groupKey),
      title: c.label,
      amount: pnlMoney(c.total),
    ),
];

/// Balance 嘅 Date 行:新 → 舊。
/// ⚠️ 淨係列「嗰日 / 嗰個月有交易」嘅 bucket(冇交易嘅日子唔列,折線圖就照樣有嗰啲點)
List<Widget> pnlDateRows(PnlSeries series) => [
  for (final b in series.buckets.reversed)
    if (b.hasActivity)
      DetailListItem(
        icon: Icons.calendar_today,
        iconBgColor: Colors.transparent,
        title: b.label,
        amount: pnlMoney(b.balance),
      ),
];

// ---------- Balance ----------

/// Balance screen 頂部 Expense / Income / Balance 三行字 + 切換掣
class PnlBalanceSummary extends StatelessWidget {
  final PnlReport report;
  final VoidCallback? onToggle;
  final IconData toggleIcon;

  const PnlBalanceSummary({
    super.key,
    required this.report,
    required this.onToggle,
    required this.toggleIcon,
  });

  @override
  Widget build(BuildContext context) {
    // 支出顯示做負數(跟你原本 '-210.4');0 就顯示 0,唔好出 '-0'
    final expenseText =
    report.totalExpense > 0 ? '-${fmtAmount(report.totalExpense, grouped: true)}' : '0';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line('Expense ', expenseText, kYellow),
              _line('Income ', fmtAmount(report.totalIncome, grouped: true), kBlue),
            ],
          ),
          Row(
            children: [
              _line('Balance ', fmtAmount(report.balance, grouped: true), kPink),
              if (onToggle != null)
                IconButton(
                  icon: Icon(toggleIcon),
                  onPressed: onToggle,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        children: [
          TextSpan(text: label),
          TextSpan(text: value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// 三條線:Balance(粉)/ Income(藍)/ Expense(黃)。
/// ⚠️ Expense 線畫正數(支出金額大細),Balance 可以跌去負數。
class PnlLineView extends StatelessWidget {
  final PnlSeries series;
  final double leftReservedSize;

  const PnlLineView({
    super.key,
    required this.series,
    required this.leftReservedSize,
  });

  List<FlSpot> _spots(double Function(PnlBucket b) pick) => [
    for (var i = 0; i < series.buckets.length; i++)
      FlSpot(i.toDouble(), pick(series.buckets[i])),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: series.maxX,
        minY: series.minY,
        maxY: series.maxY,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: leftReservedSize),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: series.labelInterval.toDouble(),
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if ((value - i).abs() > 0.001 || i < 0 || i >= series.buckets.length) {
                  return const Text('');
                }
                return Text(series.buckets[i].label, style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(left: BorderSide(), bottom: BorderSide()),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _spots((b) => b.balance),
            isCurved: false,
            color: kPink,
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: _spots((b) => b.income),
            isCurved: false,
            color: kBlue,
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: _spots((b) => b.expense),
            isCurved: false,
            color: kYellow,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}