import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui';

class CustomerPreferences extends StatefulWidget {
  @override
  State createState() => _CustomerPreferences();
}

class _CustomerPreferences extends State<CustomerPreferences> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _ageFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final _strainTypeFocus = FocusNode();
  final _feelingsFocus = FocusNode();
  final _custTypeFocus = FocusNode();
  final _levelFocus = FocusNode();

  String _name;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  String _phoneNumb;
  List _feelings = [
    "Arousal",
    "Creative",
    "Energetic",
    "Euphoric",
    "Focused",
    "Giggly",
    "Happy",
    "Hungry",
    "Relaxed",
    "Sleepy",
    "Talkative",
    "Tingly",
    "Uplifted"
  ];

  String _selectedCustomerType;

  List _cbdInfo = ["Indica", "Sativa", "Hybrid", "I'm Not Sure"];
  List _strainDesc = [
    "Indicas produce a calming effect, perfect for relaxing with a movie or as a nightcap before bed.",
    "Sativas tend to provide more invigorating, uplifting cerebral effects that pair well with physical activity, social gatherings, and creative projects.",
    ""
  ];
  final Map<String, dynamic> _formData = {
    'nick_name': null,
    'age': null,
    'customer_type': null,
    'phone': null,
    'prefered_strain_type': null,
    'wants_to_feel': null,
    'level': null
  };

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/Background.jpg'),
      fit: BoxFit.fill,
      // colorFilter:/
      // ColorFilter.mode(Colors.blue.withOpacity(.5), BlendMode.dstATop),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _pagecount = [];
    var index = 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      // backgroundColor: Colors.orange[300],
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height >= 250.0
              ? MediaQuery.of(context).size.height
              : 250.0,
          alignment: Alignment.center,
          // decoration: BoxDecoration(image: _buildBackgroundImage()),
          child: Column(children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset(
                      'assets/HSI.png',
                      scale: 5,
                      color: Colors.orange[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      // child: Text(
                      //   "Your Buddies' Profile",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.orange,
                      //     fontFamily: 'Poppins',
                      //     fontSize: 22.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: PageView(
                //LOAD UP PAGES
                controller: _pageController,
                pageSnapping: true,
                onPageChanged: (i) {
                  if (i == 0) {
                    setState(() {
                      // right = Colors.white;
                      // left = Colors.black;
                      index = 0;
                    });
                  } else if (i == 1) {
                    setState(() {
                      // right = Colors.black;
                      // left = Colors.white;
                      index = 1;
                    });
                  } else if (i == 2) {
                    setState(() {
                      index = 2;
                    });
                  } else if (i == 3) {
                    setState(() {
                      index = 3;
                    });
                  } else if (i == 4) {
                    setState(() {
                      index = 4;
                    });
                  }
                },
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _madeList(context),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _infoSheet(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _introSheet(context),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _introSheet(context),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(
            //     top: 16,
            //     bottom: 16
            //   ),
            //   child: DotsIndicator(
            //     dotsCount: index,
            //     position: _pagecount[index],
            //   )
            // )
          ]),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final _nameFocus = FocusNode();
    final _phoneFocus = FocusNode();
    final _ageFocus = FocusNode();
    final _customerTypeFocus = FocusNode();
    final _customerFeelFocus = FocusNode();
    final _levelFocus = FocusNode();

    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
    TextEditingController _customerTypeController = TextEditingController();
    TextEditingController _feelingController = TextEditingController();
    TextEditingController _levelController = TextEditingController();

    String _name;

    List _customerType = ["Medical", "Recreational,"];
    List _type = ["Hybrid", "Indica", "Sativa", " No Preference, No Worries"];
    List _level = ["Newbie", "Experienced", "Canna-Veteran"];
    List _feelings = [
      "Arousal",
      "Creative",
      "Energetic",
      "Euphoric",
      "Focused",
      "Giggly",
      "Happy",
      "Hungry",
      "Relaxed",
      "Sleepy",
      "Talkative",
      "Tingly",
      "uplifted"
    ];

    void _changedDropDownItem(String newValue) {
      setState(() {
        _selectedCustomerType = newValue;
      });
    }

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                child: Card(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    semanticLabel: 'logo',
                    color: Colors.green,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 175,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.greenAccent)),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      focusNode: _nameFocus,
                      controller: _nameController,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        icon: Icon(Icons.person),
                      ),
                      validator: (String value) {
                        // if (value.trim().length <= 0) {
                        if (value.isEmpty || value.length < 20) {
                          return 'Description is required and should be 10+ characters long';
                        }
                      },
                      onEditingComplete: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                // color: Colors.white,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Colors.greenAccent,
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: DropdownButton(
                  hint: Text('Medical'),
                  value: _selectedCustomerType,
                  onChanged: (newValue) {
                    _changedDropDownItem(newValue);
                  },
                  items: _customerType.map((cusType) {
                    print(cusType);

                    return DropdownMenuItem(
                      child: Text(cusType),
                      value: cusType,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 10),
              Container(
                // color: Colors.white,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.greenAccent)),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      focusNode: _ageFocus,
                      controller: _ageController,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Age',
                        icon: Icon(Icons.calendar_today),
                      ),
                      validator: (String value) {
                        // if (value.trim().length <= 0) {
                        if (value.isEmpty || value.length < 20) {
                          return 'Description is required and should be 10+ characters long';
                        }
                      },
                      onEditingComplete: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                // color: Colors.white,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.greenAccent)),
                width: 150,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      focusNode: _customerTypeFocus,
                      controller: _customerTypeController,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Fav Strain',
                        icon: Icon(Icons.power),
                      ),
                      validator: (String value) {
                        // if (value.trim().length <= 0) {
                        if (value.isEmpty || value.length < 20) {
                          return 'Description is required and should be 10+ characters long';
                        }
                      },
                      onEditingComplete: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.greenAccent)),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      focusNode: _customerFeelFocus,
                      controller: _feelingController,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Fav Effect',
                        icon: Icon(Icons.person),
                      ),
                      validator: (String value) {
                        // if (value.trim().length <= 0) {
                        if (value.isEmpty || value.length < 20) {
                          return 'Description is required and should be 10+ characters long';
                        }
                      },
                      onEditingComplete: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Center(
                child: Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.greenAccent)),
                  width: 175,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _phoneFocus,
                        controller: _phoneController,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Phone #',
                          icon: Icon(Icons.phone),
                        ),
                        validator: (String value) {
                          // if (value.trim().length <= 0) {
                          if (value.isEmpty || value.length < 20) {
                            return 'Description is required and should be 10+ characters long';
                          }
                        },
                        onEditingComplete: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Column(
            children: <Widget>[
              Center(
                child: RaisedButton(
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 45, left: 30, right: 30, bottom: 70),
        child: Container(
          child: _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildPreferences(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 45, left: 30, right: 30, bottom: 80),
        child: Container(
          child: Card(
            elevation: 10.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    final _nameFieldFocus = FocusNode();
    final _pwdField = FocusNode();

    return Container(
      height: 200,
      decoration: BoxDecoration(),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 45, left: 30, right: 30, bottom: 80),
        child: Container(
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _nameFieldFocus,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (String value) {
                  // if (value.trim().length <= 0) {
                  if (value.isEmpty || value.length < 20) {
                    return 'Description is required and should be 10+ characters long.';
                  }
                },
                // onSaved: (String value) {
                //   _formData[_name] = value;
                //   print(_name);
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _introSheet(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Text(
            'How Do You Want To Feel?',
            style: prefix0.TextStyle(fontFamily: 'Poppins', fontSize: 28),
          ),
          Text(
            '\nWe will tune your recommendations based on your preferences',
            style:
                prefix0.TextStyle(fontFamily: 'Roboto-Regular', fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 15, right: 15, bottom: 20),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print('Arousal');
                      },
                      child: Chip(
                        label: Text(
                          'Arousal',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Creative');
                      },
                      child: Chip(
                        label: Text(
                          'Creative',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Energetic');
                      },
                      child: Chip(
                        label: Text(
                          'Energetic',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Euphoric');
                      },
                      child: Chip(
                        label: Text(
                          'Euphoric',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Focused');
                      },
                      child: Chip(
                        label: Text(
                          'Focused',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Giggly');
                      },
                      child: Chip(
                        label: Text(
                          'Giggly',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Happy');
                      },
                      child: Chip(
                        label: Text(
                          'Happy',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Hungry');
                      },
                      child: Chip(
                        label: Text(
                          'Hungry',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Relaxed');
                      },
                      child: Chip(
                        label: Text(
                          'Relaxed',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Sleepy');
                      },
                      child: Chip(
                        label: Text(
                          'Sleepy',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Talkative');
                      },
                      child: Chip(
                        label: Text(
                          'Talkative',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Tingly');
                      },
                      child: Chip(
                        label: Text(
                          'Tingly',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Uplifted');
                      },
                      child: Chip(
                        label: Text(
                          'Uplifted',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Card List
  Widget _madeList(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Text(
            'What Is CBD?',
            style: prefix0.TextStyle(fontFamily: 'Poppins', fontSize: 26),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/cbd.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'CBD is a compound found naturally in hemp plants. The Compound is known to reduce inflamation, help reduce seizures, and with pain relief. \n\nCBD contains less than .03% THC so you will receive the medicinal benfits without the high ',
                  style: prefix0.TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _infoSheet() {
  return Container(
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'What',
          style: prefix0.TextStyle(fontFamily: 'Poppins', fontSize: 26),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'What Type of Customer Are you',
          style: prefix0.TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 15, right: 15, bottom: 20),
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10.0,
                    runSpacing: 5.0,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print('Medical');
                        },
                        child: Chip(
                          label: Text(
                            'Medical',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                          elevation: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Recreational');
                        },
                        child: Chip(
                          label: Text(
                            'Recreational',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                          elevation: 8,
                        ),
                      ),
                    ]),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 15, right: 15, bottom: 20),
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10.0,
                    runSpacing: 5.0,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print('Medical');
                        },
                        child: Chip(
                          label: Text(
                            'Medical',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                          elevation: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Recreational');
                        },
                        child: Chip(
                          label: Text(
                            'Recreational',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                          elevation: 8,
                        ),
                      ),
                    ]),
              ),
            )),
        MaterialButton(
          onPressed: () {},
          child: Text('data'),
        )
      ],
    ),
  );
}

//  GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, childAspectRatio: .8
//             ),
//             itemCount: 4,
//             shrinkWrap: true,
//             itemBuilder: (context, i ){
//               return InkWell(
//                 child: Container(
//                   margin: EdgeInsets.all(5),
//                   child: Card(
//                     elevation: 4,
//                     margin: EdgeInsets.all(8),
//                     color: Colors.white,
//                     child: Column(
//                       children: <Widget>[
//                         Text(
//                         'Mama Wammas',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         SizedBox(
//                   height: 10,
//                         ),
//                         Text('Flower | Sativa'),
//                         Image.asset(
//                   'assets/prod2.png',
//                   width: 100,
//                   height: 100,
//                         ),
//                         Text(
//                   'Feels Like:\nGiggly, Hungry, Euphoric',
//                   style: TextStyle(fontSize: 14),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
