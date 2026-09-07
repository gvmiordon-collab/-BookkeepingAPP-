import 'package:bookkeeping/assets_card.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/transactions_table.dart';
import 'package:bookkeeping/calculator/calculator_page.dart';
import 'package:bookkeeping/drawer_pages/drawer_buttons.dart';
import 'package:bookkeeping/drawer_pages/asset_card_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> buttonText =[
    'Asset Cards',
    'History',
  ];

  final List<String> date = [
    '2026/09/05 Sat',
    '2026/09/04 Fri',
    '2026/09/03 Thu',
  ];

  final List<String> assetNamed = [
    'Total Balance',
    'Cash',
    'Bank',
  ];

  final List<String> assetAmount = [
    '\$ 5000',
    '\$ 2000',
    '\$ 3000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: const Text('Home Page'),
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
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssetCardPages()),
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
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
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
                    return TransactionsTable(
                        date: date[index]
                    );
                  },
                childCount: date.length,
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

    );
  }
}
