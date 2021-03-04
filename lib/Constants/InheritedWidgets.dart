import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:flutter/material.dart';

class BuddiesInherited {
  Future initialProductSetup(int num) async {
    await getProducts(num);
  }

  void updatingCartFunction(bool) {
    updatingCart = bool;
  }
}

class BuddiesAlertWidget {
  void showPopup(context, content) {
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
}
