import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:kelarin/home_pengguna.dart';
import 'package:kelarin/home_percetakan.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: RaisedButton(
          child: Text('MASUK DENGAN GOOGLE'),
          onPressed: () async {
            Auth mAuth = auth();
            await mAuth.setPersistence('local');
            try {
              UserCredential credential =
                  await mAuth.signInWithPopup(GoogleAuthProvider());
              DocumentSnapshot ds = await firestore()
                  .collection('users')
                  .doc(credential.user.uid)
                  .get();
              if (!ds.exists) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Daftar()));
                return;
              }
              if (ds.data()['percetakan']) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePercetakan()));
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePengguna()));
              }
            } catch (e) {}
          },
        ),
      ),
    );
  }
}

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'DAFTAR KELARIN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Pengguna')),
              Tab(child: Text('Percetakan')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DaftarPengguna(),
            DaftarPercetakan(),
          ],
        ),
      ),
    );
  }
}

class DaftarPercetakan extends StatelessWidget {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _hargaWarnaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _namaController,
            decoration: InputDecoration(hintText: 'Nama Percetakan'),
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: _nomorController,
            decoration: InputDecoration(hintText: 'Nomor Telepon'),
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: _alamatController,
            decoration: InputDecoration(hintText: 'Alamat Percetakan'),
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: _hargaController,
            decoration: InputDecoration(hintText: 'Harga cetak hitam putih'),
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: _hargaWarnaController,
            decoration: InputDecoration(hintText: 'Harga cetak warna'),
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            child: Text('DAFTAR SEBAGAI PERCETAKAN'),
            onPressed: () async {
              await firestore()
                  .collection('users')
                  .doc(auth().currentUser.uid)
                  .set({
                'nama': _namaController.text,
                'nomor': _nomorController.text,
                'alamat': _alamatController.text,
                'harga': _hargaController.text,
                'harga_warna': _hargaWarnaController.text,
                'percetakan': true,
                'waktu_daftar': FieldValue.serverTimestamp(),
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePercetakan()));
            },
          ),
        ],
      ),
    );
  }
}

class DaftarPengguna extends StatelessWidget {
  final TextEditingController _namaController =
      TextEditingController(text: auth().currentUser.displayName);
  final TextEditingController _nomorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _namaController,
            decoration: InputDecoration(hintText: 'Nama Lengkap'),
            textAlign: TextAlign.center,
          ),
          TextField(
            controller: _nomorController,
            decoration: InputDecoration(hintText: 'Nomor Telepon'),
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            child: Text('DAFTAR SEBAGAI PENGGUNA'),
            onPressed: () async {
              await firestore()
                  .collection('users')
                  .doc(auth().currentUser.uid)
                  .set({
                'nama': _namaController.text,
                'nomor': _nomorController.text,
                'percetakan': false,
                'waktu_daftar': FieldValue.serverTimestamp(),
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePengguna()));
            },
          ),
        ],
      ),
    );
  }
}
