import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';   // ← 加

class AssetsCard extends StatefulWidget {

  final String assetNamed;
  final String assetAmount;
  final int? id;                // ← 加:null = Total Balance,唔可以刪
  final VoidCallback? onDelete; // ← 加:冇畀就唔會有滑動刪除(Home carousel 用)

  const AssetsCard({
    super.key,
    required this.assetNamed,
    required this.assetAmount,
    this.id,                    // ← 加
    this.onDelete,              // ← 加
  });

  @override
  State<AssetsCard> createState() => _AssetsCardState();
}

class _AssetsCardState extends State<AssetsCard> {
  @override
  Widget build(BuildContext context) {
    final card = Padding(                    // ← 原本個 return 直接改名叫 card
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 2/1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple[600],
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          // ← 加 LayoutBuilder:卡係固定 2:1,卡矮咗(窄機 / 系統字體放大)就將兩行字按比例縮細,
          // 唔會 Column overflow。卡夠高(縮放比例 = 1)嗰陣同原本一模一樣。
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 26 + 60 兩行字(連 Material 預設行高 1.43)大約要 123 高,126 留少少餘地;40 = 上下 padding
              final textScale = MediaQuery.textScalerOf(context).scale(1.0);
              final s = ((constraints.maxHeight - 40) / (126 * textScale))
                  .clamp(0.4, 1.0)
                  .toDouble();
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.assetNamed,
                      maxLines: 1,                      // ← 加:名太長就 ... 唔好換行撐高
                      overflow: TextOverflow.ellipsis,  // ← 加
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26 * s,               // ← 改:原本 26
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      '\$ ${widget.assetAmount}',
                      maxLines: 1,
                      minFontSize: 20 * s,              // ← 改:原本 20
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60 * s,               // ← 改:原本 60
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    // id / onDelete 冇齊 → 唔包 Slidable(Total Balance 卡、Home 橫向 carousel 就係咁)
    if (widget.id == null || widget.onDelete == null) return card;   // ← 加

    return Slidable(                        // ← 加,跟 transactions_table.dart 個做法
      key: ValueKey(widget.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDelete!(),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: card,
    );
  }
}