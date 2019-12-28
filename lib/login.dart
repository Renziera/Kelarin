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
          title: Text('DAFTAR KELARIN'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Pengguna')),
              Tab(child: Text('Percetakan')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(),
            Column(),
          ],
        ),
      ),
    );
  }
}
