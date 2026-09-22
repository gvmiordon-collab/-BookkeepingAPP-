import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_items_model.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/add_a_new_fixed_item.dart';

class FixedItemPages extends StatefulWidget {
  const FixedItemPages({super.key});

  @override
  State<FixedItemPages> createState() => _FixedItemPagesState();
}

class _FixedItemPagesState extends State<FixedItemPages> {

  final List<String> fixedItemsName = [
    'Transportation',
    'food'
  ];

  final List<String> categoryName = [
    'Transportation',
    'Food & Drink',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fixed Income/Expense'),
        centerTitle: true,
      ),
      body:ListView.builder(
        itemCount: fixedItemsName.length,
          itemBuilder: (BuildContext context, int index){
            return FixedItemsModel(
              fixedItemsName: fixedItemsName[index],
              categoryName: categoryName[index],
            );
          }
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
            MaterialPageRoute(builder: (context) => CreateANewFixedItem()),
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
