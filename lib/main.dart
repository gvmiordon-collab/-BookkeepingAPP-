import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← 加:SystemChrome
import 'package:provider/provider.dart';
import 'package:bookkeeping/home_page/home.dart';
import 'package:bookkeeping/database/app_database.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';
import 'package:bookkeeping/providers/asset_provider.dart';   // ← import
import 'package:bookkeeping/providers/fixed_item_provider.dart';
import 'package:bookkeeping/providers/footnote_provider.dart';   // ← 加

/// ← 加:App 內文字最大放大倍數(1.0 = 完全唔跟手機「字體大小」設定,同 emulator 一樣)。
/// 成個 UI 嘅掣、格仔、padding 都係按 1.0 倍字體設計,手機系統字體調大咗(例如 1.3–1.5 倍)
/// 就會變成「老人機」咁:字大晒、掣塞滿、啲嘢走位。
/// ⚠️ 取捨:鎖死 1.0 即係視障用家調大字體都冇用。想放鬆少少就改成 1.1 / 1.15。
const double kMaxTextScale = 1.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ← 加:畫面延伸到系統導航條(底部手勢條)底下,導航條透明,
  // 咁底部就唔會有條黑色嘅橫條(各頁用 SafeArea / viewPadding 自己避開手勢條)。
  // ⚠️ 手勢條嗰條細細嘅橫線(home indicator)係 Android 系統畫嘅,App 移除唔到。
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness: Brightness.dark, // 淺色背景,手勢條用深色
  ));
  runApp(MyApp()); // 由 const MyApp() 改為 MyApp(),因為下面加咗個非 const field
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppDatabase _db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: _db),
        ChangeNotifierProvider(create: (_) => CategoryProvider(_db)),
        ChangeNotifierProvider(create: (_) => TransactionProvider(_db)),
        ChangeNotifierProvider(create: (_) => AssetProvider(_db)),
        ChangeNotifierProvider(create: (_) => FixedItemProvider(_db)),
        ChangeNotifierProvider(create: (_) => FootnoteProvider(_db)),
      ],
      child: MaterialApp(
        // ← 加:全 App 統一限制字體倍數(見上面 kMaxTextScale)
        builder: (context, child) => MediaQuery.withClampedTextScaling(
          minScaleFactor: 1.0,
          maxScaleFactor: kMaxTextScale,
          child: child!,
        ),
        home: HomePage(),
      ),
    );
  }
}