import 'dart:convert';
import 'package:Buddies/LogIn/SignIn/SignInPage.dart';
import 'package:http/http.dart' as http;
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/widgets/helpers/ensure_visible.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
//Text Controllers
  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _renterPasswordController.dispose();

    super.dispose();
  }

  //passwords match
  bool passwordsMatch = false;
  String tmpPwd;
  String tmpPwd2;

  //Sign Up
  bool _allowSubcription = false;
  bool _allowEmails = true;
  bool _agreeTOS = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _renterPasswordController = TextEditingController();

  //  final _descriptionFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _usernameFOcusNode = FocusNode();
  final _renterPasswordFocusNode = FocusNode();

  //FormData
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _signupForm = {
    'username': null,
    'first_name': null,
    'last_name': null,
    'password': null,
    'email': null,
  };

  String emailValidator =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  String firstNameValidator =
      r'^(?=[a-zA-Z\s]{2,25}$)(?=[a-zA-Z\s])(?:([\w\s*?])\1?(?!\1))+$';
  String passwordValidator =
      r'^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,16}$';

  String usernameValidator = r'([\d\D][^!£$%&@/()=?ì^#{}[\]]*)';

  String lastNameValidator =
      r'^(?=[a-zA-Z\s]{2,25}$)(?=[a-zA-Z\s])(?:([\w\s*?])\1?(?!\1))+$';

  String textA;
  String textB;
  var segue;

  void _submit() async {
    _checkPasswords();
    final form = _formKey.currentState;

    if (form.validate() && _agreeTOS == true) {
      form.save();
      upload(_signupForm);
      print(_signupForm.values);
    } else {
      print('Cant save form');
      print(_signupForm.values);
    }
  }

  void upload(_signupForm) {
    setState(() {
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
            seconds: 5,
          ), () async {
        print('submiting');

        customerSignUp(_signupForm).whenComplete(() {
          Navigator.pop(context);
        });
      });
    });
  }

  void createUserCheck(signUpComplete) {
    switch (signUpComplete) {
      case true:
        print('User Was Created Successfully Moving To Next Page');
        popupSwitch(0);

        setState(() {
          signUpComplete = false;
        });

        break;
      default:

        // print('Could Not Register because the reult is $result');
        print('Did the user Sign Up Successfully $signUpComplete');
        break;
    }
  }

  Future<dynamic> customerSignUp(customerDetails) async {
    var url = 'http://buddies-8269.herokuapp.com/api/customer_signup/';

    await http.post(url, body: json.encode(customerDetails), headers: {
      "Content-Type": "application/json"
    }).then((http.Response response) async {
      var responseData = json.decode(response.body);
      print(responseData);

      print('Direct response $responseData');

      if (responseData == 'success') {
        setState(() {
          signUpComplete = true;
          print('signUpCompleted $signUpComplete');
        });
        createUserCheck(signUpComplete);
      } else {
        popupSwitch(1);
        signUpComplete = false;

        print('Not completed');
      }
      createUserCheck(signUpComplete);

      return responseData;
    });
  }

  void popupSwitch(int value) {
    setState(() {
      switch (value) {
        case 0:
          textA = 'Whoo Whoot!\n Wecome to buddies';
          textB =
              'You Are Offically One Of The Cool Kids\n\nCheck Your Email For Your\n Activation Link';

          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'Have We Met?';
          textB =
              'User Name Or Email Already Registered.\n\n Try A New Username \n\nOr\n\n Click The Reset Link To Recover Account';

          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Only Text Here';
          textB = 'Please only letters\n (no letters or special characters)';

          _showPopup(textA, textB);
          break;
        case 3:
          textA = 'Username ';
          textB = 'User Name Cannot Contain:\n Spaces\nDashes\nOr The @ Symbol';

          _showPopup(textA, textB);
          break;
        case 4:
          textA = 'Double Check Your Email';
          textB =
              'Your email cannot start or finish with a dot\nContain spaces\nContain special chars (<:, *,etc)';

          _showPopup(textA, textB);
          break;
        case 5:
          textA = 'That Password Isnt It Bud';
          textB =
              '\n\nPassword must contain: 1 number (0-9)\n\nPassword must contain 1 uppercase letters\n\nPassword must contain 1 lowercase letters\n\nPassword must contain 1 non-alpha numeric number\n\nPassword is 8-16 characters with no space';

          _showPopup(textA, textB);
          break;
        case 6:
          textA = 'Whoaaa Something Happened';
          textB = '\n\n Could Not Upload';

          _showPopup(textA, textB);
          break;
      }
    });
  }

  void _showPopup(textA, textB) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            textA,
            style: TextStyle(fontFamily: 'Poppins', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          content: Text(
            textB,
            style:
                TextStyle(fontFamily: 'Roboto-Regular', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            signUpComplete
                ? FlatButton(
                    child: Text("Sign In"),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => SignIn()));
                    })
                : FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                child: Form(
              key: _formKey,
              // autovalidate: true,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => SignIn()));
                        },
                        child: Text('Sign in',
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.teal)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
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
                    'Welcome Bud! ',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: screenAwareSize(25, context),
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
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "About Me",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.withOpacity(.8),
                              fontSize: 18.0,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 150,
                          child: _textInputField(
                              _firstNameFocusNode,
                              _firstnameController,
                              TextInputType.text,
                              'first name',
                              'Invaild text',
                              firstNameValidator,
                              'first_name',
                              20,
                              null),
                        ),
                        Container(
                          width: 150,
                          child: _textInputField(
                              _lastNameFocusNode,
                              _lastnameController,
                              TextInputType.text,
                              'last name',
                              'Invaild Text',
                              lastNameValidator,
                              'last_name',
                              20,
                              null),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            width: 150,
                            child: _textInputField(
                                _usernameFOcusNode,
                                _usernameController,
                                TextInputType.text,
                                'user name',
                                'Invalid username',
                                usernameValidator,
                                'username',
                                20,
                                null)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                  width: 150,
                                  child: _textInputField(
                                      _emailFocusNode,
                                      _emailController,
                                      TextInputType.text,
                                      'email',
                                      'Please Enter Valid Email',
                                      emailValidator,
                                      'email',
                                      40,
                                      null)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenAwareSize(20, context),
                    ),
                    //Password Fields
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildPasswordTextField(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                              width: 150,
                              child: _buildPasswordVerification(
                                  _renterPasswordFocusNode,
                                  _renterPasswordController,
                                  TextInputType.text,
                                  're-enter pwd',
                                  'Passwords Do Not Match',
                                  emailValidator,
                                  're-enter password',
                                  40,
                                  're-enter password')),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _subscriptionWidget(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      margin: const EdgeInsets.only(
                          left: 70.0, right: 70.0, top: 5.0),
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
                                _submit();
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
                    SizedBox(
                      height: 40,
                    ),
                  ]),
                ),
              ]),
            ))),
      ),
    );
  }

  Widget _textInputField(focusNode, controller, keyboardType, hint, empty,
      formVaildator, formField, maxLength, helperText) {
    return EnsureVisibleWhenFocused(
      focusNode: focusNode,
      child: TextFormField(
        maxLength: maxLength,
        maxLengthEnforced: true,
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
            helperText: helperText,
            hintText: hint,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            fillColor: Colors.transparent,
            filled: true),
        validator: (String value) {
          if (value.isEmpty) {
            return empty;
          } else if (!RegExp(formVaildator).hasMatch(value)) {}
        },
        onChanged: (String value) {
          _signupForm[formField] = value.replaceAll(' ', '');
        },
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
          maxLength: 25,
          maxLengthEnforced: true,
          obscureText: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              hintText: "password",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else if (!RegExp(
                    r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$$')
                .hasMatch(value)) {
              return 'Invalid Password';
            }
          },
          onChanged: (String value) {
            tmpPwd = value.replaceAll(' ', '');
          },
        ),
      ),
    );
  }

  Widget _buildPasswordVerification(focusNode, controller, keyboardType, hint,
      empty, formVaildator, formField, maxLength, helperText) {
    return Container(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          maxLength: maxLength,
          maxLengthEnforced: true,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              helperText: null,
              hintText: hint,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else {
              if (tmpPwd != value) {
                return 'Passwords Do not Match';
              }
            }
          },
          onChanged: (String value) {
            tmpPwd2 = value.replaceAll(' ', '');
          },
        ),
      ),
    );
  }

  Widget _subscriptionWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: Colors.transparent,
                    checkColor: buddiesYellow,
                    value: _agreeTOS,
                    onChanged: (value) {
                      setState(() {
                        _agreeTOS = value;
                      });
                    }),
                Text(
                  'By checking this box you are agreeing\n  to our terms of service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: buddiesPurple,
                      fontSize: screenAwareSize(12, context),
                      fontFamily: 'Roboto-Regular'),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  activeColor: Colors.transparent,
                  checkColor: buddiesYellow,
                  value: _allowEmails,
                  onChanged: (value) {
                    setState(() {
                      _allowEmails = value;
                    });
                  }),
              Text(
                'Can we send you promos, deals,\n and other fun stuff?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: buddiesPurple,
                    fontSize: screenAwareSize(12, context),
                    fontFamily: 'Roboto-Regular'),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _checkPasswords() {
    setState(() {
      if (tmpPwd == tmpPwd2) {
        _signupForm['password'] = tmpPwd2.replaceAll(' ', '');
      } else {
        print('Passwords Do Not Match');
        _signupForm['password'] = null;
      }
    });
  }
}
