import 'package:flutter/material.dart';

class MonthlyExpenseAndIncomeSummary extends StatefulWidget {
  const MonthlyExpenseAndIncomeSummary({super.key});

  @override
  State<MonthlyExpenseAndIncomeSummary> createState() => _MonthlyExpenseAndIncomeSummaryState();
}

class _MonthlyExpenseAndIncomeSummaryState extends State<MonthlyExpenseAndIncomeSummary> {
  @override
  Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              Text(
                '\$10,000,000,203.4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
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
              Text(
                '\$10,00',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );
  }
}
