import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/Checkout/CartDetails.dart';
import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/Model/DisNProducts.dart';
import 'package:Buddies/widgets/helpers/ImageGuard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:carousel_pro/carousel_pro.dart';

bool favorite = false;

class SelectedProduct extends StatefulWidget {
  @required
  final dynamic product;
  final dynamic dispensary;

  SelectedProduct({
    this.product,
    this.dispensary,
    dispensaryMenu,
  });
  @override
  State createState() => _SelectedProduct(product, dispensary);
}

class _SelectedProduct extends State<SelectedProduct> {
  dynamic product;
  dynamic dispensary;

  bool isExpanded = false;
  int currentSizeIndex = 0;
  int currentColorIndex = 0;

  _SelectedProduct(this.product, this.dispensary);

  @override
  void initState() {
    print(dispensary.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProductScreenTopPart(
                    product: product,
                  ),
                  ProductScreenBottomPart(
                    product: product,
                    dispensary: dispensary,
                  )
                ],
              ),
            )));
  }
}

class ProductScreenTopPart extends StatefulWidget {
  @required
  final dynamic product;

  ProductScreenTopPart({Key key, this.product}) : super(key: key);
  @override
  _ProductScreenTopPartState createState() =>
      _ProductScreenTopPartState(product);
}

class _ProductScreenTopPartState extends State<ProductScreenTopPart> {
  dynamic product;

  _ProductScreenTopPartState(this.product);
  var buttonColor;

  @override
  void initState() {
    _faveCheck();
    super.initState();
  }

  void _faveCheck() {
    print('starting check');
    var _faved = userProfile.likedProducts.where((e) => e.id == product.id);

    print(_faved);

    setState(() {
      if (_faved.isNotEmpty == true) {
        buttonColor = buddiesYellow;

        print("one of my faves");
      } else {
        buttonColor = buddiesGreen;

        print("Don't like it yet");
      }
    });
  }

  void _likedProduct(product) {
    if (buttonColor == buddiesGreen) {
      addLikes(product.id);
      setState(() {
        buttonColor = buddiesYellow;
      });
    } else {
      setState(() {
        buttonColor = buddiesGreen;
      });

      dislikeProduct(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: screenAwareSize(275.0, context),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  child: Carousel(
                animationDuration: Duration(milliseconds: 1000),
                dotSize: screenAwareSize(0, context),
                dotColor: Colors.transparent,
                indicatorBgPadding: 5,
                dotBgColor: Colors.transparent,
                animationCurve: Curves.easeIn,
                boxFit: BoxFit.fill,
                images: [
                  ImageGuard().imageGuard(product.image, BoxFit.fill),
                  ImageGuard().imageGuard(product.image2, BoxFit.fill),
                  ImageGuard().imageGuard(product.image3, BoxFit.fill)
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    // focusColor: buddiesSecondaryPurple,
                    icon: Icon(
                      FontAwesomeIcons.angleLeft,
                      color: buddiesGreen.withOpacity(.6),
                      size: 26,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //     bottom: screenAwareSize(20, context),
          //     left: screenAwareSize(5, context),
          //     child: FloatingActionButton(
          //       heroTag: "btn1",
          //       backgroundColor: buttonColor,
          //       child: Icon(
          //         FontAwesomeIcons.heart,
          //         color: Colors.white,
          //         size: screenAwareSize(20, context),
          //       ),
          //       mini: true,
          //       onPressed: () {
          //         _likedProduct(product);
          //       },
          //     )),
          // Positioned(
          //   bottom: screenAwareSize(15, context),
          //   right: screenAwareSize(5, context),
          //   child: FloatingActionButton(
          //     heroTag: "btn2d",
          //     backgroundColor: buddiesGreen.withOpacity(.7),
          //     child: Icon(
          //       FontAwesomeIcons.share,
          //       color: Colors.white,
          //     ),
          //     mini: true,
          //     onPressed: () {
          //       final RenderBox box = context.findRenderObject();
          //       Share.share(shareSubject,
          //           subject: 'I Want This' + product.name + 'From Buddies!',
          //           sharePositionOrigin:
          //               box.localToGlobal(Offset.zero) & box.size);
          //    },
          //  ),
        //  ),
        ],
      ),
    );
  }
}

class ProductScreenBottomPart extends StatefulWidget {
  @required
  final dynamic product;
  final dynamic dispensary;
  ProductScreenBottomPart({Key key, this.product, this.dispensary})
      : super(key: key);

  @override
  _ProductScreenBottomPartState createState() =>
      _ProductScreenBottomPartState(product, dispensary);
}

class _ProductScreenBottomPartState extends State<ProductScreenBottomPart> {
  _ProductScreenBottomPartState(this.product, this.dispensary);

  dynamic product;
  dynamic dispensary;

  bool isExpanded = false;
  int currentSizeIndex = 0;
  int currentColorIndex = 0;
  int cartVal = 1;
  String image;
  double total = 0.0;
  double price;
  Sizes productSizes;
  final List sizeList = [];
  bool hideAccessory = false;

  int selectorValue = 0;
  String address = "TEST";
  int selectedId;

  @override
  void initState() {
    // print('${product.sizes.toList}');
    _getSizes(product);

    print(selectedId = product.sizes[0].id);
    super.initState();
  }

  final Map<int, Widget> detailPage = <int, Widget>{
    0: Center(
      child: Text(
        'Description',
        style: TextStyle(
          fontFamily: "Roboto-Regular",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    1: Center(
      child: Text(
        ' Read The Label ',
        style: TextStyle(
          fontFamily: "Roboto-Regular",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  };
  Map<String, dynamic> _order = {'product_size': null, 'quantity': null};

  List<Order> orders;
//Dialog Screen

  var productData;
  int strainInfo;

  void _productDetailPopup(_productDetails) {
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
          content: _productDetails,
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

  //Product
  int prodDetail = 0;

  void _productDetail(value) {
    switch (value) {
      case "Flower":
        setState(() {
          prodDetail = 0;
        });

        break;
      case 'Concentrates':
        prodDetail = 1;

        break;
      case 'Dabs':
        prodDetail = 2;

        break;
      case 'Pets':
        prodDetail = 3;

        break;
      case 'Storage':
        prodDetail = 4;

        break;
      case 'Topicals':
        prodDetail = 5;

        break;
      case "Vaping":
        prodDetail = 6;

        break;
      case 'Home Setup':
        prodDetail = 7;

        break;
      case "Edibles":
        prodDetail = 8;
        break;
      case 'Pre-rolled':
        prodDetail = 9;

        break;
      case 'Bongs & Pipes':
        prodDetail = 10;

        break;
      default:
    }
    print(prodDetail);
  }

  void _strainDetail(value) {
    switch (value) {
      case 'hybrid':
        strainInfo = 0;

        break;
      case 'indica':
        strainInfo = 1;

        break;
      case 'sativa':
        strainInfo = 2;

        break;

      case 'Rigs':
        strainInfo = 3;

        break;
      case 'Carry Case':
        strainInfo = 4;

        break;
      case 'Pen':
        strainInfo = 5;

        break;
      case 'Cartridge':
        strainInfo = 6;
        break;
      case 'Bongs & Pipes':
        strainInfo = 7;

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
//  product.sizes = productSizes;
    _productDetail(product.productCategory);

//  print(' The ID is ${productSizes[0].id}');
    var mainStyle;
    final Map<int, Widget> segmentDetails = <int, Widget>{
      0: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text(product.shortDesc,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: buddiesPurple,
                    fontSize: screenAwareSize(14.0, context),
                  )),
            ),
          ),
        ],
      ),
      1: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Nutritional Facts',
                            style: TextStyle(
                              color: buddiesPurple,
                              fontSize: screenAwareSize(16.0, context),
                            )),
                        Row(
                          children: <Widget>[
                            Text(product.productCategory,
                                style: TextStyle(
                                  color: buddiesPurple,
                                  fontSize: screenAwareSize(16.0, context),
                                )),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.infoCircle),
                              iconSize: screenAwareSize(10, context),
                              onPressed: () {
                                _strainDetail(product.productType);
                                _productDetail(product.productCategory);
                                _productDetailPopup(_productDetails(context));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'THC',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'CBD',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'CBD Only',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Product Type',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Best For',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Feel(s)',
                              style: mainStyle,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${product.thcContent} mg/ml',
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${product.cbdContent} mg/ml',
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              product.thcContent == 0 ? 'Yes' : 'No',
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${product.usage}',
                              maxLines: 3,
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${product.productType[0].toUpperCase()}${product.productType.substring(1)}',
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${product.effect}',
                              style: mainStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ]))
    };
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: screenAwareSize(8.0, context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenAwareSize(18.0, context),
                    fontWeight: FontWeight.w600,
                    color: buddiesPurple),
              ),
            ),
            SizedBox(
              height: screenAwareSize(12.0, context),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: CupertinoSegmentedControl(
                  borderColor: Colors.white,
                  unselectedColor: Colors.white,
                  selectedColor: buddiesGreen,
                  children: detailPage,
                  groupValue: selectorValue,
                  onValueChanged: (changedFromGroupValue) {
                    setState(() {
                      selectorValue = changedFromGroupValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: screenAwareSize(8.0, context),
            ),
            Container(child: Center(child: segmentDetails[selectorValue])),

            SizedBox(
              height: 60,
            ),
            //Signed
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Quantity",
                    style: TextStyle(
                        color: buddiesPurple,
                        fontSize: screenAwareSize(16.0, context),
                        fontFamily: "Poppins")),
                SizedBox(
                  height: 10.0,
                ),
                hideAccessory == false ? _sizeWidget() : Container(),
                SizedBox(
                  height: 10.0,
                ),
            //    Center(
                //   child: Counter(
                //     color: Colors.white,
                //     textStyle: TextStyle(
                //         fontFamily: 'Poppins',
                //         color: buddiesPurple,
                //         fontSize: screenAwareSize(30, context)),
                //     buttonSize: screenAwareSize(40, context),

                //     increase: '${widget.product.image}1',
                //    decrease: '${widget.product.image2}2',
                //     minValue: 1,
                //     maxValue: 10,
                //     step: 1,
                //     decimalPlaces: 0,
                //     initialValue: cartVal,
                //     onChanged: (num val) {
                //       setState(() {
                //         cartVal = val;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: screenAwareSize(20, context),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: product.quantity != 0
                  ? MaterialButton(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: buddiesGreen,
                      height: screenAwareSize(40, context),
                      onPressed: () {
                        // print(userCart.total);
                        // _getRecommendations(product, product.productCategory);
                        price = product.sizes[currentSizeIndex].price * cartVal;
                        _getOrder(product.sizes[currentSizeIndex].id, cartVal);
                        final cart = CartProvider.of(context);
                        final cartModel = CartDetails.fromProduct(product,
                            cartVal, product.sizes[currentSizeIndex].price);
                        // _addProductButton(cart, cartModel, _order);

                        _cartCheck(cartModel, cart, _order);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(''),
                          Text(
                            'ADD TO CART',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                          Text(
                            '\$' +
                                ('${(product.sizes[currentSizeIndex].price * cartVal).toStringAsFixed(2)}'),
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
            SizedBox(
              height: screenAwareSize(20, context),
            )
          ],
        ));
  }

  Widget _addedConfirmation() {
    return Container(
        child: Text('Bud Is The Bag!',
            textAlign: TextAlign.center, style: secondaryParagraphStyle));
  }

  Widget _cartdDuplicate() {
    return Container(
        child: Text(
      'Swap Your Bud?\nYou Already Have Products From Another Dispensary.',
      textAlign: TextAlign.center,
      style: secondaryParagraphStyle,
    ));
  }

  void _cartCheck(cartModel, _cart, _order) {
    final cart = CartProvider.of(context);

    if (cart.dispensary.id == dispensary.id) {
      _addProductButton(_cart, cartModel, _order);

      _productDetailPopup(_addedConfirmation());
    } else {
      print('Adding new cart');
      twoButtonPopup(context, 'content', _cart, cartModel, _order);
    }

    // setState(() {
    //   switch (x) {
    //     case true:
    //       print('Updating cart');
    //       twoButtonPopup(context, 'content', _cart, cartModel, _order);

    //       break;
    //     case false:
    //       print('Adding new cart');
    //       _addProductButton(_cart, cartModel, _order);

    //       _productDetailPopup(_addedConfirmation());

    //       break;

    //     default:
    //       print('Could Not Add Product');
    //   }
    // });
  }

  void twoButtonPopup(context, content, cart, cartModel, _order) {
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
                'Are You Sure Bud',
                style: titleParagraphStyle,
              )
            ],
          ),
          content: _cartdDuplicate(),
          actions: <Widget>[
            FlatButton(
              textColor: buddiesPurple,
              child: Text("Add & Clear"),
              onPressed: () {
                _addProductButton(cart, cartModel, _order);

                setState(() {
                  updatingCart = false;
                });

                Navigator.of(context).pop();
                _productDetailPopup(_addedConfirmation());
              },
            ),
            FlatButton(
              textColor: buddiesPurple,
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

  Widget _sizeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: screenAwareSize(40.0, context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: sizeList.map((item) {
              var index = sizeList.indexOf(item);
              // print(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentSizeIndex = index;
                    print('current index is ${sizeList.indexOf(item)}');
                  });
                },
                child: sizeItem(item, index == currentSizeIndex, context),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _productDetails(BuildContext context) {
    return Container(
      height: screenAwareSize(200, context),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(product.productCategory,
                textAlign: TextAlign.left, style: titleStyle),
            SizedBox(
              height: 5,
            ),
            Text(
              productCategoryDescription[prodDetail],
              style: secondaryStyle,
              softWrap: true,
            ),
            SizedBox(
              height: 10,
            ),
            Text('THC', textAlign: TextAlign.left, style: titleStyle),
            SizedBox(
              height: 5,
            ),
            Text(
              thcContent,
              style: secondaryStyle,
              softWrap: true,
            ),
            SizedBox(
              height: 10,
            ),
            Text('CBD', textAlign: TextAlign.left, style: titleStyle),
            Text(
              cbdContent,
              style: secondaryStyle,
              softWrap: true,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                '${product.productType[0].toUpperCase()}${product.productType.substring(1)}',
                textAlign: TextAlign.left,
                style: titleStyle),
            Text(
              strain[strainInfo],
              style: secondaryStyle,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Future getTotal(product, cartVal) async {
    price = product.sizes[0].price;
    print('The price is: $price');
  }

  void _addProductButton(cart, cartModel, _order) {
    print(_order);

    _fromPreRec(widget.dispensary);
    cart.addToCart(widget.dispensary, widget.dispensary.id,
        widget.dispensary.dispensaryPhoto, cartModel, price, _order);
    checkOrders();

    Navigator.pop(context);
  }

  void _fromPreRec(dispensary) {
    print('from pre rec');
    if (fromPreRec == true) {
      CartProvider.of(context).setDispensary(dispensary);
    } else {}
  }

  void checkOrders() {
    if (cartEmpty == false) {
      cartEmpty = true;
    } else {}
  }

  _getOrder(size, quantity) {
    setState(() {
      _order['product_size'] = size;
      _order['quantity'] = quantity;
    });
  }

  void _getSizes(product) {
    for (int i = 0; i < product.sizes.length; i++) {
      // sizeNumlist
      var nSize = product.sizes[i].size;
      // print('${nSize.price}');

      var sizeName = sizeNumlist[nSize - 1];
      sizeList.add(sizeName);
    }
    _hideAccessorySize();
  }

  void _hideAccessorySize() {
    if (product.sizes[0].size == 6) {
      setState(() {
        hideAccessory = true;
      });
    } else {
      setState(() {
        hideAccessory = false;
      });
    }
  }
}

Widget sizeItem(var size, bool isSelected, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
      width: screenAwareSize(30.0, context),
      height: screenAwareSize(30.0, context),
      decoration: BoxDecoration(
          color: isSelected ? buddiesSecondaryPurple : Color(0xFF525663),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color:
                    isSelected ? Colors.black.withOpacity(.5) : Colors.black12,
                offset: Offset(0.0, 10.0),
                blurRadius: 10.0)
          ]),
      child: Center(
        child: Text(size,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white, fontFamily: "Montserrat-Bold")),
      ),
    ),
  );
}

Widget colorItem(
    Color color, bool isSelected, BuildContext context, VoidCallback _ontab) {
  return GestureDetector(
    onTap: _ontab,
    child: Padding(
      padding: EdgeInsets.only(left: screenAwareSize(10.0, context)),
      child: Container(
        width: screenAwareSize(30.0, context),
        height: screenAwareSize(30.0, context),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: buddiesBlue.withOpacity(.8),
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0))
                  ]
                : []),
        child: ClipPath(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: color,
          ),
        ),
      ),
    ),
  );
}
