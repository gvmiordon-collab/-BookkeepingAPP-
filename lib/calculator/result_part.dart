import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/calculator/footnote_model.dart';
import 'package:bookkeeping/providers/footnote_provider.dart';
import 'package:bookkeeping/database/app_database.dart' show FootnoteTag;

// ← 改:StatefulWidget → StatelessWidget,原本嗰個 state(假 footnote list)已經冚咗俾 FootnoteProvider
class ResultPart extends StatelessWidget {
  final String userQuestions;
  final String finalQuestions;
  final TextEditingController footnoteController;

  const ResultPart({
    super.key,
    required this.userQuestions,
    required this.finalQuestions,
    required this.footnoteController,
  });

  void _openMoreSheet(BuildContext context) {
    final footnoteProvider = context.read<FootnoteProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: footnoteProvider,
        child: _FootnoteManageSheet(footnoteController: footnoteController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recent = context.watch<FootnoteProvider>().recent;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: AutoSizeText(
                    '\$ $userQuestions',
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: footnoteController,
                    decoration: const InputDecoration(hintText: 'footnote', isDense: true),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recent.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == recent.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () => _openMoreSheet(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('More'),
                            Icon(Icons.mode_edit_outline_outlined, size: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final tag = recent[index];
                return FootnoteModel(
                  footnote: tag.label,
                  onTap: () => footnoteController.text = tag.label,   // ← 加:撳落去填入 textfield
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// More bottom sheet 本體 —— 抽做獨立 StatefulWidget,因為要自己嘅 edit-mode 開關 state
class _FootnoteManageSheet extends StatefulWidget {
  final TextEditingController footnoteController;
  const _FootnoteManageSheet({required this.footnoteController});

  @override
  State<_FootnoteManageSheet> createState() => _FootnoteManageSheetState();
}

class _FootnoteManageSheetState extends State<_FootnoteManageSheet> {
  bool _editMode = false;   // ⚠️ 撳 pencil 掣 → 入編輯模式,每行右邊有刪除掣(跟 Categories 頁個 pattern)

  @override
  Widget build(BuildContext context) {
    final all = context.watch<FootnoteProvider>().all;

    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Text('More footnote.',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  IconButton(
                    icon: Icon(_editMode ? Icons.check : Icons.mode_edit_outline_outlined, size: 20),
                    onPressed: () => setState(() => _editMode = !_editMode),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black, height: 1, thickness: 1.5),
            Expanded(
              child: all.isEmpty
                  ? const Center(child: Text('未有 footnote', style: TextStyle(color: Colors.black38)))
                  : ListView.builder(
                itemCount: all.length,
                itemBuilder: (BuildContext context, int index) {
                  final FootnoteTag tag = all[index];
                  return Column(
                    key: ValueKey(tag.id),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        title: Text(tag.label, style: const TextStyle(fontSize: 18, color: Colors.black87)),
                        trailing: _editMode
                            ? IconButton(
                          icon: const Icon(Icons.delete_rounded, color: Colors.red),
                          onPressed: () =>
                              context.read<FootnoteProvider>().deleteFootnote(tag.id),
                        )
                            : null,
                        onTap: _editMode
                            ? null
                            : () {
                          widget.footnoteController.text = tag.label;
                          Navigator.pop(context);
                        },
                      ),
                      Divider(color: Colors.grey[300], height: 1, thickness: 1),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}