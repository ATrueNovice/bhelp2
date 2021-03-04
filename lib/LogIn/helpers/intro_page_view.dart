import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/LogIn/SignUp/SignUpPage.dart';
import 'package:Buddies/LogIn/SignUp/walkthrough.dart';
import 'package:Buddies/LogIn/helpers/intro_page_item.dart';
import 'package:Buddies/LogIn/helpers/page_transformer.dart';
import 'package:flutter/material.dart';

class IntroPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox.fromSize(
                size: const Size.fromHeight(530.0),
                child: PageTransformer(
                  pageViewBuilder: (context, visibilityResolver) {
                    return PageView.builder(
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: sampleItems.length,
                      itemBuilder: (context, index) {
                        final item = sampleItems[index];
                        final pageVisibility =
                            visibilityResolver.resolvePageVisibility(index);

                        return IntroPageItem(
                          item: item,
                          pageVisibility: pageVisibility,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: buddiesGreen,
                onPressed: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => SignUpPage()));
                },
                child: Text(
                  'Skip To Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: screenAwareSize(20, context)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
