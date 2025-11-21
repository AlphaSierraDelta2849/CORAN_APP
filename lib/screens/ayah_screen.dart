import 'package:coran_app/models/surah.dart';
import 'package:coran_app/services/quran_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation.dart';

class AyahScreen extends StatefulWidget {
  final int surahNumber;
  AyahScreen({required this.surahNumber});

  @override
  _AyahScreenState createState() => _AyahScreenState();
}

class _AyahScreenState extends State<AyahScreen> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    final q = Provider.of<QuranService>(context, listen: false);
    _future = q.getSurah(widget.surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sourate')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          Surah surah = snapshot.data;
          return Column(
            children: [
              ListTile(
                title: Text('${surah.number}. ${surah.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: Text(surah.englishName ),
                trailing: IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PresentationScreen(ayahs: surah.ayahs, initialAyah: 0))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: surah.ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = surah.ayahs[index];
                    return ListTile(
                      title: Text(ayah.text, textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Scheherazade', fontSize: 22)),
                      subtitle: Text("translation"),
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Container(
                            child: Wrap(
                              children: [
                                ListTile(leading: Icon(Icons.bookmark), title: Text('Signet'), onTap: () {}),
                                ListTile(leading: Icon(Icons.share), title: Text('Partager'), onTap: () {}),
                                ListTile(leading: Icon(Icons.fullscreen), title: Text('Projeter'), onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PresentationScreen(ayahs: surah.ayahs, initialAyah: index)));
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}