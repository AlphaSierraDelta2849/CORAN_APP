class Ayah {
  final int number; // global number in the Mushaf
  final int surahNumber;
  final int numberInSurah;
  final String text;
  final String translation;

  Ayah({
    required this.number,
    required this.surahNumber,
    required this.numberInSurah,
    required this.text,
    required this.translation,
  });

  factory Ayah.fromMap(Map<String, dynamic> m) {
    return Ayah(
      number: m['number'],
      surahNumber: m['surahNumber'],
      numberInSurah: m['numberInSurah'],
      text: m['text'],
      translation: m['translation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'number': number,
        'surahNumber': surahNumber,
        'numberInSurah': numberInSurah,
        'text': text,
        'translation': translation,
      };
}