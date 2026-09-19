import 'package:bookkeeping/home_page/assets_card.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/transactions_table.dart';
import 'package:bookkeeping/calculator/calculator_page.dart';
import 'package:bookkeeping/home_page/drawer_pages/drawer_buttons.dart';
import 'package:bookkeeping/home_page/drawer_pages/asset_card_in_page/asset_card_pages.dart';
import 'package:bookkeeping/home_page/drawer_pages/categories_model_in_page/categories_pages.dart';
import 'package:bookkeeping/home_page/month_year_picker.dart';
import 'package:bookkeeping/test_page.dart';
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_item_pages.dart';
import 'package:bookkeeping/home_page/monthly_expense_and_income_summary.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _pickerExpanded = false;
  DateTime _selectedDate = DateTime(2026, 9);

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final List<String> buttonText =[
    'Asset Cards',
    'Categories',
    'Fixed items',
    'History', //就咁display哂所有transaction_table 就可以
    'Test Page',
  ];

  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month);

  final List<String> assetNamed = [
    'Total Balance',
    'Cash',
    'Bank',
  ];

  final List<String> assetAmount = [
    '5000',
    '2000',
    '3000',
  ];

  @override
  Widget build(BuildContext context) {
    // AppBar 底部 y 座標（狀態欄 + 工具列高度）
    final topOffset =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    final txProvider = context.watch<TransactionProvider>();
    final grouped = txProvider.transactionsGroupedByDate(_selectedDate);
    final days = grouped.keys.toList(); // 已經係新 → 舊

    return Stack(
      children: [
         Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: GestureDetector(
          onTap: () =>
              setState(() => _pickerExpanded = !_pickerExpanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_months[_selectedDate.month - 1]} ${_selectedDate.year}',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Icon(
                _pickerExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                size: 28,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  border: Border.all(
                    width: 2.0,
                  ),
                ),

                child: Center(
                    child: Text(
                        'MENU',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: ListView.builder(
                  itemCount: buttonText.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DrawerButtons(
                        buttonText: buttonText[index],
                        onTap: () {
                          if (index == 0) { //Asset Card
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssetCardPages()),
                            );
                          } else if (index == 1) { //Categories
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CategoriesPages()),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FixedItemPages()),
                            );
                          } else if (index == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TestPage(
                                expense: 100,
                                income: 200,
                                balance: 300,
                              )),
                            );
                          }
                        },
                      );
                    }
                )
              ),
            ),
          ],
        ),
    ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: MonthlyExpenseAndIncomeSummary(
                expense: txProvider.totalExpenseForMonth(_selectedDate),
                income: txProvider.totalIncomeForMonth(_selectedDate),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: assetNamed.length,
                  itemBuilder: (BuildContext context, int index) {
                return AssetsCard(
                  assetAmount: assetAmount[index],
                  assetNamed: assetNamed[index],
                );
              },
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final day = days[index];
                return TransactionsTable(date: day, entries: grouped[day]!);
              },
              childCount: days.length,
            ),
          ),
        ],
    ),

      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange[300],
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          elevation: 5,
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalculatorPage()),
            );
          } ,
          child: Icon(Icons.add,
          color: Colors.white,
          size: 40,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ),
        // === 浮動面板層 ===
        if (_pickerExpanded) ...[
          // 半透明遮罩
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _pickerExpanded = false),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          // 面板本體，貼喺 AppBar 下面
          Positioned(
            top: topOffset,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              color: Colors.white,
              child: MonthYearPanel(
                initialDate: _selectedDate,
                onChanged: (d) {
                  setState(() {
                    _selectedDate = d;
                    _pickerExpanded = false;
                  });
                  // TODO: 喺度根據 d 重新 load 對應月份嘅資料
                },
              ),
            ),
          ),
        ],
    ],
    );
  }
}
