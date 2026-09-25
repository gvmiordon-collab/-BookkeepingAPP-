import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/home_page/home.dart';
import 'package:bookkeeping/database/app_database.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/providers/transaction_provider.dart';
import 'package:bookkeeping/providers/asset_provider.dart';   // ← import
import 'package:bookkeeping/providers/fixed_item_provider.dart';
import 'package:bookkeeping/providers/footnote_provider.dart';   // ← 加

void main() {
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
        home: HomePage(),
      ),
    );
  }
}