import 'dart:html';

import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class HomePengguna extends StatefulWidget {
  @override
  _HomePenggunaState createState() => _HomePenggunaState();
}

class _HomePenggunaState extends State<HomePengguna> {
  Widget _widget = DaftarPercetakan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KELARIN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'KELARIN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              decoration: BoxDecoration(color: Colors.deepOrange),
            ),
            ListTile(
              title: Text(
                'Daftar Percetakan',
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                setState(() {
                  _widget = DaftarPercetakan();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                'Pesanan',
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                setState(() {
                  _widget = Pesanan();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _widget,
    );
  }
}

class DaftarPercetakan extends StatefulWidget {
  @override
  _DaftarPercetakanState createState() => _DaftarPercetakanState();
}

class _DaftarPercetakanState extends State<DaftarPercetakan> {
  void _order(percetakan_id, nama, nomor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDialog(
          percetakan_id: percetakan_id,
          percetakan_nama: nama,
          percetakan_nomor: nomor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore()
          .collection('users')
          .where('percetakan', '==', true)
          .onSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text(snapshot.error.toString());
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data.docs.map((doc) {
            return ListTile(
              isThreeLine: true,
              title: Text(doc.get('nama')),
              subtitle: Text(
                  '${doc.get('alamat')} Telp:${doc.get('nomor')}\nHitam putih Rp${doc.get('harga')} Warna Rp${doc.get('harga_warna')}'),
              trailing: RaisedButton(
                child: Text('ORDER'),
                onPressed: () {
                  _order(doc.id, doc.get('nama'), doc.get('nomor'));
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class OrderDialog extends StatefulWidget {
  final String percetakan_id;
  final String percetakan_nama;
  final String percetakan_nomor;
  const OrderDialog(
      {Key key,
      @required this.percetakan_id,
      @required this.percetakan_nama,
      @required this.percetakan_nomor})
      : super(key: key);
  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final TextEditingController _controller = TextEditingController();
  File _file;
  bool _loading = false;

  void _startFilePicker() {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files.length != 1) return;
      setState(() {
        _file = files[0];
      });
    });
  }

  void _submitOrder() async {
    if (_file == null) return;
    setState(() {
      _loading = true;
    });
    UploadTask uploadTask = storage()
        .ref(DateTime.now().millisecondsSinceEpoch.toString() + _file.name)
        .put(_file, UploadMetadata(contentType: _file.type));
    UploadTaskSnapshot snapshot = await uploadTask.future;
    Uri uri = await snapshot.ref.getDownloadURL();
    DocumentSnapshot penggunaDoc =
        await firestore().collection('users').doc(auth().currentUser.uid).get();
    await firestore().collection('orders').add({
      'pengguna': auth().currentUser.uid,
      'nama_pengguna': penggunaDoc.get('nama'),
      'nomor_pengguna': penggunaDoc.get('nomor'),
      'percetakan': widget.percetakan_id,
      'nama_percetakan': widget.percetakan_nama,
      'nomor_percetakan': widget.percetakan_nomor,
      'file': uri.toString(),
      'nama_file': _file.name,
      'keterangan': _controller.text,
      'waktu': FieldValue.serverTimestamp(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ORDER CETAK'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            child: Text('PILIH FILE'),
            onPressed: _startFilePicker,
          ),
          Text(_file?.name ?? ''),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: 'Keterangan, misal: dijilid, diambil sore, dll'),
          ),
          RaisedButton(
            child: _loading ? CircularProgressIndicator() : Text('ORDER'),
            onPressed: _loading ? null : _submitOrder,
          ),
        ],
      ),
    );
  }
}

class Pesanan extends StatefulWidget {
  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore()
          .collection('orders')
          .where('pengguna', '==', auth().currentUser.uid)
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
                  '${doc.get('nama_percetakan')} Telp: ${doc.get('nomor_percetakan')}\nKeterangan: ${doc.get('keterangan')}'),
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
    );
  }
}
