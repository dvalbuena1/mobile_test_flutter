import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  static Database? _db;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mobile_test_flutter.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE Post (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        body TEXT,
        favorite INTEGER
      )
    ''');
    batch.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        name TEXT,
        username TEXT,
        email TEXT,
        phone TEXT,
        website TEXT,
        company TEXT,
        address TEXT
      )
    ''');
    batch.execute('''
      CREATE TABLE Comment (
        id INTEGER PRIMARY KEY,
        postId INTEGER,
        name TEXT,
        email TEXT,
        body TEXT
      )
    ''');

    await batch.commit();
  }
}
