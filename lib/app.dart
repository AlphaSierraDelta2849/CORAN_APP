import 'package:flutter/material.dart';

import 'screens/hom_screen.dart';
import 'utils/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}