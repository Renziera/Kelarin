import 'dart:html';

import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore()
            .collection('orders')
            .where('percetakan', '==', auth().currentUser.uid)
            .orderBy('waktu', 'desc')
            .onSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data.docs.map((doc) {
              return ListTile(
                isThreeLine: true,
                title: Text(doc.get('nama_file')),
                subtitle: Text(
                    '${doc.get('nama_pengguna')} ${doc.get('nomor_pengguna')}\nKeterangan: ${doc.get('keterangan')}'),
                trailing: RaisedButton(
                  child: Text('FILE'),
                  onPressed: () {
                    window.open(doc.get('file'), 'tab');
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
