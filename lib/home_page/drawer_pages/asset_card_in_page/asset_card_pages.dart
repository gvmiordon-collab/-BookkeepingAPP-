import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/assets_card.dart';
import 'package:bookkeeping/home_page/drawer_pages/asset_card_in_page/add_a_new_asset_card.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/asset_provider.dart';
import 'package:bookkeeping/utils/formatters.dart';

class AssetCardPages extends StatefulWidget {
  const AssetCardPages({super.key});

  @override
  State<AssetCardPages> createState() => _AssetCardPagesState();
}

class _AssetCardPagesState extends State<AssetCardPages> {


  @override
  Widget build(BuildContext context) {
    final cards = context.watch<AssetProvider>().displayCards;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: const Text('Asset Cards'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (BuildContext context, int index) {
          return AssetsCard(
            assetNamed: cards[index].name,
            assetAmount: fmtAmount(cards[index].balance, grouped: true),
          );
        },
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
            MaterialPageRoute(builder: (context) => AddANewAssetCard()),
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
