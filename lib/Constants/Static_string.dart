import 'package:Buddies/Constants/Colors.dart';
import 'package:Buddies/Model/SquareCustomer.dart';
import 'package:Buddies/Model/UserEvents.dart';
import 'package:Buddies/Model/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Model/SquareCustomer.dart';

double baseHeight = 640.0;

//Text Finals

// final String passwordRules = Text('password must contain 1 number (0-9)\n password must contain 1 uppercase letters
// password must contain maxLines: 1 lowercase letters
// password must contain 1 non-alpha numeric number
// softWrap: password is 8-16 characters with no spacesemanticsLabel');

//user Data
final String serverTokenError =
    '{non_field_errors: [No active account found with the given credentials]}';

//App Bar

var buddiesAppBar = AppBar(
    centerTitle: true,
    elevation: 8,
    backgroundColor: buddiesGreen,
    title: buddiesLogo,
    actions: <Widget>[Container()]);

dynamic userProfile;
CustomerDetail customerProfile;
List recommendedProducts = [];
List recCategories = [];
var sponsored;
var pOrders;
bool cartEmpty = false;
var orderError;
var orderErrorTitle;
bool googleSignInSuccess = false;
bool hasProfile = false;
dynamic currentDispensaries;
dynamic currentProducts;
dynamic selectedDispensary;
dynamic currentMarkers;
bool updatingCart = false;
int jumpToCart = 0;
bool fromPreRec = false;
String resetPwdUrl = 'http://buddies-8269.herokuapp.com/password_reset/';
int verifyUpload;
String _androidEmulator = 'http://10.0.2.2:8000';
String _liveServer = 'http://buddies-8269.herokuapp.com';
String buddiesServer = _liveServer;
var couponData;
ActiveSquareAccount squareData;

final whitebuttonText = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    color: Colors.white);

// Marker smiley =  getBytesFromAsset('assets/smiley.png', 100) as Uint8List;
dynamic suggestedDemo;

List categoryPhotos = [
  'assets/cbd.jpeg',
  'assets/concentrates.jpeg',
  'assets/edible.jpeg',
  'assets/prod1.png',
  'assets/pets.jpeg',
  'assets/rig.jpeg',
  'assets/preroll.jpeg',
  'assets/accessories.jpg',
  'assets/topicals.jpeg',
  'assets/pens.jpeg',
];
List dispensarySearchCategories = [
  'CBD Only',
  'Dabs',
  'Edibles',
  'Flower',
  'For Pets',
  'Pipes,Bongs & Rigs',
  'Pre-Rolled',
  'Storage',
  'Topical',
  'Vaping',
];

bool signUpComplete = false;
// Location Data
var userLat = 0.0;
var userLong = 0.0;
var position;
bool orderPlaced = false;
String tokenType;
var dispensaryMenu;
bool dispensaryOpened = false;
UserEvents userEvents;

//Test Token
final String stripeToken = 'tok_visa_debit';

//Map API Key
const PLACES_API_KEY = 'AIzaSyDXdUY1EZ5Edum6FAY4-jP7EppUWIgb-IY';

//Text

final productReviewFont = TextStyle();

final titleStyle =
    TextStyle(fontSize: 14, color: buddiesPurple, fontFamily: 'Poppins');
final secondaryStyle = TextStyle(
  fontFamily: 'Roboto-Regular',
  fontSize: 12,
);

final orderDetailFont = TextStyle(fontSize: 12, fontFamily: 'Roboto-Regular');
final capitalFont =
    TextStyle(fontSize: 12, fontFamily: 'Poppins', color: buddiesPurple);
final productFont =
    TextStyle(fontSize: 14, fontFamily: 'Poppins', color: buddiesPurple);

final poppinsWithWhite =
    TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins');

final titleParagraphStyle =
    TextStyle(fontSize: 20, color: buddiesPurple, fontFamily: 'Poppins');
final secondaryParagraphStyle = TextStyle(
  fontFamily: 'Roboto-Regular',
  fontSize: 16,
);

final shareSubject = 'Check Out What I Found On Buddies!';

abstract class StringValidator {
  bool isValid(String value);
}

//Selected Product ScreenData
List<String> sizeNumlist = [
  'Gm',
  "1/8",
  "1/4",
  "1/2",
  "Oz",
  "Acc",
  'Each',
  '2 Pack',
  '3 PACK',
  '5 PACK',
  '10 PACK',
  'OTHER'
];

List<String> nameList = [
  'Gram',
  "Eighth",
  "Quarter",
  "Half",
  "Oz",
  "Acc",
  'SINGLE',
  '2 PACK',
  'THREE_PACK',
  'FIVE_PACK',
  'TEN_PACK',
  'OTHER'
];

// Product Info Popup
List productCategoryDescription = [
  "Flower: Flowers are smoked using a pipe or bong, or by rolling it into a joint or blunt.",
  "Concentrates: Concentrates or Extracts are any product derived from cannabis flower that is processed into a concentrated form, but each type of cannabis oil is unique.",
  "Dabs: Dabs are concentrated doses of cannabis that are made by extracting THC and other cannabinoids. Dabs are heated on a hot surface, usually a nail, and then inhaled through a dab rig.",
  "Pets: Pet Care Products are all-natural, pet-safe, products that have been carefully designed to provide relief from several chronic conditions for our fur babies.",
  "Storage: Providing the best in canna-storage, our Buddies make sure your bud stays fresh longer.",
  "Topicals: Topicals are cannabis-infused lotions, balms, and oils that are absorbed through the skin for localized relief of pain, soreness, and inflammation. Because they’re non-intoxicating, topicals are often chosen by patients who want the therapeutic benefits of marijuana without the cerebral euphoria associated with other delivery methods.",
  "Vapes: Vaporizing, or vaping, cannabis is a smokeless process that involves heating dry flower or concentrate without burning it. Vape pens are popular for their ease of use, portability, and because they offer an opportunity for more consistent dosing than other methods of inhaling marijuana.",
  "Home Setup: The best rigs and station for dabs and more.",
  "Edibles: Edible forms of cannabis, including food products, lozenges, and capsules, can produce effective, long-lasting, and safe effects.",
  "Pre-Rolled: No time to roll? We got you with these finest Pre-Rolled products to have you feel exactly how you want to.",
  "Bongs & Pipes: Find the best items to enjoy your medicine.",
];

final String thcContent =
    'THC, or tetrahydrocannabinol, is the chemical compound in cannabis responsible for a euphoric high.';

final String cbdContent =
    'Hemp-based CBD products are made with .03% providing pain relief without getting you high';
final List strain = [
  'Hybrids are crossbred strains of cannabis that have both indica and sativa genetics. They can take after either parent, with desirable characteristics from each parent.',
  'Indica strains produce a body high that is well suited for nights when you just want to wind down and be in your own head. Indicas are often used to relieve stress and aid with sleep.',
  'Sativas are a great choice when treating mental ailments.Sativa strains are often used to treat conditions like anxiety, ADD/ADHD, depression, and other mood disorders.',
  'Rigs: Rigs',
  'Carry Case: Case',
  'Pen: Discrete, Easy To Carry. No fuss, no muss',
  'Cartridge: Refills For Pens or Vapes',
  'Bongs & Pipes: Bongs and Pipes'
];

List sizeNameList = [
  'Grape',
  'Kiwi',
  'Apple',
  'GrapeFruit',
  'Coconut',
  'Accessory',
  'SINGLE',
  '2 PACK',
  'THREE_PACK',
  'FIVE_PACK',
  'TEN_PACK',
  'OTHER'
];

//Screen Sizes

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

var buddiesPopupHeader = Row(
  children: <Widget>[
    Image.asset('assets/smiley.png', width: 75, height: 80, fit: BoxFit.fill),
    Text(
      'Welcome!',
      style: titleParagraphStyle,
    )
  ],
);

var currentCart;
bool isUploaded;

//Colors
final buddiesPurple = HexColor('1c1463');
final buddiesGreen = HexColor('008080');
final buddiesGreen2 = HexColor('00ecae');
final buddiesSecondaryPurple = HexColor('47004C');
final buddiesYellow = HexColor('FFBD00');
final buddiesBlue = HexColor('5AE1FF');
final mainstyle = TextStyle(
  fontFamily: 'Poppins',
);
final subStyle = TextStyle(
  fontFamily: 'Roboto-Regular',
);

List<Color> colors = [
  Color(0xFFF9362E),
  Color(0xFF003CFF),
  Color(0xFFFFB73A),
  Color(0xFF3AFFFF),
  Color(0xFF1AD12C),
  Color(0xFFD66400),
];

//Images

final buddiesLogo =
    Image.asset('assets/buddies_white.png', scale: 10, fit: BoxFit.contain);

List sizeicons = [
  Tab(
    icon: Image.asset('assets/icons/grape.png'),
  ),
  Tab(
    icon: Image.asset('assets/icons/kiwi.png'),
  ),
  Tab(
    icon: Image.asset('assets/icons/apple.png'),
  ),
  Tab(
    icon: Image.asset('assets/icons/grapefruit.png'),
  ),
  Tab(
    icon: Image.asset('assets/icons/coconut.jpeg'),
  ),
];

final BitmapDescriptor buddiesMarker = BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/smiley.png')
    as BitmapDescriptor;

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});
  final StringValidator editingValidator;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = editingValidator.isValid(oldValue.text);
    final newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String regexSource;

  /// value: the input string
  /// returns: true if the input string is a full match for regexSource
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
