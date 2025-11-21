import 'dart:io';
import 'package:flutter/services.dart';
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
    _db = await _initDB('Quran_base.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // final path = join(documentsDirectory.path, fileName);

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'Quran_base.db');

    // Si la base n’existe pas encore, on la copie depuis les assets
    if (!await File(dbPath).exists()) {
      ByteData data = await rootBundle.load('assets/source_coran/Quran_base.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPath).writeAsBytes(bytes);
    }

    return await openDatabase(dbPath, readOnly: true);
    // return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}