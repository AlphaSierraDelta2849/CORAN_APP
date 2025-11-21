import 'package:coran_app/models/ayah.dart';
import 'package:flutter/material.dart';

class PresentationScreen extends StatefulWidget {
  final List<Ayah> ayahs;
  final int? initialAyah;
  PresentationScreen({required this.ayahs, this.initialAyah});

  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = PageController();
    final int initial = widget.initialAyah != null
        ? widget.initialAyah!.clamp(0, widget.ayahs.length - 1).toInt()
        : 0;
    _controller = PageController(initialPage: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.ayahs.length,
          itemBuilder: (context, index) {
            // if (widget.initialAyah != 0 && widget.initialAyah != null) {
            //   index += widget.initialAyah!;
            // }
            final a = widget.ayahs[index];
            return GestureDetector(
              onHorizontalDragEnd: (details) {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            a.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 48, fontFamily: 'Scheherazade',color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("a.translation", style: TextStyle(color: Colors.white70, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}