import 'dart:async';

import 'package:Buddies/Constants/Static_string.dart';
import 'package:flutter/material.dart';

class SplashPageScreen extends StatefulWidget {
  @override
  SplashPageScreenState createState() => SplashPageScreenState();
}

class SplashPageScreenState extends State<SplashPageScreen> {

  @override
  void initState() {
    // _controller = VideoPlayerController.asset('assets/BuddiesLogo.mp4')
    //   ..initialize()
    //   ..play();
    _nextPage();

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: screenAwareSize(200, context),
          width: screenAwareSize(350, context),
          child: Image.asset('assets/buddies.png', fit: BoxFit.fill,),
        ),
      ),
    );
  }

  void _nextPage() {
    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      Navigator.pushReplacementNamed(context, '/landingscreen');
    });
  }
}
