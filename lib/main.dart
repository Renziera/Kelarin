import 'package:flutter/material.dart';
import 'package:kelarin/splash.dart';

void main() => runApp(Kelarin());

class Kelarin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelarin',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Splash(),
    );
  }
}