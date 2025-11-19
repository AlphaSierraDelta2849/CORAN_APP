import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('quran.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surah (
        number INTEGER PRIMARY KEY,
        name TEXT,
        englishName TEXT,
        numberOfAyahs INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE ayah (
        number INTEGER PRIMARY KEY,
        surahNumber INTEGER,
        numberInSurah INTEGER,
        text TEXT,
        translation TEXT,
        FOREIGN KEY(surahNumber) REFERENCES surah(number)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_ayah_surah ON ayah(surahNumber);
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}