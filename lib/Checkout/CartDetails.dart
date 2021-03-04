import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/Constants/InheritedWidgets.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/Model/DisNProducts.dart';
import 'package:Buddies/widgets/helpers/BuddiesAlerts.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Cart itemCart;
var initDispenaries;

Cart get userCart => itemCart;
CartDetails orderDetail;
CartProvider cart;
Cart currentOrder;
bool pendingOrder = false;

enum CartErrors {
  productAlreadyExists,
  successfullyAdded,
  newDispensary,
  additionalDispensaryItem,
  newCartCreated,
  clearCart
}

class Cart {
  int dispensaryId;
  String dispensaryImage;
  String productImage;
  String productName;
  double cartTotal = 0;
  double temp;

  var dispensary;

  List<CartDetails> orderDetails;
  var orders;

  Cart(
      {this.dispensaryId,
      this.dispensaryImage,
      this.dispensary,
      this.productImage,
      this.productName,
      this.cartTotal,
      this.orders,
      List<CartDetails> products})
      : orderDetails = products;

  void addToCart(dispensary, dispensaryId, dispensaryImage, CartDetails product,
      total, order) {
    final disNumb = dispensaryId ?? null;
    final prodId = product.product.id;
    orderDetails ??= <CartDetails>[];
    orders ??= [];

    if (pendingOrder == false) {
      print('There Are No Pending Orders. Checking Dispensary Id');
      createNewCart(
          dispensary, dispensaryId, dispensaryImage, product, total, order);
    } else {
      print('There are current pending orders.');

      dispensaryCheck(
          dispensary, dispensaryId, dispensaryImage, product, total, order);
    }
  }

  void dispensaryCheck(
      dispensary, disId, dispensaryImage, CartDetails product, total, order) {
    if (disId == itemCart.dispensary.id) {
      print('From The Same Dispensary. Checking For Duplicates');

      checkDuplicates(
          dispensary, dispensaryId, dispensaryImage, product, total, order);
    } else {
      _addProduct(CartErrors.newDispensary);
      print('Clearing Cart and adding new products');
      orderDetails = <CartDetails>[];
      orders = [];
      clearCart();

      orderDetails.add(product);

      orders.add(order);

      itemCart = Cart(
        dispensary: dispensary,
        dispensaryId: dispensaryId,
        dispensaryImage: dispensaryImage,
        products: orderDetails,
        orders: orders,
      );
    }
  }

  Future<void> createNewCart(dispensary, dispensaryId, dispensaryImage,
      CartDetails product, total, order) async {
    //Match item ID

    if (itemCart != null) {
      dispensaryCheck(
          dispensary, dispensaryId, dispensaryImage, product, total, order);
    } else {
      orderDetails.add(product);
      orders.add(order);
      print('New Cart Created');

      itemCart = Cart(
          dispensary: dispensary,
          dispensaryId: dispensaryId,
          dispensaryImage: dispensaryImage,
          products: orderDetails,
          orders: orders);

      _addProduct(CartErrors.newCartCreated);
    }
  }

  void checkDuplicates(dispensary, dispensaryId, dispensaryImage,
      CartDetails product, total, order) {
    //Match item ID
    final existing = orderDetails.firstWhere(
        (p) => p.product.id == product.product.id,
        orElse: () => null);

    if (existing != null) {
      _addProduct(CartErrors.productAlreadyExists);

      print('Duplicate Items. Adding Item. add by one');
      existing.quantity += product.quantity;
    } else {
      print('Same Dispensary. Different Item. Adding Additional Item.');

      orderDetails.add(product);
      orders.add(order);
      itemCart = Cart(
          dispensary: dispensary,
          dispensaryId: dispensaryId,
          dispensaryImage: dispensaryImage,
          products: orderDetails,
          orders: orders);
      _addProduct(CartErrors.successfullyAdded);

      print('There are ${itemCart.orderDetails.length} items in the cart');
    }
    // getCartTotal();
  }

  Future<void> _addProduct(error) async {
    switch (error) {
      case CartErrors.successfullyAdded:
        print('Product Added');
        pendingOrder = true;
        updatingCart = false;

        break;
      case CartErrors.productAlreadyExists:
        print('Product Already Added');
        pendingOrder = true;
        updatingCart = false;

        break;

      case CartErrors.newDispensary:
        print('New Dispensary Selected. Old Dispensary Overwritten');
        updatingCart = true;
        pendingOrder = true;

        break;

      case CartErrors.newCartCreated:
        print('New Cart Created');
        updatingCart = true;
        pendingOrder = true;

        break;

      case CartErrors.clearCart:
        print('New Product Cart Created');
        updatingCart = false;
        pendingOrder = true;

        break;
    }
  }

  void setDispensary(Dispensary dispensary) {
    if (dispensary == dispensary) {
      return;
    } else {
      print('set new dispensary');
      // Assign the new dispensary

      dispensary = dispensary;
      itemCart.dispensary = dispensary;

      // Clear the cart
      orderDetails = <CartDetails>[];
      orders = [];
    }
  }

  void clearCart() {
    // print('The Cart has ${itemCart.orderDetails[0]}');

    itemCart.orderDetails = <CartDetails>[];
    itemCart.orders = null;
    itemCart.dispensary = null;
    itemCart.dispensaryId = null;
    itemCart.productImage = null;
    itemCart.dispensaryImage = null;
    itemCart.productName = null;
    itemCart = null;
    cartEmpty = true;
    pendingOrder = false;
    updatingCart = true;

    // print('The Cart has ${itemCart.orderDetails.length}');
  }

  getCartTotal(itemCart) {
    if (orders != null) {
      itemCart.cartTotal = 0;

      for (int i = 0; i < orders.length; i++) {
        itemCart.cartTotal += (orders[i].price * orders[i].quantity);
      }
      print('Got Total');
      return itemCart.cartTotal;
    }
  }

  updateCartTotal(price, index) {
    if (orders != null) {
      itemCart.cartTotal = 0;

      for (int i = 0; i < orders.length; i++) {
        if (orders[index] = orders[i]) {
          orders[i].price = price;
        }

        itemCart.cartTotal += (orders[i].price * orders[i].quantity);
      }
    }
    print('updated cart total');
    print(cartTotal);

    return itemCart.cartTotal;
  }

  void _clearUserCart() {
    userCart.clearCart();
  }

  /// In some therotical CartController
  /// try {
  ///   addToCart(product);
  /// } on CartErrors catch (e) {
  ///   if (e == CartErrors.productionAlreadyExists) {
  ///      final increment = await showDialog(product);
  ///
  ///   }
  /// }
  ///
  ///
  factory Cart.fromJSON(Map<String, dynamic> json) => Cart(
      dispensary: json['dispensary'],
      dispensaryId: json['dispensaryId'],
      productImage: json['image'],
      productName: json['name'],
      products: json['cartData'],
      orders: json['order']);

  Map<String, dynamic> toJson() => {
        "dispensary": dispensary,
        "dispensaryId": dispensaryId,
        "productImage": productImage == null ? null : productImage,
        "name": productName,
        "cartData": orderDetails,
        "order": orders
      };
}

class CartDetails {
  //Use whole prodcut and do not distructure. Work backwards to incorporate product.
  Product product;
  int quantity;
  double price;
  CartDetails(this.product, this.quantity, this.price);

  factory CartDetails.fromProduct(Product product, int quantity, double price) {
    return CartDetails(product, quantity, price);
  }
}

class Order {
  int productSize;
  int quantity;

  Order(this.productSize, this.quantity);

  factory Order.fromOrder(int productSize, int quantity) {
    return Order(productSize, quantity);
  }
}

class Locator {
  Geolocator geolocator = Geolocator();

  Future checkLocation(position) async {
    print('The user location is: $userLat, $userLong');

    if (position == 0.0) {
      _getLocation().then((userLocation) {
        userLat = userLocation.latitude;
        userLong = userLocation.longitude;
        position = userLocation;

        print('My Location is $userLocation');
        print('My New Position is $userLat, $userLong');
        return userLocation;
      });
      print('Skipped $userLat, $userLong');
    } else {
      print('My Position is  $userLat, $userLong');
    }
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }

    return currentLocation;
  }
}

class UserDetails {
  void getcustomerProfile() {
    getCustomerDetails().then((value) {
      userProfile = value;

      print(' the venue is $value');
      return userProfile;
    });
  }

  void uploadProfile(
    _profile,
  ) {
    createPreferences(_profile).then((value) {
      print('Has the profile been created: $isUploaded');
      isUploaded = value;
      return isUploaded;
    });
  }
}

class ChangeFilter {
  void updatedispensaryFilter(i) {}
}
