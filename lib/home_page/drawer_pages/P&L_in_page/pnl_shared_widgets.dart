import 'package:flutter/material.dart';

// 頂部 Tab (Expe / Inco / Bala)
class TopTabs extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  final ValueChanged<int> onTabSelected;

  const TopTabs({
    super.key,
    required this.selectedIndex,
    required this.selectedColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTab('Expe...', 0),
          _buildTab('Inco...', 1),
          _buildTab('Bala...', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(6) : Radius.zero,
              right: index == 2 ? const Radius.circular(6) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 時間 Filter Tab (MTH / Last 6 / Year / Custom)
// ⚠️ 改:刪走重複又寫錯 type(void)嘅 timeFilterIndex/onTimeFilterChanged,
// 淨返 selectedIndex/onTabSelected 呢一套;各 screen 自己嘅 timeFilterIndex 傳呢度嗰陣就用呢兩個名。
class TimeFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  final ValueChanged<int> onTabSelected;

  const TimeFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.selectedColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['MTH', 'Last 6 ...', 'Year', 'Custom'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            bool isSelected = selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: isSelected ? selectedColor : Colors.transparent,
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// 日期 Selector(貨幣掣已刪)
class DateCurrencySelector extends StatelessWidget {
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const DateCurrencySelector({
    super.key,
    required this.dateText,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPrevious,
            child: const Icon(Icons.arrow_left, size: 24),
          ),
          const SizedBox(width: 8),
          Text(dateText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onNext,
            child: const Icon(Icons.arrow_right, size: 24),
          ),
        ],
      ),
    );
  }
}

// 底部清單 Item
class DetailListItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String amount;
  const DetailListItem({super.key, required this.icon, required this.iconBgColor, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black54, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}