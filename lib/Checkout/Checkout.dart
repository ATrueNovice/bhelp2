import 'dart:math';

import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/BottomBar/bottombar.dart';
import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/widgets/helpers/BuddiesAlerts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Buddies/Checkout/CartDetails.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

import '../Constants/Static_string.dart';
import 'CartProvider.dart';
import 'Squarehelper/Config.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: PLACES_API_KEY);

class Checkout extends StatefulWidget {
  final dynamic cartTotal;
  dynamic currentCart;

  Checkout({this.cartTotal, this.currentCart});
  @override
  _CheckoutState createState() => _CheckoutState(cartTotal);
}

class _CheckoutState extends State<Checkout> {
  dynamic cartTotal;
  int _paymentCounter = 0;
  String _paymentType = '';
  String _paymentDetails = '';
  int currentSizeIndex = 0;
  String _address;

  String tempText;
  String _couponCode = '';
  var _validCouponData = '';
  final _couponFocusNode = FocusNode();
  TextEditingController _couponController = TextEditingController();
  int sharedValue = 0;
  int _shippingIconNum = 0;
  double myCart;
  //Address
  var userAddress;
  var _totalNumber;
  var nonce = '';

  var address, address2, city, state, zip, fname, lname;

  String textA;
  String textB;
  TextStyle receiptStyle = TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 14,
      color: buddiesPurple,
      fontWeight: FontWeight.w700);

  Text _addCard = Text(
    'Do You Want To Store This Card On File',
    style: TextStyle(
        fontFamily: 'Roboto-Regular', fontSize: 14, color: buddiesPurple),
  );

//Keys

  List _shippingIndicatorIcons = [
    Container(
      child: Icon(
        FontAwesomeIcons.car,
        color: buddiesGreen,
        size: 25,
      ),
    ),
    Container(
      child: Icon(
        FontAwesomeIcons.box,
        color: buddiesGreen,
        size: 25,
      ),
    ),
  ];

  List _shippingOptions = [
    'Deliver To:',
    'Mail To:',
  ];

  List _shippingAddressMessage = [
    Text('Need Delivery\n On The Go?',
        softWrap: true, textAlign: TextAlign.center, style: titleStyle),
    Text('Delivery Address Updated',
        softWrap: true, textAlign: TextAlign.center, style: titleStyle),
  ];

  List _orderText = [
    Text('Add Card',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
    Text('SUBMIT ORDER',
        style:
            TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white))
  ];

  List _couponOptions = [
    Text('Enter Coupon',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: buddiesPurple)),
    Text('Coupon Applied',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: buddiesPurple))
  ];

  bool vaildForm = false;

  List _options = ['DOOR', 'DROP OFF'];

  //Address

  _CheckoutState(this.cartTotal);

  void _squarePay() {
    InAppPayments.setSquareApplicationId(squareApplicationId);
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,
    );
  }

  void _cardEntryCancel() {}

  void _cardNonceRequestSuccess(CardDetails result) {
    print('Testing nonce');

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );

    setState(() {
      nonce = result.nonce;
    });

    //Add Nonce Pop Up
    print(result.nonce);
  }

  void _uploadCardData(
      address, address2, city, state, zip, fname, lname, noonce) {
    print('uploading card data');

    // addSquarePaymentMethod(
    //     userProfile.address,
    //     '',
    //     userProfile.city,
    //     userProfile.state,
    //     userProfile.zipCode,
    //     userProfile.split(" ")[0],
    //     userProfile.split(" ")[1],
    //     nonce);
    // BuddiesAlertWidget().twoButtonPopup(
    //     'context',
    //     _addCard,
    //     addCard(
    //         userProfile.address,
    //         '',
    //         userProfile.city,
    //         userProfile.state,
    //         userProfile.zipCode,
    //         userProfile.split(" ")[0],
    //         userProfile.split(" ")[1],
    //         nonce));
  }

  void _cardEntryComplete() {
    squareTwoButtonPopup(
      context,
      Text('Add New Card To Profile?'),
    );
  }

  void _updateUserCard(
      address, address2, city, state, zip, fname, lname, noonce) {
    Map<String, dynamic> _cardData = {
      "address": address,
      "address2": address2,
      "city": city,
      "state": state,
      "zip_code": zip,
      "first_name": fname,
      "last_name": lname,
      "card_noonce": noonce
    };

    addSquarePaymentMethod(_cardData);
  }

  void squareTwoButtonPopup(context, content) {
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
              onPressed: () {
                _updateUserCard(
                    userProfile.address,
                    '',
                    userProfile.city,
                    userProfile.state,
                    userProfile.zip,
                    userProfile.name.split(" ")[0],
                    userProfile.name.split(" ")[1],
                    nonce);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _getZip() {
    state = userProfile.state;
    zip = userProfile.zip;
  }

  void cartCheck() {
    final cart = CartProvider.of(context);

    if (cart.orderDetails == null) {
      Navigator.pop(context);
    }
  }

  void _dispensaryType() {
    var options = userCart.dispensary.shippingMethod == 'Drop';

    if (options == true) {
      _shippingIconNum = 0;
    } else {
      _shippingIconNum = 1;
    }
  }

  void _getShippingIndicator() {
    switch (userCart.dispensary.shippingMethod) {
      case 'Standard':
        _shippingIconNum = 0;
        break;
      case 'Drop':
        _shippingIconNum = 1;
        break;

      default:
    }
  }

  @override
  void initState() {
    _profileCheck();
    cartCheck();
    _getZip();
    _totalNumber = cartTotal;
    _getShippingIndicator();
    _getRate();
    _totalCart();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context).orderDetails;
    final cartOrder = CartProvider.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: buddiesGreen,
        elevation: 8.0,
        title: Text('Checkout',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _topHeader(context, cart),
                _shippingIconNum == 0 ? _dropSelection() : Container(),
                Expanded(flex: 2, child: _deliveryWidget(context)),
                Expanded(flex: 2, child: _couponPopup(cart)),
                Expanded(flex: 2, child: _totalBill(context, cart)),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: screenAwareSize(60, context),
                      width: MediaQuery.of(context).size.width / 2,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 8,
                        color: nonce == "" ? Colors.white : buddiesGreen,
                        onPressed: () {
                          nonce != ""
                              ? checkOrder(
                                  stripeToken,
                                  userCart.dispensary.id,
                                  userCart.orders.toList(),
                                  _address != null
                                      ? _address
                                      : userProfile.address,
                                  _options[sharedValue],
                                  _couponCode,
                                  nonce)
                              : _squarePay();
                        },
                        child: Center(
                            child: nonce == ""
                                ? Text(
                                    'Pay With Square',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: buddiesPurple),
                                  )
                                : Text(
                                    'Submit Order',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.white),
                                  )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shippingIndicator() {
    return Container(child: _shippingIndicatorIcons[_shippingIconNum]);
  }

  void _getRate() {
    final cartOrder = CartProvider.of(context);

    getShippingRate(userCart.dispensary.id, userCart.orders.toList())
        .then((value) {
      print('Printing rate');
      print(value);
      print('test=');
    });
  }

  Widget _couponPopup(cart) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            couponData == ""
                ? Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Have A Discount Code?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: buddiesPurple),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            elevation: 8,
                            color: buddiesGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            onPressed: () {
                              _showCoupon();
                            },
                            child: Text(
                              'Add DiscountCode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ))
                    ]),
                  )
                : Column(
                    children: [
                      _couponCode == "" ? _couponOptions[0] : _couponOptions[1],
                      SizedBox(
                        height: 20,
                      ),

                      // Text('Take ${_validCouponData.amount}% off all ' +
                      //             _validCouponData.categories !=
                      //         null
                      //     ? ' ${_validCouponData[0].categories} products'
                      //     : '${_validCouponData[0].categories} products'),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          elevation: 8,
                          color: buddiesGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            _showCoupon();
                          },
                          child: Text(
                            'Change Coupon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
            Column(
              children: <Widget>[
                _address == null
                    ? _shippingAddressMessage[0]
                    : _shippingAddressMessage[1],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      elevation: 8,
                      color: buddiesGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () {
                        _getAddress();
                      },
                      child: Text(
                        'Edit Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ]),
    );
  }

  void _showCoupon() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            'Enter Your Coupon',
            style: TextStyle(fontFamily: 'Poppins', color: buddiesPurple),
            textAlign: TextAlign.center,
          ),
          content: _couponTextField(),
          actions: <Widget>[
            FlatButton(
                color: buddiesGreen,
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                color: buddiesGreen,
                child: Text("Apply"),
                onPressed: () {
                  checkingCoupon(userCart.dispensary.id, _couponCode);

                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Widget _couponTextField() {
    return Container(
        width: screenAwareSize(175, context),
        child: TextFormField(
            focusNode: _couponFocusNode,
            controller: _couponController,
            keyboardType: TextInputType.text,
            maxLength: 20,
            maxLengthEnforced: true,
            obscureText: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
                icon: Icon(
                  FontAwesomeIcons.cannabis,
                  color: buddiesYellow,
                  size: screenAwareSize(20, context),
                ),
                hintText: "Enter Your Coupon",
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenAwareSize(10.0, context),
                    horizontal: screenAwareSize(10.0, context)),
                fillColor: Colors.transparent,
                filled: true),
            validator: (String value) {
              if (value.isEmpty) {
                return '';
              }
            },
            onChanged: (String value) {
              _couponCode = value.replaceAll(' ', '');
            }));
  }

  Future<void> checkOrder(stripeToken, disId, orders, address, deliveryType,
      couponCode, nonce) async {
    await createOrder(stripeToken, disId, orders, address, deliveryType,
            couponCode, nonce)
        .whenComplete(() {
      _checkOrderPlaced(orderPlaced);
    });
  }

  void _checkOrderPlaced(orderPlaced) {
    if (orderPlaced == true) {
      _orderSegue(orderPlaced);
    } else {
      popupSwitch(orderError);
      // print('Error Order Not Placed');
    }
  }

  void _orderSegue(bool isLoggedIn) {
    setState(() {
      if (isLoggedIn == true) {
        Future.delayed(
            Duration(
              seconds: 2,
            ), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomBarController()));

          _popShow(_successfulOrderWidget());
          clearCart();
          orderPlaced = false;
        });
      } else {}
    });
  }

  Widget _topHeader(BuildContext context, cart) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      // height: screenAwareSize(140, context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              '${cart.length} Item(s)',
              style: receiptStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _headerImages(cart),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerImages(cart) {
    return Container(
      height: screenAwareSize(120, context),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cart.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20, top: 5),
        itemBuilder: (context, i) {
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    width: screenAwareSize(70, context),
                    height: screenAwareSize(85, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(
                            cart[i].product.image,
                          ),
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${cart[i].quantity}x ${cart[i].product.name} \n\$${cart[i].price}',
                    textAlign: TextAlign.center,
                    style: receiptStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _deliveryWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _shippingIndicator(),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: screenAwareSize(200, context),
                      child: Text(
                          _address == null
                              ? '${_shippingOptions[_shippingIconNum]} \n${userProfile.address}'
                              : _address,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: titleStyle),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
//TOTAL CALCULATION

  Future<void> checkingCoupon(disId, couponCode) async {
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
    print(couponCode);

    checkCoupon(couponCode, disId).then((couponData) {
      print('Checking the Coupon');
      if (couponData != null) {
        _applyCoupon(couponData);
      } else {
        print('No active Coupon');

        BuddiesAlertWidgets().single(context, Text('No Active coupon'));
      }
    });
  }

  void _applyCoupon(couponData) {
    bool matchingCategories = false;
    bool matchingProducts = false;

    // _validCouponData = couponData;
    // print(_validCouponData);

    print('New total $_totalNumber');

    for (int i = 0; i < userCart.orderDetails.length; i++) {
      print('testing array');
      if (couponData.validCategories
          .contains(userCart.orderDetails[i].product.productCategory)) {
        print('Matching Valid Categories');
        matchingCategories = couponData.validCategories
            .contains((userCart.orderDetails[i].product.productCategory));
        print(matchingCategories.toString());

        print('Matching products');

        setState(() {
          userCart.orderDetails[i].price =
              userCart.orderDetails[i].price * (couponData.amount);
          print(_totalNumber);
        });
        _totalCart();

        // updateCartTotal(couponData.amount, i);
        // updateCartTotal(cart[i].price, i);
      } else {
        print('No valid categories');
      }

      if (couponData.validProducts
          .contains((userCart.orderDetails[i].product.id))) {
        print('Matching product id');
        matchingProducts = couponData.validProducts
            .contains((userCart.orderDetails[i].product.id));
        print(couponData.validProducts
            .contains((userCart.orderDetails[i].product.id)));

        setState(() {
          userCart.orderDetails[i].price =
              userCart.orderDetails[i].price * (couponData.amount);
          print(_totalNumber);
        });
        _totalCart();

        // getCartTotal();
        // updateCartTotal(couponData.amount, i);
      } else {
        print('No matching product id');
      }
      print('New total $_totalNumber');
    }
  }

  void getCartTotal() {
    final cart = CartProvider.of(context);
    if (userCart != null) {
      cartTotal = 0;

      for (int i = 0; i < cart.orderDetails.length; i++) {
        setState(() {
          cartTotal +=
              (cart.orderDetails[i].price * cart.orderDetails[i].quantity);
        });

        print('Updated cart total');
      }
    }
  }

  void updateCartTotal(amount, index) {
    setState(() {
      userCart.orderDetails[index].price =
          userCart.orderDetails[index].price * amount;
    });

    getCartTotal();
  }

  void _totalCart() {
    // var fee = userCart.dispensary.deliveryFee;
    // assert(fee is double);
    var tx = (userCart.dispensary.deliveryFee +
        double.parse(cartTotal) * userCart.dispensary.taxRate);
    var tempCart =
        (userCart.dispensary.deliveryFee + double.parse(cartTotal) + tx);
    myCart = dp(tempCart, 2);
    getCartTotal();
    print(myCart);
  }

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Widget _totalBill(BuildContext context, cart) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          children: <Widget>[
            //Order detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // Text('data'),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Delivery Fee',
                      style: receiptStyle,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'State Tax',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Discount Applied',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '\$${userCart.dispensary.deliveryFee}',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${userCart.dispensary.taxRate * 100}%',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      couponData != null
                          ? ' ${couponData.code.toUpperCase()} applied! ${couponData.amount * 100}0% off! '
                          : '',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Check For Devices variations here
                  Text(
                    'Total',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: buddiesPurple,
                        fontSize: screenAwareSize(12, context)),
                  ),
                  Text(
                    '\$$cartTotal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: buddiesPurple,
                    ),
                  )
                ],
              ),
            ),
            squareData != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Card Ending In:'),
                      Text(squareData.customer.cards[0].last4),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _popShow(
    widget,
  ) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.white.withOpacity(.95),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Container(
              height: screenAwareSize(300, context),
              child: Column(children: [
                Expanded(flex: 3, child: _dialogHeader()),
                Expanded(flex: 7, child: widget)
              ]),
            ));
      },
    );
  }

  Widget _dialogHeader() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/smiley.png',
                  height: screenAwareSize(65, context),
                  width: screenAwareSize(65, context),
                  fit: BoxFit.fitWidth,
                ),
                Container(
                    child: Text(
                  'Checkout Complete!',
                  style: TextStyle(
                      color: buddiesPurple,
                      fontFamily: 'Poppins',
                      fontSize: 18),
                ))
              ],
            ),
          ),
        ),
      ])),
    );
  }

  void clearCart() {
    final cart = CartProvider.of(context);
    // print('The Cart has ${itemCart.orderDetails[0]}');
    // cart.orders = [];
    // userCart.orders = [];
    cart.orderDetails = [];
    userCart.orderDetails = [];
    // print('The Cart has ${itemCart.orderDetails[0]}');
  }

  Widget _successfulOrderWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          _successfulOrderDetails()
        ]),
      ),
    );
  }

  Widget _successfulOrderDetails() {
    var now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              Text(
                DateFormat("MM-dd-yyyy hh:mm").format(now),
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dispensary',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              Text(
                '${userCart.dispensary.name}',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ],
          ),

          //Items

          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              Text(
                '$_paymentType ',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: buddiesPurple,
                    fontSize: screenAwareSize(12, context)),
              ),
              Text(
                '\$${cartTotal.toStringAsFixed(2)} ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: buddiesPurple,
                ),
              ),
            ],
          ),
          FlatButton(
              color: buddiesGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ))
        ],
      )),
    );
  }

  void popupSwitch(int value) {
    setState(() {
      switch (value) {
        case 0:
          textA = 'Something Went Wrong';
          textB = 'Could Not Complete Order';

          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'Hold Up Bud';
          textB = 'Your last order must be completed before placing a new one.';

          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Hold Up Bud';
          textB = 'Your last order must be completed before placing a new one.';

          _showPopup(textA, textB);
          break;
      }
    });
  }

  final Map<int, Widget> userDetailsSegment = <int, Widget>{
    0: Center(
      child: Text(
        'Front Door Drop Off',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
    1: Center(
      child: Text(
        'Contactless Delivery Drop Off',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
    2: Center(
      child: Text(
        'Curbside Pick Up',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  };

  Widget _dropSelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: CupertinoSlidingSegmentedControl(
          thumbColor: buddiesYellow,
          children: userDetailsSegment,
          onValueChanged: (val) {
            setState(() {
              sharedValue = val;
            });
          },
          groupValue: sharedValue,
        ),
      ),
    );
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
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  Future<void> _getAddress() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: PLACES_API_KEY,
        language: 'en',
        components: [Component(Component.country, 'usa')]);

    displayPrediction(p);
  }

  Future displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse place =
          await _places.getDetailsByPlaceId(p.placeId);

      setState(() {
        _address = place.result.formattedAddress.toString();
      });

      print(_address);
    }
  }

  void _profileCheck() {
    if (hasProfile == false) {
      print('User does not have a profile and will be redirected');
    } else {
      print('User has profile and can order');
    }
  }
}

mixin RadioModel {}
