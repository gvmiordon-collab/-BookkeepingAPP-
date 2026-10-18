import 'package:flutter/material.dart';
import 'package:bookkeeping/utils/formatters.dart';

class MonthlyExpenseAndIncomeSummary extends StatefulWidget {
  final double expense;
  final double income;

  const MonthlyExpenseAndIncomeSummary({
    super.key,
    required this.expense,
    required this.income,
  });

  @override
  State<MonthlyExpenseAndIncomeSummary> createState() => _MonthlyExpenseAndIncomeSummaryState();
}

class _MonthlyExpenseAndIncomeSummaryState extends State<MonthlyExpenseAndIncomeSummary> {
  @override
  Widget build(BuildContext context) {
      // ← 改:左右兩邊各包 Flexible,入面嘅標籤 / 金額包 FittedBox(scaleDown)。
      // 原本兩個 Column 都係「唔會縮」嘅闊度,窄機或者金額好大(例如 $10,000,000,203.4)就會 Row overflow;
      // 而家位夠嘅時候大細同原本一模一樣,唔夠位先會自動縮細。
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 2, //越細條線就越貼近descender
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color:  Color(0xFFF5A623),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Monthly expense',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$${fmtAmount(widget.expense, grouped: true)}',   // 原本 '\$10,000,000,203.4'
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // ← 加:兩邊最少隔 8,擠嗰陣唔會黐埋一齊
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerRight,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 2, //越細條線就越貼近descender
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Monthly Income',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\$${fmtAmount(widget.income, grouped: true)}',    // 原本 '\$10,00'
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
