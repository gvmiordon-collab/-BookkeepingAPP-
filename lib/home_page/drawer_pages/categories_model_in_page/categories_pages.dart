import 'package:flutter/material.dart';
import 'package:bookkeeping/calculator/expense_income_button.dart';
import 'package:bookkeeping/home_page/drawer_pages/categories_model_in_page/add_a_new_category.dart';

class CategoriesPages extends StatefulWidget {
  const CategoriesPages({super.key});

  @override
  State<CategoriesPages> createState() => _CategoriesPagesState();
}

class _CategoriesPagesState extends State<CategoriesPages> {


  final List<Map<String, dynamic>> categoryItems = [
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.directions_transit_sharp, 'label': 'Transportation'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Snack'},
    {'icon': Icons.grid_view_outlined, 'label': 'other'},
    {'icon': Icons.grid_view_outlined, 'label': 'other'},
    // 之後想加多幾個分類，喺呢度加落去就得
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,

        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_sharp)
          ),
        ],

      ),
      body: Center(
        child: Column(
          children: [
            ExpenseIncomeButton(

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
                itemCount: categoryItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = categoryItems[index];
                  return Container(/*
                    在按了上方的 icon: Icon(Icons.edit_sharp)， 這個Container會有個用stack的widget(樣式如下) 堆疊係個Border 的左上角
                                Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30,)
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                    Icons.delete_rounded,
                  color: Colors.white,
                ),
              ),
            ),
                     */
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    child: Padding( 
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Icon(item['icon'] as IconData),
                          const SizedBox(height: 5),
                          Text(
                            item['label'] as String,
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
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //在按了上方的 icon: Icon(Icons.edit_sharp) 才會出現
      floatingActionButton: Padding(
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
              MaterialPageRoute(builder: (context) => CustomCategories()
              )
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
      ),
    );
  }
}
