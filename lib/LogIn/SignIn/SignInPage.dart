import 'dart:async';
import 'dart:convert';
import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/BottomBar/bottombar.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/LogIn/SignUp/SignUpPage.dart';
import 'package:Buddies/Model/token.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Buddies/widgets/helpers/ensure_visible.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  Future _emailLoginFunc;
  Future _googleSignIn;

  @override
  void initState() {
    super.initState();
  }

//form key
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  final _pwdFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  //Google Variables

  var userDetails;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  String cityName;
  String cityZip;
  String textA;
  String textB;
  String locationStatus;
  Geolocator geolocator = Geolocator();
  int textValue;

  final Map<String, dynamic> _signInForm = {
    'username': null,
    'password': null,
  };

  Token emailToken;

  bool isLoggedIn = false;

  String _token = '';

//Facebook login
  Future initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();

    var facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled ByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        final token = facebookLoginResult.accessToken.token;
        _token = token;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=id,name,email,picture.type(normal)&access_token=$token');
        print(graphResponse);
        var responseData = json.decode(graphResponse.body);

        // User user = User.fromJSON(responseData);

        // setState(() {
        //   userProfile = user;
        // });
        facebookUserLogin(token);

        print(token);
        onLoginStatusChanged(true);

        break;
    }
  }

  //Email Login

  Future _emailLogin(userdetails) async {
    _emailLoginFunc = userLogin(userdetails);
    _emailLoginFunc.then((value) {
      print(value);

      if (value == 'good') {
        onLoginStatusChanged(true);
      } else {
        popupSwitch(2);

        print('Couldnt login');
      }
    });
  }

  //Google Login

  Future _signInWithGoogle() async {
    _googleSignIn = signInWithGoogle();
 
     _googleSignIn.then((value) {
      print(value);
      if (value == 'success') {
        onLoginStatusChanged(true);
      } else {
        popupSwitch(2);

        print('Couldnt login');
      }

      onLoginStatusChanged(googleSignInSuccess);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  Future<Position> checkPermission() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }

    print('The position is: $currentLocation');

    if (currentLocation != null) {
      setState(() {
        userLat = currentLocation.latitude;
        userLong = currentLocation.longitude;
        position = currentLocation;

        print(
            'The locations are: User: $userLat, $userLong, and overall $position');
        // Set location variables later
      });

      return currentLocation;
    } else {
      print('Could not retrieve location');
    }

    return currentLocation;
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      if (isLoggedIn == true) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                ),
              );
            });
        Future.delayed(
            Duration(
              seconds: 1,
            ), () {
          Navigator.pop(context);
          preformLogin();
        });
      } else {
        print('Still Logged Out');
      }
    });
  }

  void popupSwitch(int value) {
    setState(() {
      textValue = value;

      switch (value) {
        case 0:
          textA = 'No Internet Connection Detected';
          textB = 'Need The Internet To Meet Our Buds';
          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'We Need Your Location';
          textB = 'See Buds Near You';
          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Have We Met?';
          textB = 'Bad User Name Or Password.';
          _showPopup(textA, textB);
      }
    });
  }

  Future _submit() async {
    final form = _signInFormKey.currentState;

    if (form.validate()) {
      form.save();
      _emailLogin(_signInForm);
    } else {
      print('Cant save form');
      print(_signInForm.values);
    }
  }

  preformLogin() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          );
        });
    Future.delayed(
        Duration(
          milliseconds: 200,
        ), () {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomBarController()));
    });
  }

  void clearText() {
    setState(() {
      _usernameController.clear();
      _pwdController.clear();
    });
  }

  void _showPopup(textA, textB) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: new Text(
            textA,
            style: TextStyle(fontFamily: 'Poppins', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            textB,
            style: TextStyle(fontFamily: 'Roboto-Regular', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  Future emailButtonPressed(_signInForm) async {
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginKey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
              child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _signInFormKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpPage()));
                          },
                          child: Text('Sign Up',
                              style: TextStyle(
                                  fontFamily: 'Roboto', color: buddiesPurple)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: Image.asset(
                      'assets/buddies.png',
                      width: screenAwareSize(400, context),
                      height: screenAwareSize(100, context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Welcome back bud',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: buddiesPurple),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            "Username",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: buddiesPurple.withOpacity(.8),
                                fontSize: 10.0,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: _usernameField()),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            "PASSWORD",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: buddiesPurple.withOpacity(.8),
                                fontSize: 10.0,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: _buildPasswordTextField()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin:
                        const EdgeInsets.only(left: 70.0, right: 70.0, top: 5.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.teal,
                            onPressed: () {
                              emailButtonPressed(_signInForm);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "LOGIN",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
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
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
                    alignment: Alignment.center,
                    child: Text(
                      "OR CONNECT WITH",
                      style: TextStyle(
                          color: buddiesPurple,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontSize: 12),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8.0),
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          iconSize: 60,
                                          icon: Image.asset('assets/fbIcon.png'),
                                          onPressed: () {
                                            initiateFacebookLogin();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8.0),
                            alignment: Alignment.center,
                            child: Container(
                              child: IconButton(
                                iconSize: 60,
                                icon: Image.asset('assets/googleIcon.png'),
                                onPressed: () {
                                  _signInWithGoogle();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 20),
                    child: FlatButton(
                      child: Text(
                        "Forgot Your Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 14.0,
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: (){
                        _launchURL();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {

  if (await canLaunch(resetPwdUrl)) {
    await launch(resetPwdUrl);
  } else {
    throw 'Could not launch $resetPwdUrl';
  }
}

  Widget _usernameField() {
    return Container(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: _usernameFocusNode,
        child: TextFormField(
          focusNode: _usernameFocusNode,
          controller: _usernameController,
          keyboardType: TextInputType.text,
          maxLength: 20,
          maxLengthEnforced: true,
          obscureText: false,
          decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.cannabis,
                color: buddiesYellow,
              ),
              hintText: "UserName",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Bad Username';
            }
          },
          onChanged: (String value) {
            _signInForm['username'] = value.replaceAll("", "");
          },
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: _pwdFocusNode,
        child: TextFormField(
          focusNode: _pwdFocusNode,
          controller: _pwdController,
          keyboardType: TextInputType.text,
          maxLength: 16,
          maxLengthEnforced: true,
          obscureText: true,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.userLock, color: buddiesYellow),
              hintText: "Enter Password",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}')
                .hasMatch(value)) {
              return 'Please Enter Vaild Password';
            }
          },
          onChanged: (String value) {
            _signInForm['password'] = value.replaceAll("", "");
          },
        ),
      ),
    );
  }
}
