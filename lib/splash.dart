import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:kelarin/home_pengguna.dart';
import 'package:kelarin/home_percetakan.dart';
import 'package:kelarin/login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(Duration(seconds: 1));
    Auth mAuth = auth();
    if (mAuth.currentUser == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    DocumentSnapshot ds =
        await firestore().collection('users').doc(mAuth.currentUser.uid).get();
    if (!ds.exists) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Daftar()));
      return;
    }
    if (ds.data()['percetakan']) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePercetakan()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePengguna()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Text(
          'Kelarin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
        ),
      ),
    );
  }
}
