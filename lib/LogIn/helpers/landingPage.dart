import 'dart:math';

import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/LogIn/SignIn/SignInPage.dart';
import 'package:Buddies/LogIn/SignUp/walkthrough.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// import './preferences.dart';

// import './Model/token.dart';
// import 'package:flutter/rendering.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Random random = Random();
  int index = 0;
  bool firstStateEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoggedIn = false;

  Widget _interactionButtions(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/buddies.png'),
                    height: screenAwareSize(250, context),
                    width: screenAwareSize(300, context),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 180.0),
                    child: Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                    highlightColor: Colors.greenAccent,
                                    splashColor: Colors.greenAccent,
                                    elevation: 10.0,
                                    color: Colors.white,
                                    child: Container(
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: buddiesPurple),
                                        ),
                                      ),
                                    ), //`Text` to display
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Walkthrough()));
                                    }),
                                SizedBox(
                                  width: 15,
                                ),
                                RaisedButton(
                                  splashColor: Colors.greenAccent,
                                  elevation: 8.0,

                                  color: buddiesGreen,
                                  child: Container(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                  ), //`Text` to display
                                  shape: StadiumBorder(),
                                  // borderSide: BorderSide(color: Colors.white),
                                  onPressed: () {
                                    // _showModalSheet();

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SignIn()));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 28.0),
                              child: Text(
                                'By Continuing, You Are Agreeing To Our Terms Of Service & Privacy Policy',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Roboto-Regular'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: buddiesGreen,
      // systemNavigationBarColor: buddiesPurple
      // systemNavigationBarIconBrightness: Brightness.light
    ));

    return _interactionButtions(context);
  }
}
