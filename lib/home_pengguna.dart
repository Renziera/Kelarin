import 'package:flutter/material.dart';

class HomePengguna extends StatefulWidget {
  @override
  _HomePenggunaState createState() => _HomePenggunaState();
}

class _HomePenggunaState extends State<HomePengguna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KELARIN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
