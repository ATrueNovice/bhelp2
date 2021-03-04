import 'package:Buddies/Checkout/CartDetails.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends InheritedWidget {
  final _cart = Cart();

  CartProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Cart of(BuildContext context) {
    CartProvider provider =
        context.dependOnInheritedWidgetOfExactType<CartProvider>();
    return provider._cart;
  }
}
