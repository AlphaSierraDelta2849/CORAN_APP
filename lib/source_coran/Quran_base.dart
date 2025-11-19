import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuranDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'Quran_base.db');

    // Si la base n’existe pas encore, on la copie depuis les assets
    if (!await File(dbPath).exists()) {
      ByteData data = await rootBundle.load('assets/database/Quran_base.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPath).writeAsBytes(bytes);
    }

    return await openDatabase(dbPath, readOnly: true);
  }
}
