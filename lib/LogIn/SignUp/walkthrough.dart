import 'package:Buddies/LogIn/helpers/intro_page_view.dart';
import 'package:flutter/material.dart';






class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  IntroPageView();
  }
}

class IntroItem {
  IntroItem({
    this.title,
    this.imageUrl,
  });

  final String title;
  final String imageUrl;
}

final sampleItems = <IntroItem>[
  new IntroItem(title: 'Order From Wherever You Are And Get Your Medicine',  imageUrl: 'assets/orderpic.jpeg',),
  new IntroItem(title: 'Delivery From Am To Pm', imageUrl: 'assets/driver.jpeg',),
  new IntroItem(title: 'Right To Your Door', imageUrl: 'assets/delivered.jpeg',),
];