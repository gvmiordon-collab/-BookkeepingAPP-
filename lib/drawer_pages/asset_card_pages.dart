import 'package:flutter/material.dart';
import 'package:bookkeeping/assets_card.dart';

class AssetCardPages extends StatelessWidget {
  const AssetCardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: const Text('Asset Cards'),
        centerTitle: true,
      ),
    );
  }
}
