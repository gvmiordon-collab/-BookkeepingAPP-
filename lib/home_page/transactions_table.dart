import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/database/app_database.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/utils/formatters.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';
import 'package:bookkeeping/calculator/calculator_page.dart';

class TransactionsTable extends StatelessWidget {
  final DateTime date;
  final List<TransactionEntry> entries;

  const TransactionsTable({
    super.key,
    required this.date,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    // 當日合計:收入 +、支出 -
    final total = entries.fold<double>(
        0, (sum, t) => sum + (t.isExpense ? -t.amount : t.amount));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fmtDateHome(date),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$ ${fmtAmount(total, grouped: true)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: total >= 0 ? Colors.lightBlue : Colors.orange, // 正數藍、負數橙(跟你原本註解)
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black, thickness: 3, height: 1),
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0)
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
              _buildRow(context, entries[i], categoryProvider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, TransactionEntry t,
      CategoryProvider categoryProvider) {
    final category = categoryProvider.categoryById(t.categoryId);
    final title = (t.footnote != null && t.footnote!.isNotEmpty)
        ? t.footnote!
        : (category?.label ?? '');
    final amountText =
        '\$ ${t.isExpense ? '-' : ''}${fmtAmount(t.amount, grouped: true)}';

    return Slidable(
      key: ValueKey(t.id),
      // endActionPane = 向左滑先會彈出嚟(startActionPane 先係向右滑)
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                context.read<TransactionProvider>().deleteTransaction(t.id),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      // 撳一下 → 跳去 Calculator page(編輯模式)
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CalculatorPage(editing: t)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(category == null
                  ? Icons.grid_view_outlined
                  : categoryIconData(category.iconCodePoint)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amountText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}