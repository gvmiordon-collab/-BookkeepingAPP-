import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {

  bool _isExpense = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final items = _isExpense
        ? provider.activeExpenseCategories
        : provider.activeIncomeCategories;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Column(
            children: [
              Text(
                'Expense',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
                thickness: 4,
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: items.length,
                shrinkWrap: true, // 讓 ListView 只佔用內容所需的高度
                physics: NeverScrollableScrollPhysics(), // 停用 ListView 自身的滾動
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Icon(categoryIconData(item.iconKey)),
                          const SizedBox(height: 5),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            softWrap: false,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),

          Column(
            children: [
              Text(
                'Income',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
                thickness: 4,
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: items.length,
                shrinkWrap: true, // 讓 ListView 只佔用內容所需的高度
                physics: NeverScrollableScrollPhysics(), // 停用 ListView 自身的滾動
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Icon(categoryIconData(item.iconKey)),
                          const SizedBox(height: 5),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            softWrap: false,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );


                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
