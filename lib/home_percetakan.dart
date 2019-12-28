import 'package:flutter/material.dart';

class HomePercetakan extends StatefulWidget {
  @override
  _HomePercetakanState createState() => _HomePercetakanState();
}

class _HomePercetakanState extends State<HomePercetakan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Percetakan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
