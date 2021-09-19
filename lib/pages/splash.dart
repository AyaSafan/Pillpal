import 'dart:async';

//import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}
//with AfterLayoutMixin<Splash>
class SplashState extends State<Splash>  {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushNamed('/home');
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushNamed('/landing1');

    }
  }

  // @override
  // void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/ic_launcher.png'),
      ),
    );
  }
}

