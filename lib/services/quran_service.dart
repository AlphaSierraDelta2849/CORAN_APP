import 'dart:convert';
import 'dart:io';

import 'package:coran_app/models/ayah.dart';
import 'package:coran_app/models/surah.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class QuranService {
  final DBHelper _dbHelper = DBHelper();

  Future<void> init() async {
    final db = await _dbHelper.database;
    // Vérifiez si la base de données existe
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = '${directory.path}/Quran_base.db';
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      // La base de données existe, vous pouvez l'utiliser directement
      print('Database exists, using existing database.');
      return; // Ne pas charger à partir de JSON
    }

    // Vérifie si la table surah est vide
    final countRes = await db.rawQuery('SELECT COUNT(*) as c FROM surahs');
    final count = Sqflite.firstIntValue(countRes) ?? 0;

    if (count == 0) {
      // Charger depuis assets/quran_sample.json (ou full JSON si fourni)
      final jsonString = await rootBundle.loadString('assets/source_coran/Quran_sample.json');
      final data = json.decode(jsonString);

      final surahs = data['surahs'] as List<dynamic>;

      final batch = db.batch();
      for (final s in surahs) {
        batch.insert('surah', {
          'number': s['number'],
          'name': s['name'],
          'englishName': s['englishName'] ?? '',
          'numberOfAyahs': s['numberOfAyahs'] ?? (s['ayahs'] as List).length,
        });

        for (final a in s['ayahs']) {
          batch.insert('ayah', {
            'number': a['number'],
            'surahNumber': s['number'],
            'numberInSurah': a['numberInSurah'],
            'text': a['text'],
            'translation': a['translation'] ?? '',
          });
        }
      }
      await batch.commit(noResult: true);
    }
  }

  Future<List<Surah>> getSurahs() async {
    final db = await _dbHelper.database;
    final res = await db.query('surahs', orderBy: 'sura_id');
    print('Fetched ${res.length} surahs from database.');
    final List<Surah> out = [];
    for (final row in res) {
      final ayahRows = await db.query('ayahs', where: 'sura_id = ?', whereArgs: [row['sura_id']]);
      final ayahs = ayahRows.map((m) => Ayah.fromMap(m)).toList();
      out.add(Surah.fromMap(row, ayahs));      
    }
    return out;
  }

  Future<Surah> getSurah(int number) async {
    final db = await _dbHelper.database;
    final rows = await db.query('surahs', where: 'sura_id = ?', whereArgs: [number]);
    if (rows.isEmpty) throw Exception('Surah not found');
    final ayahRows = await db.query('ayahs', where: 'sura_id = ?', whereArgs: [number], orderBy: 'ayah_number');
    final ayahs = ayahRows.map((m) => Ayah.fromMap(m)).toList();
    return Surah.fromMap(rows.first, ayahs);
  }

  Future<List<Ayah>> searchAyahs(String q) async {
    final db = await _dbHelper.database;
    final rows = await db.query('ayah', where: 'text LIKE ? OR translation LIKE ?', whereArgs: ['%$q%', '%$q%']);
    return rows.map((r) => Ayah.fromMap(r)).toList();
  }
}