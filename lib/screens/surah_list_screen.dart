import 'package:coran_app/models/surah.dart';
import 'package:coran_app/services/quran_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ayah_screen.dart';

class SurahListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quranService = Provider.of<QuranService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Sourates')),
      body: FutureBuilder(
        future: quranService.getSurahs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          List<Surah> surahs = snapshot.data!;
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final s = surahs[index];
              return ListTile(
                title: Text('${s.number}. ${s.name}'),
                subtitle: Text(s.englishName),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AyahScreen(surahNumber: s.number))),
              );
            },
          );
        },
      ),
    );
  }
}