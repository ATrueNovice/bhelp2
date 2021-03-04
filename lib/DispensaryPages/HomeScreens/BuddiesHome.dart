import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Constants/InheritedWidgets.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/HomeScreens/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BuddiesHome extends StatefulWidget {
  @override
  State createState() => _BuddiesHome();
}

class _BuddiesHome extends State<BuddiesHome> {
  //Set Future
  Future _setDispensaries;

  Geolocator geolocator = Geolocator();

  @override
  void initState() {
    BuddiesInherited().initialProductSetup(3);

    _setDispensaries = getDispensaries();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: FutureBuilder(
                future: _setDispensaries,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    currentDispensaries = snapshot.data;
                  }
                  return HomePage();
                })));
  }
}
