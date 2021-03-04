import 'package:Buddies/Checkout/Cart.dart';
import 'package:Buddies/Checkout/CartDetails.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/HomeScreens/HomePage.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomBarController();
}

class _BottomBarController extends State<BottomBarController> {
  int _currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic dispensary;

  var pages = [
    HomePage(),
    CartPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    pages[0] = HomePage();
    Locator().checkLocation(userLat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        elevation: 8,
        hasInk: true,
        inkColor: Colors.black12,
        items: [
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.home,
              color: buddiesPurple,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.home,
              color: buddiesGreen,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: buddiesGreen,
              ),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: buddiesPurple,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: buddiesGreen,
            ),
            title: Text(
              "Cart",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: buddiesGreen,
              ),
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }
}
