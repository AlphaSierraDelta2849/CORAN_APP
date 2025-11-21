import 'package:flutter/material.dart';

class VerseTile extends StatelessWidget {
  final String text;
  final String translation;
  final VoidCallback? onTap;

  VerseTile({required this.text, required this.translation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text, textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Scheherazade', fontSize: 20)),
      subtitle: Text(translation),
      onTap: onTap,
    );
  }
}