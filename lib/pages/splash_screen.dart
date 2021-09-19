import 'package:excalibur/pages/root_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:excalibur/services/storage.dart' as storage;
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //_loadSavedToken();
    startTimer();
  }

/*
  _loadSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storage.address = prefs.getString('address');
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.deepPurple,
            Colors.purple[900]!,
            Colors.black
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Hero(
                tag: "gitopia-logo",
                child: Image(
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('assets/logo-white.png'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CupertinoActivityIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(
      const Duration(seconds: 3),
      () {
        navigateUser(); //It will redirect  after 3 seconds
      },
    );
  }

  void navigateUser() async {
    var status = storage.address;
    if (status != null) {
      /*
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
            token: storage.address,
          ),
        ),
      );
      */
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const RootPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const RootPage(),
        ),
      );
    }
  }
}
