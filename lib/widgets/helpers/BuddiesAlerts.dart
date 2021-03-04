import 'package:Buddies/Constants/Static_string.dart';
import 'package:flutter/material.dart';

class BuddiesAlertWidgets {
  void singlebutton(context, headerText, content, func) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(80, context),
                  height: screenAwareSize(80, context),
                  fit: BoxFit.contain),
              Text(
                headerText,
                style: titleParagraphStyle,
              )
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                func;

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void twoButtonPopup(context, content, function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'Buddies!',
                style: titleParagraphStyle,
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                function();
              },
            ),
            FlatButton(
              child: Text("Go Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void squareTwoButtonPopup(context, content, function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'New Card',
                style: titleParagraphStyle,
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("Nope"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Add Card To Profile"),
              onPressed: () => function,
            ),
          ],
        );
      },
    );
  }

  void nofunction(context, headerText, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                headerText,
                style: titleParagraphStyle,
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showPopup(context, textA, textB, page, segue) {
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
            segue == 'segue'
                ? FlatButton(
                    child: Text("Get Your Bud!"),
                    onPressed: () {
                      Navigator.pushNamed(context, page);
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

  void single(context, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'Buddies! Guide',
                style: titleParagraphStyle,
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
