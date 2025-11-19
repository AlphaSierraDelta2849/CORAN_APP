import 'ayah.dart';

class Surah {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;
  final List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory Surah.fromMap(Map<String, dynamic> m, List<Ayah> ayahs) {
    return Surah(
      number: m['number'],
      name: m['name'],
      englishName: m['englishName'] ?? '',
      numberOfAyahs: m['numberOfAyahs'] ?? 0,
      ayahs: ayahs,
    );
  }

  Map<String, dynamic> toMap() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'numberOfAyahs': numberOfAyahs,
      };
}