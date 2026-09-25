import 'package:flutter/material.dart';

class FootnoteModel extends StatelessWidget {
  final String? footnote;
  final VoidCallback? onTap;   // ← 加

  const FootnoteModel({
    super.key,
    this.footnote,
    this.onTap,   // ← 加
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(          // ← 加,包住原本個 Container
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              footnote ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}