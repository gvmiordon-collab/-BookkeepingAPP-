import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookkeeppingDatabase {
  BookkeeppingDatabase._internal();
  static final BookkeeppingDatabase instance = BookkeeppingDatabase._internal();

  Database? _db;

  Future<Database> get _database async{
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bookkeeping.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db)
    );
  }

}