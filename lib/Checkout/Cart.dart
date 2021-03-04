import 'dart:math';
import 'package:Buddies/Checkout/Checkout.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/DispensaryHomePage/DispensaryHome.dart';
import 'package:Buddies/DispensaryPages/SelectedProductPage/SelectedProduct.dart';

import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CartDetails.dart';
import 'CartProvider.dart';

class CartPage extends StatefulWidget {
  @override
  State createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  double cartTotal = 0;
  bool orderMin = false;
  double minOrderNumber = 25.00;

  //Build Cart Data
  Random random = new Random();
  int index = 0;

  var recommendationList;

  @override
  void initState() {
    getCartTotal();
    print('Is the Cart Filled $cartEmpty');

    super.initState();

    checkCart();
  }

  int starCount = 5;
  double rating = 4.5;

  void getCartTotal() {
    final cart = CartProvider.of(context);
    if (userCart != null) {
      cartTotal = 0;

      for (int i = 0; i < cart.orderDetails.length; i++) {
        setState(() {
          cartTotal +=
              (cart.orderDetails[i].price * cart.orderDetails[i].quantity);
        });

        print('There are ${cart.orderDetails.length} many items in the cart');
        minReached(cartTotal);
      }
    }
    // checkCart(cartTotal);
  }

  void checkCart() {
    if (userCart != null) {
      cartEmpty = true;
    } else {
      cartEmpty = false;
    }
  }

  void minReached(cartTotal) {
    setState(() {
      if (cartTotal >= minOrderNumber) {
        orderMin = true;
        print('Has the minumum order been reached: $orderMin');
      } else {
        orderMin = false;

        print('the min has not been reached');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cartEmpty == false ? _noConnection(context) : _cartHome(context),
    );
  }

  Widget _noConnection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Bud Yet...',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: screenAwareSize(16, context)),
          ),
          Image.asset(
            'assets/emptyCart.png',
            height: screenAwareSize(140, context),
            width: screenAwareSize(100, context),
          )
        ],
      ),
    );
  }

  Widget _cartHome(BuildContext context) {
    final cart = userCart;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: buddiesGreen,
        bottomOpacity: .2,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.trash,
              size: screenAwareSize(14, context),
            ),
            onPressed: () {
              clearoutCart();
            }),
        actions: <Widget>[
          Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderMin
                      ? IconButton(
                          icon: Icon(FontAwesomeIcons.shoppingBasket),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Checkout(cartTotal: cartTotal)));
                          })
                      : IconButton(
                          icon: Icon(FontAwesomeIcons.shoppingBasket),
                          color: Colors.white,
                          onPressed: () {})),
              Positioned(
                top: 40,
                left: 12,
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Roboto-Regular',
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            _cartheader(cart),
            Divider(
              height: .5,
            ),
            Expanded(
              child: Container(
                // height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.orderDetails.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Container(
                      child: Column(
                        children: <Widget>[_products(cart, i)],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Divider(
            //     height: 5,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 18.0),
            //   child: _recommendationSheet(),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                child: orderMin
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 8,
                          color: buddiesGreen,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Checkout(cartTotal: '${cartTotal}')));
                          },
                          child: Container(
                              child: Center(
                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                '',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 14),
                              ),
                              Text(
                                'Checkout',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              Text(
                                '\$${cartTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                        ),
                      )
                    : MaterialButton(
                        disabledColor: buddiesSecondaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 8,
                        onPressed: () {}),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cartheader(currentOrder) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DispensaryHome(
                                  dispensary: currentOrder.dispensary,
                                ))).then((value) {});
                  },
                  child: CircleAvatar(
                    radius: screenAwareSize(30, context),
                    backgroundImage: NetworkImage(currentOrder.dispensaryImage),
                  ),
                ),
                Column(
                  children: <Widget>[
                    currentOrder != null
                        ? Text(
                            currentOrder.dispensary.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              color: buddiesPurple,
                            ),
                          )
                        : Text(
                            '',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: buddiesPurple,
                            ),
                          ),
                    Text(
                      'Expected Time: 25 Mins',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
                    )
                  ],
                ),
                Text(
                  "\$${cartTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: buddiesPurple,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderMin
                      ? Text('You Have Reached The Minimum Order of \$25.00')
                      : Text('Order Minimum Has Not Been Reached.'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _products(userCart, i) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(
                      userCart.orderDetails[i].product.image,
                    ),
                    fit: BoxFit.cover)),
          ),
          Counter(
            color: Colors.white,
            textStyle: TextStyle(
                fontFamily: 'Poppins',
                color: buddiesPurple,
                fontSize: screenAwareSize(14, context)),
            buttonSize: screenAwareSize(20, context),
            // heroTagDecrease: '${cart.orders}+2 ${'cart.productName'}'[i],
            // heroTagIncrease: '${cart.dispensaryId}+ 3${'cart.orders'}'[i],
            minValue: 1,
            maxValue: 10,
            step: 1,
            decimalPlaces: 0,
            initialValue: userCart.orderDetails[i].quantity,
            onChanged: (num val) {
              setState(() {
                userCart.orderDetails[i].quantity = val;
                getCartTotal();
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: screenAwareSize(150, context),
                child: Text(
                  userCart.orderDetails[i].product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenAwareSize(12, context),
                    color: buddiesPurple,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: screenAwareSize(20, context),
                  ),
                  Text(
                    '\$${userCart.orderDetails[i].price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w700,
                        fontSize: screenAwareSize(10, context)),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteItem(userCart, cartTotal, i);
                    },
                    icon: Icon(FontAwesomeIcons.trash),
                    iconSize: 10,
                  ),
                  Text(
                    'Remove',
                    style:
                        TextStyle(fontFamily: 'Roboto-Regular', fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendationSheet() {
    //Add
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Other Buddies Also Bought:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: buddiesPurple,
                  ),
                ),
              ],
            ),
            _productSuggestions(),
          ],
        ),
      ),
    );
  }

  _productSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recommendedProducts.length,
            itemBuilder: (context, i) {
              return Stack(children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectedProduct(
                                      product: recommendedProducts[i],
                                      dispensary: userCart.dispensary,
                                    )));
                      },
                      child: Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  recommendedProducts[i].image,
                                ),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    Container(
                      width: screenAwareSize(100, context),
                      child: Text(
                        recommendedProducts[i].name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: buddiesPurple,
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 5,
                    child: Icon(
                      FontAwesomeIcons.plusCircle,
                      size: 12,
                      color: Colors.green,
                    ))
              ]);
            },
          ),
        ),
      ),
    );
  }

  void clearoutCart() {
    _emptyCart('Clear my cart', 'are you sure you want to clear the cart?');
  }

  void deleteItem(
    cart,
    cartTotal,
    i,
  ) {
    setState(() {
      cartTotal = cartTotal - cart.orderDetails[i].price;

      cart.orderDetails.removeAt(i);
      print('There are ${cart.orderDetails.length} many items in the cart');
    });
    minReached(cartTotal);

    if (cart.orderDetails.length == 0) {
      Navigator.pushReplacementNamed(context, '/bottomBar');
    } else {}
  }

  void addItem(
    cart,
    cartTotal,
    i,
  ) {
    setState(() {
      cartTotal = cartTotal + cart.orderDetails[i].price;

      print(
          'You added ${cart.orderDetails[i].quantity} more ${cart.orderDetails[i].product.name} to the cart');
    });
    getCartTotal();
  }

  void _emptyCart(
    title,
    content,
  ) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            title: Row(
              children: <Widget>[
                Image.asset(
                  'assets/smiley.png',
                  height: screenAwareSize(50, context),
                  width: screenAwareSize(50, context),
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  width: screenAwareSize(150, context),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            content: Text(content, textAlign: TextAlign.center),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'clear it out',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  final cart = CartProvider.of(context);

                  setState(() {
                    cartTotal = 0;
                    cartEmpty = true;
                    cart.orderDetails.clear();
                  });
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/bottomBar');
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'take me back',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
