import 'package:catcher/catcher.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/LogIn/SplashPage_screen.dart';
import 'package:Buddies/LogIn/helpers/landingPage.dart';
import 'package:Buddies/BottomBar/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'APIS/Apis.dart';
import 'Checkout/CartProvider.dart';
import 'DispensaryPages/SearchPage.dart';
import 'DispensaryPages/SelectedProductPage/SelectedProduct.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => LoginPage(),
  // "/intro": (BuildContext context) => Home(),
};

Future<void> main() async {
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["devs@hscottindustries.com"])
  ]);

  Catcher(SplashScreen(),
      debugConfig: debugOptions, releaseConfig: releaseOptions);

  // debugPaintSizeEnabled = true;

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(CartProvider(
      child: MaterialApp(
        theme: ThemeData(accentColor: Colors.greenAccent),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          //app routes
          '/landingscreen': (BuildContext context) => new LoginPage(),
          '/bottomBar': (BuildContext context) => new BottomBarController(),
          // '/trackingScreen': (BuildContext context) => new OrderHistory(),
          '/SelectedPage': (BuildContext context) => SelectedProduct(),
          // '/PreferencePage': (BuildContext context) => Preferences(),
          // '/DriverReviewPage': (BuildContext context) => DriverReviewPage(),
          '/SearchPage': (BuildContext context) => SearchPage(),
        },
      ),
    ));
  });
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin<SplashScreen> {
  Future<bool> _checkToken;

  @override
  void initState() {
    _checkToken = _vaildToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkToken,
      builder: (context, snapshot) {
        print(snapshot.data);

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final hasConnection = snapshot.data;

            return hasConnection ? BottomBarController() : SplashPageScreen();

          default: // Return a loading indicator while checking connection
            return Container();
        }
      },
    );
  }

  Future<bool> _vaildToken() async {
    // Async operation here
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool boolValue = prefs.containsKey('token');

    if (boolValue == null) {
      return prefs.setBool('validToken', false);
    } else {
      // refreshToken();
      return boolValue;
    }
  }

  void refreshToken() {
    if (tokenType == 'social') {
    } else if (tokenType == 'email') {
      getEmailRefreshToken();
    }
  }
}
