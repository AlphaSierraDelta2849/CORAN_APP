import 'package:coran_app/services/quran_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'surah_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quranService = Provider.of<QuranService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Quran')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un mot ou une phrase...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSubmitted: (value) async {
                  final res = await quranService.searchAyahs(value);
                  // Simple navigation vers liste de résultats - à améliorer
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Résultats (${res.length})'),
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: res.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(res[index].text),
                            subtitle: Text('S${res[index].surahNumber}:A${res[index].numberInSurah}'),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.menu_book),
                  label: Text('Parcourir les sourates'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurahListScreen())),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}