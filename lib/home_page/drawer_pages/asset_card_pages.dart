import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/assets_card.dart';

class AssetCardPages extends StatefulWidget {
  const AssetCardPages({super.key});

  @override
  State<AssetCardPages> createState() => _AssetCardPagesState();
}

class _AssetCardPagesState extends State<AssetCardPages> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: const Text('Asset Cards'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: assetNamed.length,
          itemBuilder: (BuildContext context, int index){
        return AssetsCard(
          assetAmount: assetAmount[index],
          assetNamed: assetNamed[index],
        );
      }),
    );
  }
}
