import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class OldPage extends StatefulWidget {
  @override
  _OldPage createState() => _OldPage();
}

class _OldPage extends State<OldPage>
    with TickerProviderStateMixin {
  @override

//Vars
  Animation animation;
  AnimationController animationController;
  AnimationController _controller;

  final bg1 = AssetImage('assets/accessories.jpg');
  final bg2 = AssetImage('assets/bg2.jpg');

  int _currentIndex = 0;
  int _selectedIndex = 0;

  List _backgroundImages = [
    AssetImage('assets/Happy.png'),
    AssetImage('assets/relax1.jpg'),
    AssetImage('assets/bg1.jpg'),
    AssetImage('assets/bg1.jpg'),
    AssetImage('assets/accessories.jpg'),
  ];

  List _cardImages = [
    AssetImage('assets/relax1.jpg'),
    AssetImage('assets/half.jpg'),
    AssetImage('assets/Electric.png'),
    AssetImage('assets/bg1.jpg'),
    AssetImage('assets/accessories.jpg'),
  ];

  List _backgroundColors = [
    Color(0xffAED3EA),
    Color(0xffabecd6),
    Color(0xffAED3EA),
    Color(0xffccc3fc),
  ];

  List _nameList = [
    Text(
      'Your Customized Menu:\nA Menu For Your Taste',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    Text(
      'Relaxation :\nFind What You Need To Relax Your Way',
      style: TextStyle(
          color: Colors.orange[300], fontWeight: FontWeight.bold, fontSize: 20),
    ),
    Text(
      'The Feels:\nFind The Right Bud For The Occasion',
      style: TextStyle(
          color: Colors.yellow[300], fontWeight: FontWeight.bold, fontSize: 20),
    ),
    Text(
      'Edibles:\nNom, Nom, Nom',
      style: TextStyle(
          color: Colors.yellow[300], fontWeight: FontWeight.bold, fontSize: 20),
    ),
    Text(
      'Inventory:\nFind What You Need By Product Type',
      style: TextStyle(
          color: Colors.orange[300], fontWeight: FontWeight.bold, fontSize: 20),
    ),
  ];

  // List title = [
  //   Text('Arousal'),
  //   Text('Creative'),
  //   Text('Energetic'),
  //   Text('Euphoric'),
  //   Text('Focused'),
  //   Text('Giggly'),
  //   Text('Happy'),
  //   Text('Hungry'),
  //   Text('Relaxed'),
  //   Text('Sleepy'),
  //   Text('Talkative'),
  //   Text('Tingly'),
  //   Text('Uplifted'),
  // ];

  List title = [
    Chip(
      label: Text('Arousal'),
      elevation: 8,
    ),
    Chip(
      label: Text('Creative'),
      elevation: 8,
    ),
    Chip(
      label: Text('Energetic'),
      elevation: 8,
    ),
    Chip(
      label: Text('Euphoric'),
      elevation: 8,
    ),
    Chip(
      label: Text('Focused'),
      elevation: 8,
    ),
    Chip(
      label: Text('Giggly'),
      elevation: 8,
    ),
    Chip(
      label: Text('Happy'),
      elevation: 8,
    ),
    Chip(
      label: Text('Hungry'),
      elevation: 8,
    ),
    Chip(
      label: Text('Relaxed'),
      elevation: 8,
    ),
    Chip(
      label: Text('Sleepy'),
      elevation: 8,
    ),
    Chip(
      label: Text('Talkative'),
      elevation: 8,
    ),
    Chip(
      label: Text('Tingly'),
      elevation: 8,
    ),
    Chip(
      label: Text('Uplifted'),
      elevation: 8,
    ),
  ];

  List feels = [
    Text('Creative'),
    Text('Energetic'),
    Text('Euphoric'),
    Text('Focused'),
    Text('Giggly'),
    Text('Happy'),
    Text('Hungry'),
    Text('Relaxed'),
    Text('Sleepy'),
    Text('Sexy Time'),
    Text('Talkative'),
    Text('Tingly'),
    Text('Uplifted'),
  ];

  List inventory = [
    Text('Flower'),
    Text('Concentrates'),
    Text('Dabs'),
    Text('Pets'),
    Text('Storage'),
    Text('Topical'),
    Text('Vaping'),
    Text('Home Setup'),
    Text('Edibles'),
    Text('Pre-Rolled'),
    Text('Bongs & Pipes')
  ];

  List detailList = [
    Text('Search By \nMy Recommended'),
    Text('No Stress\n No Headaches\n Just All Good'),
    Text('Always Be Prepared\n For The Occasion'),
    Text('Get Tastiest Bites\n From The Bud Bakery'),
    Text('Look Around &\n Find The Good Stuff'),
  ];

  List gradients = [
    BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Colors.blue])),
    BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.blue])),
    BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green, Colors.blue])),
    BoxDecoration(
        gradient: LinearGradient(colors: [Colors.yellow, Colors.blue])),
  ];

  List chipData = [
    Text('Arousal'),
    Text('Creative'),
    Text('Energetic'),
    Text('Euphoric'),
    Text('Focused'),
    Text('Giggly'),
    Text('Happy'),
    Text('Hungry'),
    Text('Relaxed'),
    Text('Sleepy'),
    Text('Talkative'),
    Text('Tingly'),
    Text('Uplifted'),
  ];

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animation = animationController;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _onChanged(_selectedIndex) {
    //update with a new color when the user taps button
    setState(() {
      _currentIndex = _selectedIndex;

      if (_selectedIndex == 0) {
        chipData = title;
      }
      if (_selectedIndex == 1) {
        chipData = feels;
      }
      if (_selectedIndex == 2) {
        chipData = inventory;
      }
    });
  }

//Card List
  Widget _madeList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 15.0),
      height: 300,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 200,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Mama Wammas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.orange,
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            print('Oh I like THat');
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Flower | Sativa'),
                  Image.asset(
                    'assets/prod2.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Feels Like:\nGiggly, Hungry, Euphoric',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recommended For:\n Headaches, Body High',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 200,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Gorilla Glue',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.orange,
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            print('Oh I like THat');
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Indica | Cartridge'),
                  Image.asset(
                    'assets/prod6.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Feels Like:\nGiggly, Hungry, Euphoric',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recommended For:\n Headaches, Body High',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 200,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'CBD Scrub ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.orange,
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            print('Oh I like THat');
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Flower | Sativa'),
                  Image.asset(
                    'assets/topical.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Feels Like:\nGiggly, Hungry, Euphoric',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recommended For:\n Headaches, Body High',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 200,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Blue Magic',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.orange,
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            print('Oh I like THat');
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Flower | Sativa'),
                  Image.asset(
                    'assets/prod4.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Feels Like:\nGiggly, Hungry, Euphoric',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recommended For:\n Headaches, Body High',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 210,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Yummy Gummies',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          color: Colors.grey,
                          highlightColor: Colors.orange,
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            print('Oh I like THat');
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Edible | Sativa'),
                  Image.asset(
                    'assets/gummies.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    'Feels Like:\nGiggly, Hungry, Euphoric',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recommended For:\n Headaches, Body High',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
//Card Widget

  @override
  Widget build(BuildContext context) {
    var _bg = _backgroundImages[_currentIndex];
    var _bgColor = _backgroundColors[_currentIndex];
    // var title = _nameList[_currentIndex];
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: gradients[_currentIndex],
        // color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.dstOut,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: _bg,
                      ),
                      gradient:
                          LinearGradient(colors: [Colors.orange, Colors.blue]),
                    ),
                    height: 300,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 45.0, 15.0, 10.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black),
                                contentPadding:
                                    EdgeInsets.only(left: 15.0, top: 15.0),
                                hintText: 'First Name',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange,
                                      style: BorderStyle.solid,
                                      width: 3.0))),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[_nameList[_currentIndex]],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 60.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25.0, left: 15.0),
                        height: 125.0,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  _selectedIndex = 0;
                                  _onChanged(_selectedIndex);
                                },
                                child:
                                    _filterCard(detailList[0], _cardImages[0])),
                            SizedBox(width: 10.0),
                            GestureDetector(
                                onTap: () {
                                  _selectedIndex = 1;
                                  _onChanged(_selectedIndex);
                                },
                                child:
                                    _filterCard(detailList[1], _cardImages[1])),
                            SizedBox(width: 10.0),
                            GestureDetector(
                                onTap: () {
                                  _selectedIndex = 2;
                                  _onChanged(_selectedIndex);
                                },
                                child:
                                    _filterCard(detailList[2], _cardImages[2])),
                            SizedBox(width: 10.0),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 15.0),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Filter By Need',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.grey,
                      fontSize: 14.0),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Find Help With:',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Timesroman',
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
              ),
              SizedBox(height: 10.0),

              Wrap(
                direction: Axis.horizontal,
                spacing: 10.0,
                runSpacing: 5.0,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Chip(
                    label: Text('Arousal'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Creative'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Energetic'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Euphoric'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Focused'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Giggly'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Happy'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Hungry'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Relaxed'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Sleepy'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Talkative'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Tingly'),
                    elevation: 8,
                  ),
                  Chip(
                    label: Text('Uplifted'),
                    elevation: 8,
                  ),
                ],
              ),

              // _myChips(),
              SizedBox(
                height: 10,
              ),
              _productBuilder(context)
            ],
          ),
        ),
      ),
    );
  }


  Widget _filterCard(detailList, _cardImages) {
    return Container(
      height: 125.0,
      width: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.brown[50],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(image: _cardImages)),
              height: 125.0,
              width: 80.0,
            ),
          ),
          SizedBox(width: 18.0),
          Wrap(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                detailList,
                SizedBox(height: 10.0),
                Container(
                  height: 2.0,
                  width: 75.0,
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ])
        ],
      ),
    );
  }

  Widget _productBuilder(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
              child: _madeList(context),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OldPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
