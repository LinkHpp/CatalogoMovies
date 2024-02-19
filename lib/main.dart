import 'package:flutter/material.dart';
import 'package:prac_hpp/config/theme.dart';
import 'package:prac_hpp/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prac_HPP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(colorSeleccionado: 2).generaTema(),
      home: HomePage(),
    );
  }
}
