const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
// ⚠️ 跟 DateButton 註解嘅寫法,9 月係 'Sept'(Home 嘅月份 picker 用 'Sep',兩邊而家唔一致)
const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec',
];

String _two(int n) => n.toString().padLeft(2, '0');

/// Home 每日標題:'2026/09/05 Sat'
String fmtDateHome(DateTime d) =>
    '${d.year}/${_two(d.month)}/${_two(d.day)} ${_weekdays[d.weekday - 1]}';

/// DateButton 顯示:'Today Thu, Sept 03, 2026' / 'Tue, Sept 11, 2026'
String fmtDateButton(DateTime d, {DateTime? now}) {
  final n = now ?? DateTime.now();
  // 用 UTC 計日數差,避免夏令時間轉換嗰日(23/25 小時)令 inDays 計錯
  final diff = DateTime.utc(d.year, d.month, d.day)
      .difference(DateTime.utc(n.year, n.month, n.day))
      .inDays;
  final prefix = switch (diff) {
    0 => 'Today ',
    -1 => 'Yesterday ',
    1 => 'Tomorrow ',
    _ => '',
  };
  return '$prefix${_weekdays[d.weekday - 1]}, ${_monthNames[d.month - 1]} ${_two(d.day)}, ${d.year}';
}

/// 5.0 → "5",5.50 → "5.5",grouped: true → "10,000.5"
String fmtAmount(double v, {bool grouped = false}) {
  var s = v.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  if (!grouped) return s;
  final neg = s.startsWith('-');
  if (neg) s = s.substring(1);
  final parts = s.split('.');
  final intPart = parts[0]
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return '${neg ? '-' : ''}$intPart${parts.length > 1 ? '.${parts[1]}' : ''}';
}