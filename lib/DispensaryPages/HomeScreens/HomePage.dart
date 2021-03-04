import 'dart:async';
import 'dart:math';
import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Checkout/CartDetails.dart';
import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/DispensaryHomePage/DispensaryHome.dart';
import 'package:Buddies/DispensaryPages/SearchPage.dart';
import 'package:Buddies/DispensaryPages/SelectedProductPage/SelectedProduct.dart';
import 'package:Buddies/Model/DisNProducts.dart';
import 'package:Buddies/widgets/helpers/BuddiesAlerts.dart';
import 'package:Buddies/widgets/state_block.dart';
import 'package:flutter_flip_view/flutter_flip_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  //Check Profile
  // Future _getProfile;
//Front Page Values
  Future _setProducts;

  var products;
  var listData;
  final _homePageScaffoldKey = new GlobalKey<_HomePage>();

  Geolocator geolocator = Geolocator();

  Random random = Random();

  int min = 1;
  int max = 4;
  int selection = 1;

  int index = 0;

  int starCount = 5;
  double rating = 4.5;

  var dispensary;
  var dispensaries;
//Distance Map filter Button
  List<Locations> filteredVenues;
  Future _setDispensaries;

  // var _filteredMarkers;
  var filteredDispensares;
  double currentLat = 0.0;
  double currentLong = 0.0;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  //Flip
  AnimationController _animationController;
  Animation<double> _curvedAnimation;

  // Raising and lower animations
  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  forwardAnimation() {
    _bottomSheetAnimationController.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    _bottomSheetAnimationController.reverse();
    stateBloc.toggleAnimation();
  }

  //Back map variables
  double sheetTop = 500;
  double minSheetTop = 50;
  final _mapScaffold = new GlobalKey<ScaffoldState>();

  double zoomVal = 5.0;
  GoogleMapController mapController;

  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  AnimationController _bottomSheetAnimationController;
  Animation<double> _bottomSheetCurvedAnimation;
  var newFutureDispensaries;

  void _flip(bool reverse) {
    if (_animationController.isAnimating) return;
    if (reverse) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void setCustomMapPin(currentDispensaries) async {
    print('markers made');
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(60, 60)),
      'assets/smiley.png',
    );
    _createMarkers(currentDispensaries);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bottomSheetAnimationController.dispose();
    scaleController.dispose();
    fadeController.dispose();

    stateBloc.dispose();

    super.dispose();
  }

  @override
  void initState() {
    var now = new DateTime.now();

    // print(DateFormat("H:m:s")
    //     .format(now)
    //     .compareTo("${dispensaries[0].openingHours[6].closingTime}"));

    super.initState();

    //Flip Animation

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    //BottomSheetAnimation

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);
    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
        parent: scaleController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut));

    _bottomSheetAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _bottomSheetCurvedAnimation =
        Tween<double>(begin: sheetTop, end: minSheetTop).animate(
            CurvedAnimation(
                parent: _bottomSheetAnimationController,
                curve: Curves.easeInOut,
                reverseCurve: Curves.easeInOut))
          ..addListener(() {
            setState(() {});
          });
    _setDispensaries = getDispensaries();
  }

  String getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 5) {
      return "Just now";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

//Build Starts Here
  Widget build(BuildContext context) {
    return _getdispensaries();
  }

  Widget _getdispensaries() {
    return currentDispensaries == null
        ? FutureBuilder(
            future: _setDispensaries,
            builder: (context, snapshot) {
              print('Called Dispensaries');
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData == true) {
                currentDispensaries = snapshot.data;
                print('Snapshot');
                print(currentDispensaries);
                setCustomMapPin(currentDispensaries);
              } else {
                print('Waiting after call');
                return Center(child: CircularProgressIndicator());
              }
              print('Create widget');
              return FlipView(
                animationController: _curvedAnimation,
                front: frontPage(context, currentDispensaries),
                back: searchList(context, currentDispensaries),
              );
            },
          )
        : FlipView(
            animationController: _curvedAnimation,
            front: frontPage(context, currentDispensaries),
            back: searchList(context, currentDispensaries),
          );
  }

  Widget frontPage(BuildContext context, currentDispensaries) {
    return Scaffold(
      key: _homePageScaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 8,
        backgroundColor: buddiesGreen,
        title: buddiesLogo,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.map,
              color: Colors.white,
            ),
            onPressed: () {
              _preFlipLocationCheck();
            },
          ),
          Container()
        ],
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.searchLocation,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: _buildSelectionOptions(currentDispensaries),
        ),
      ),
    );
  }

  void _preFlipLocationCheck() {
    var lat = userLat;
    Locator().checkLocation(lat);

    print('The user lat is $lat');

    if (lat == 0) {
      final _func = Locator().checkLocation(lat);
      BuddiesAlertWidgets().singlebutton(
          context, 'Where Are You Bud?', '\nWe Need Your Location', _func);
    } else {
      _flip(true);
    }
  }

  void _noProfilePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: buddiesPopupHeader,
          content: Text(
            'Lets Create Your Profile!',
            style: TextStyle(
                fontFamily: 'Roboto-Regular',
                color: buddiesPurple,
                fontWeight: FontWeight.w400,
                fontSize: screenAwareSize(14, context)),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            RaisedButton.icon(
                elevation: 8,
                highlightColor: buddiesYellow,
                icon: Icon(
                  FontAwesomeIcons.cannabis,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: buddiesGreen,
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "Start",
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: screenAwareSize(16, context)),
                    ),
                  ),
                ),
                onPressed: () {})
          ],
        );
      },
    );
  }

  Widget _buildSelectionOptions(dispensaries) {
    var sponsoredDispensaries =
        dispensaries.where((e) => e.sponsored == 'Yes').toList();

    var _newLocations =
        dispensaries.where((e) => e.newDispensary == true).toList();

    sponsored = sponsoredDispensaries;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _sponsoredDispensary(sponsoredDispensaries),
                _buildCoupon(),
                _newDispensaries(_newLocations),
                _categorySelection(),
                _buildVendors(currentDispensaries),
                userProfile != null
                    ? _buildLikedProducts(userProfile.likedProducts)
                    : Container(),
                // userProfile != null && userProfile.likedDispensaries.length > 0
                //     ? _buildLikedDispensary(userProfile.likedDispensaries)
                //     : Container()
              ]),
        ));
  }

  Widget _sponsoredDispensary(dispensaries) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Text(
                'Check Out Our Buddies!',
                style: TextStyle(
                    fontFamily: 'Poppins', color: buddiesPurple, fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 15.0),
            height: screenAwareSize(250, context),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dispensaries.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    _navigtorFunc(dispensaries[i], context);
                  },

                  //Time issue
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            width: screenAwareSize(200, context),
                            height: screenAwareSize(150, context),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: dispensaries != null
                                      ? NetworkImage(
                                          dispensaries[i].dispensaryPhoto,
                                        )
                                      : CircularProgressIndicator()),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            dispensaries[i].name,
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: buddiesPurple,
                                fontFamily: 'Poppins',
                                fontSize: 22),
                          ),
                          Text(
                            '${dispensaries[i].address}',
                            style: TextStyle(
                                color: buddiesPurple,
                                fontFamily: 'Roboto-Regular',
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildCoupon() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RaisedButton(
        color: Colors.orange[300],
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () {
          _showDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(FontAwesomeIcons.tag, color: buddiesGreen),
                radius: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Hey Bud, Here Is A Discount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    )),
                Text(
                  'Take 10% Off Your Next Order',
                  style: TextStyle(
                      fontFamily: 'Roboto-Regular', color: Colors.white),
                )
              ],
            ),
            Icon(FontAwesomeIcons.angleRight, color: Colors.white)
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: new Text(
            "You Get An 10% Off Your Next Full Order",
            style: TextStyle(fontFamily: 'Poppins', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            "When You Take A Selfie With Your Purchase And @ Us On Social Media!",
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

  Widget _categorySelection() {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 8.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Speciality Shops',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        MaterialButton(
                          color: buddiesGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/SearchPage');
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10.0, left: 15.0),
                      height: screenAwareSize(200, context),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage(
                                          selectedCategory:
                                              dispensarySearchCategories[i])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Stack(children: [
                                Container(
                                  width: screenAwareSize(175, context),
                                  height: screenAwareSize(115, context),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(categoryPhotos[i]),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenAwareSize(175, context),
                                  height: screenAwareSize(115, context),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: Center(
                                    child: Text(dispensarySearchCategories[i],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                screenAwareSize(20, context))),
                                  ),
                                )
                              ]),
                            ),
                          );
                        },
                      ))
                ])));
  }

  Widget _buildVendors(dispensaries) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Delivering Near You',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10.0, left: 15.0),
                      height: screenAwareSize(200, context),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: dispensaries.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final dispensary = dispensaries[i];

                          return InkWell(
                            onTap: () {
                              CartProvider.of(context)
                                  .setDispensary(dispensary);
                              _navigtorFunc(dispensary, context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Column(children: <Widget>[
                                Container(
                                  width: 175,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          dispensary.dispensaryPhoto),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        dispensary.name,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: buddiesPurple,
                                            fontFamily: 'Poppins',
                                            fontSize: 22),
                                      ),
                                      Text(
                                        '${dispensary.address}',
                                        style: TextStyle(
                                            color: buddiesPurple,
                                            fontFamily: 'Roboto-Regular',
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      ))
                ])));
  }

  Widget _newDispensaries(_newLocations) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Newest Buddies',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  _newLocations != null
                      ? Container(
                          padding: EdgeInsets.only(top: 10.0, left: 15.0),
                          height: screenAwareSize(200, context),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: _newLocations.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final dispensary = _newLocations[i];

                              return InkWell(
                                onTap: () {
                                  CartProvider.of(context)
                                      .setDispensary(dispensary);
                                  _navigtorFunc(dispensary, context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 28.0),
                                  child: Column(children: <Widget>[
                                    Container(
                                      width: 175,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              dispensary.dispensaryPhoto),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            dispensary.name,
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: buddiesPurple,
                                                fontFamily: 'Poppins',
                                                fontSize: 22),
                                          ),
                                          Text(
                                            '${dispensary.address}',
                                            style: TextStyle(
                                                color: buddiesPurple,
                                                fontFamily: 'Roboto-Regular',
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ))
                      : CircularProgressIndicator(),
                ])));
  }

  _buildLikedProducts(_recProducts) {
    return userProfile.likedProducts.length > 0
        ? Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Text(
                          'My Likes',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20.0, left: 15.0),
                          height: screenAwareSize(225, context),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: _recProducts.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final prodDetails = _recProducts[i];
                              return GestureDetector(
                                onTap: () {
                                  _productReroute(prodDetails, context,
                                      prodDetails.dispensaryId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 28.0),
                                  child: Stack(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: screenAwareSize(125, context),
                                          height: screenAwareSize(100, context),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              image: DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.dst),
                                                  fit: BoxFit.fill,
                                                  image: prodDetails != null
                                                      ? NetworkImage(
                                                          prodDetails.image,
                                                          scale: 4)
                                                      : CircularProgressIndicator(
                                                          value: 4,
                                                          strokeWidth: 4,
                                                        ))),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              prodDetails.name,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: buddiesPurple),
                                            ),
                                          ],
                                        ),
                                        prodDetails.quantity == 0
                                            ? Row(
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.fire,
                                                    size: screenAwareSize(
                                                        16, context),
                                                    color: buddiesYellow,
                                                  ),
                                                  Text(
                                                    'Out Of Stock',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Roboto-Regular',
                                                        fontSize: 12,
                                                        color: buddiesPurple),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        Text(
                                          'Best For: ' + prodDetails.usage,
                                          style: TextStyle(
                                              fontFamily: 'Roboto-Regular',
                                              fontSize: 16),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.cannabis,
                                              color: prodDetails.productType ==
                                                      'sativa'
                                                  ? buddiesPurple
                                                  : Colors.red,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Feels : ' + prodDetails.effect,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        StarRating(
                                          size: 15.0,
                                          rating: rating,
                                          color: Colors.orange,
                                          borderColor: Colors.grey,
                                          starCount: starCount,
                                          onRatingChanged: (rating) => setState(
                                            () {
                                              this.rating = rating;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ))
                    ])))
        : Container();
  }

  _buildLikedDispensary(_recProducts) {
    return userProfile.likedProducts.length > 0
        ? Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Text(
                          'Fav Dispensaries',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20.0, left: 15.0),
                          height: screenAwareSize(225, context),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: _recProducts.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final prodDetails = _recProducts[i];
                              return GestureDetector(
                                onTap: () {
                                  _dispensaryReroute(context, prodDetails.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 28.0),
                                  child: Stack(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: screenAwareSize(125, context),
                                          height: screenAwareSize(100, context),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              image: DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.dst),
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      prodDetails
                                                          .dispensaryPhoto,
                                                      scale: 4))),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              prodDetails.name,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: buddiesPurple),
                                            ),
                                          ],
                                        ),
                                        StarRating(
                                          size: 15.0,
                                          rating: rating,
                                          color: Colors.orange,
                                          borderColor: Colors.grey,
                                          starCount: starCount,
                                          onRatingChanged: (rating) => setState(
                                            () {
                                              this.rating = rating;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ))
                    ])))
        : Container();
  }

  // Back Page

  void _createMarkers(currentDispensaries) async {
    print('Making markers');
    for (int i = 0; i < currentDispensaries.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(
          currentDispensaries[i].name,
        ),
        icon: pinLocationIcon,
        position:
            LatLng(currentDispensaries[i].lat, currentDispensaries[i].lng),
        infoWindow: InfoWindow(
            title: currentDispensaries[i].name,
            snippet: '15 Min Wait',
            onTap: () {
              _navigtorFunc(currentDispensaries[i], context);
            }),
      ));
    }
  }

  Widget searchList(BuildContext context, dispensaries) {
    return Scaffold(
      key: _mapScaffold,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8,
        backgroundColor: buddiesGreen,
        title: buddiesLogo,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.list,
              color: Colors.white,
            ),
            onPressed: () {
              _flip(false);
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.searchLocation,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _bottomSheet(
            context,
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Positioned(
      top: _bottomSheetCurvedAnimation.value,
      child: GestureDetector(
        onTap: () {
          _bottomSheetAnimationController.isCompleted
              ? reverseAnimation()
              : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //Upward Drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            reverseAnimation();
          } else {
            return;
          }
        },
        child: _sheetContainer(),
      ),
    );
  }

  Widget _sheetContainer() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Padding(
              padding: const EdgeInsets.all(9.0),
              child: currentDispensaries != null
                  ? showLocation(currentDispensaries)
                  : CircularProgressIndicator()),
        ],
      ),
    );
  }

  showLocation(currentDispensaries) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Title(
                      color: Colors.black,
                      child: Text(
                        '${currentDispensaries.length} Shops Delivering Near You',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: buddiesPurple),
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 2,
            ),
          ),
          currentDispensaries != null
              ? _buildList(context, currentDispensaries)
              : CircularProgressIndicator(),
          // _zoomminusfunction(),
          // _zoomplusfunction()
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    // filterMarker(currentDispensaries, 20);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(40.69896, -73.98666), zoom: 12, tilt: 10),
        onMapCreated: googleMapCreate,
        markers: _markers,
      ),
    );
  }

  void googleMapCreate(controller) {
    setState(() {
      mapController = controller;
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(userLat, userLong), tilt: 10, zoom: 10, bearing: 2)));
    });
  }

  // Bottom Sheet location details
  Widget _locations(_name, _address, dispensaryImage, dispensaries, ratings) {
    return InkWell(
      onTap: () {
        CartProvider.of(context).setDispensary(dispensaries);
        _navigtorFunc(dispensaries, context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: screenAwareSize(100, context),
            height: screenAwareSize(80, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                image: DecorationImage(
                    image: NetworkImage(dispensaryImage), fit: BoxFit.fill)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenAwareSize(12, context),
                    fontWeight: FontWeight.bold,
                    color: buddiesPurple),
              ),
              Container(
                width: screenAwareSize(100, context),
                child: Text(
                  _address,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
              ),
              StarRating(
                size: screenAwareSize(16, context),
                rating: ratings,
                color: Colors.orange,
                borderColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, dispensaries) {
    return Container(
      height: screenAwareSize(400, context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: dispensaries.length,
            itemBuilder: (
              context,
              int index,
            ) {
              return Column(
                children: <Widget>[
                  _locations(
                      '${dispensaries[index].name}',
                      '${dispensaries[index].address}',
                      '${dispensaries[index].dispensaryPhoto}',
                      dispensaries[index],
                      dispensaries[index].rating),
                  Divider(
                    endIndent: 100,
                    indent: 100,
                    height: 2,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }),
      ),
    );
  }

  void _navigtorFunc(dispensary, context) {
    if (hasProfile == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DispensaryHome(
                    dispensary: dispensary,
                  )));
    } else {
      _noProfilePopup();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ProfileDetails()));
    }
  }

  void _productReroute(product, context, dispensary) {
    if (hasProfile == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectedProduct(
                    product: product,
                    dispensary: dispensary,
                  )));
      setState(() {
        fromPreRec = true;
      });
    } else {
      _noProfilePopup();
    }
  }

  void _dispensaryReroute(context, dispensary) {
    if (hasProfile == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DispensaryHome(
                    dispensary: dispensary,
                  )));
      setState(() {
        fromPreRec = true;
      });
    } else {
      _noProfilePopup();
    }
  }
}

class DataSearch extends SearchDelegate<String> {
  DataSearch();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(FontAwesomeIcons.backspace),
          onPressed: () {
            query = "";
          })
    ];
    //Navigate with data
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Build icon
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  Widget buildResults(BuildContext context) {
    // return
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? sponsored
        : currentDispensaries
            .where((p) => p.name.toLowerCase().startsWith(query) ? true : false)
            .toList();

    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
          leading: Icon(FontAwesomeIcons.cannabis),
          title: GestureDetector(
            onTap: () {
              final dispensary = suggestionList[i];
              CartProvider.of(context).setDispensary(dispensary);
              _navigtorFunc(dispensary, context);
            },
            child: Text(suggestionList[i].name,
                style: TextStyle(
                  color: Colors.grey,
                )),
          )),
      itemCount: suggestionList.length,
    );
  }

  void _navigtorFunc(dispensary, context) {
    if (hasProfile == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DispensaryHome(
                    dispensary: dispensary,
                  )));
    } else {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ProfileDetails()));
    }
  }
}
