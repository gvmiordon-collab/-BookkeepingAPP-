import 'package:flutter/material.dart';

class TransactionsTable extends StatelessWidget {
  final String date;

  const TransactionsTable({
    super.key,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 讓高度根據內容自適應，可以省去 IntrinsicHeight
          children: [
            // 1. 日付和合計金額的行（加上內邊距）
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$ -200', //如果係總數係正數就用呢隻色color: Colors.lightBlue
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 2. 這是分界線（直接放 Column 內，會自動填滿 Container 的闊度）
            const Divider(
              color: Colors.black,
              thickness: 3,
              height: 1, // 控制分界線佔用的空間高度
            ),

            // 3. 下方的文字行（加上內邊距）
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.directions_transit_sharp),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Transportation',  //呢度係footnote的對應地方，如果user有係calculator_pages中的footnote textfield 度有寫嘢，否則按照Categories icon所設定的名字
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                          '\$ -100',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),

                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,

                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.directions_transit_sharp),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Transportation',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                          '\$ -100',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,

                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.directions_transit_sharp),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Salary',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                          '\$ 100',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
