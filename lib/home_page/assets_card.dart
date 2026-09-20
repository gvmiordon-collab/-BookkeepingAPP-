import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';   // ← import

class AssetsCard extends StatefulWidget {

  final String assetNamed;
  final String assetAmount;

  const AssetsCard({
    super.key,
    required this.assetNamed,
    required this.assetAmount,
  });

  @override
  State<AssetsCard> createState() => _AssetsCardState();
}

class _AssetsCardState extends State<AssetsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 2/1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple[600],
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.assetNamed,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  '\$ ${widget.assetAmount}',
                  maxLines: 1,
                  minFontSize: 20,                 // ⚠️ 下限我暫定 20,自己試
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
