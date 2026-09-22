import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart';
import 'package:bookkeeping/home_page/drawer_pages/categories_model_in_page/add_a_new_category.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';

class CategoriesPages extends StatefulWidget {
  const CategoriesPages({super.key});

  @override
  State<CategoriesPages> createState() => _CategoriesPagesState();
}

class _CategoriesPagesState extends State<CategoriesPages> {


// State 入面：刪走成個 categoryItems list，改成
  bool _isExpense = true;
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final items = _isExpense
        ? provider.activeExpenseCategories
        : provider.activeIncomeCategories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () => setState(() => _editMode = !_editMode),   // ← 原本 () {}
            icon: Icon(_editMode ? Icons.check : Icons.edit_sharp),    // ← 原本 Icons.edit_sharp
          ),
        ],

      ),
      body: Center(
        child: Column(
          children: [
            ExpenseIncomeButton(
              onChanged: (v) => setState(() => _isExpense = v),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                'Categories Page',
              style: TextStyle(
                fontSize: 20,
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
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  final cell = Container(
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

                  return Stack(
                    fit: StackFit.expand, // 冇呢行,格仔會縮到貼住內容
                    children: [
                      cell,
                      if (_editMode)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () =>
                                context.read<CategoryProvider>().deleteCategory(item.id),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(Icons.delete_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //在按了上方的 icon: Icon(Icons.edit_sharp) 才會出現
      floatingActionButton: _editMode
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFBC02D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            minimumSize: Size(double.infinity,50)
          ),
            onPressed: (){
            Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => CustomCategories(isExpense: _isExpense)),
            );
            },
            child: Text(
                'Add',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
        ),
      )
          : null,
    );
  }
}
