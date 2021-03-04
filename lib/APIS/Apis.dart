import 'dart:convert';
import 'dart:io';
import 'package:Buddies/Model/CardResponse.dart';
import 'package:Buddies/Model/Coupon.dart';
import 'package:Buddies/Model/DisNProducts.dart';
import 'package:Buddies/Model/Rate.dart';
import 'package:Buddies/Model/SquareCustomer.dart';
import 'package:Buddies/Model/User.dart';
import 'package:Buddies/Model/UserEvents.dart';
import 'package:Buddies/Model/UserProfile.dart';
import 'package:Buddies/Model/token.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/Model/OrderModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _token = '';
String _refreshTkn = '';
String _accessTkn;
final GoogleSignIn googleSignIn = GoogleSignIn();

String _androidEmulator = 'http://10.0.2.2:8000';
String _appleEmulator = 'http://localhost:8000';

String clientId = 'k2AYMXZeVlxkvniObhgkNKqFEpeBi9hureBxkSyj';
String clientSecret =
    'lFkKTs3ZMmqc9mOcVh1ZsVCrBd8dRx0GOmwclXwpMwgFUnCrOyEvt3bnRFWKov5QyDnwxKawBgW4OtdmsWLm5I39aOvOumR1uAXwW2jnZK9EwVGOF99HAyZzY2VlIE5D';

// String clientId = 'nqKSw47g1l9aUzjT3qAkAMOVSsiFHsX6alo8bBQA';
// String clientSecret =
//     'oGthGo5IkPKH7rPaBPQGTxG3ngFBZ6njEDTpWUfWMpWt6PCy3gGW70FaSQLGEKKnjfFCtVWI21fEaKxZ3jOMBn1XMcfDNdBUh6lJT9kgw12Z9HkWEx2eq6OBsaQnP3Ck';

//Get token

Future<dynamic> facebookUserLogin(String token) async {
  String grantType = 'convert_token';
  String backend = 'facebook';
  String userType = 'customer';
  var url = '$buddiesServer/api/social/convert-token/';

  final Map<String, dynamic> logIn = {
    'grant_type': grantType,
    'client_id': clientId,
    'client_secret': clientSecret,
    'backend': backend,
    'token': token,
    'user_type': userType,
  };

  //pass token
  _token = token;

  print(_token);
  print(json.encode(logIn));
  http.post(url, body: json.encode(logIn), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(response.body);

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    _accessTkn = '${responseData['access_token']}';
    _refreshTkn = '${responseData['refresh_token']}';
    tokenType = 'social';

    addToken(
      _accessTkn,
    );
    addRefresh(
      _accessTkn,
    );

    return response.body;
  });
}

Future<dynamic> googleUserLogin(token) async {
  var url = "$buddiesServer/api/google/verify/";

  final Map<String, dynamic> logIn = {'token': token};

  http.post(url, body: json.encode(logIn), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    var responseData = json.decode(response.body);
    GoogleToken token = GoogleToken.fromJson(responseData);
    _accessTkn = token.token;

    // print(responseData);
    var status = '${responseData['status']}';
    print('The status is $status');
    print('The token is $_accessTkn');

    addToken(
      _accessTkn,
    );
    if (status == 'success') {
      googleSignInSuccess = true;
      print(googleSignInSuccess);
      return googleSignInSuccess;
    } else {
      googleSignInSuccess = false;

      return googleSignInSuccess;
    }
  });
}

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final Map<String, dynamic> _userInfo = {
      'name': null,
      'email': null,
      'profilePic': null,
    };

    final FirebaseAuth _auth = FirebaseAuth.instance;

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    print(user.getIdToken());

    user.getIdToken().then((value) {
      if (value != null) {
        print(value.token);
        // addToken(value.token);
        googleUserLogin(value.token);
      }
    });

    final FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser.getIdToken());
    assert(user.uid == currentUser.uid);
    return 'success';
  } else {
    print('Sign In Cancelled');
    return 'cancelled';
  }
}

//Get pass
Future userLogin(userdetails) async {
  var url = '$buddiesServer/api/token/';

  print(userdetails.values);
  var results;

  await http.post(url, body: json.encode(userdetails), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    Token tkn = Token.fromJSON(responseData);

    _accessTkn = tkn.access;
    var refresh = tkn.refresh;

    if (response.statusCode == 200) {
      addToken(_accessTkn);
      addRefresh(refresh);

      tokenType = 'email';
      results = 'good';
    } else {
      results = 'bad';
    }
  });
  return results;
}

Future getDispensaries() async {
  var url = '$buddiesServer/api/customer/dispensary/';

  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    var responseData = await json.decode(reply);

    print('Printing dispensaries');
    Dispensaries _dispensary = Dispensaries.fromMap(responseData);
    currentDispensaries = _dispensary.dispensary;
    // print(_dispensary.dispensary);

    getCustomerDetails();
    return _dispensary.dispensary;
  } else {
    print('Cannot Reach buddiesServer');
  }
}

Future getDispensariesByLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$buddiesServer/dispensary/by-location/?access_token=$token';
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final locationData = {
    "dist": '8000',
    "point": '$userLat,$userLong',
  };

  final uri = Uri.parse(url);
  final newUri = uri.replace(queryParameters: locationData);

  await http.get(newUri, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }).then((http.Response response) {
    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print('Printing dispensaries');
      Dispensaries _dispensary = Dispensaries.fromMap(responseData);
      currentDispensaries = _dispensary.dispensary;
      // print(_dispensary.dispensary);

      getCustomerDetails();
      return _dispensary.dispensary;
    } else {
      print('Cannot Reach buddiesServer');
    }
  });
}

//
Future getProducts(
  int dispenaryId,
) async {
  var url = '$buddiesServer/api/customer/product/' + '$dispenaryId';
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply =
      await response.transform(utf8.decoder).join(); // print(response.body);
  if (response.statusCode == 200) {
    print('get products from here');
    var responseData = await json.decode(reply);

    final ProductList _products = ProductList.fromJson(responseData);

    print(_products.product[0]);
    currentProducts = _products.product;
    return _products.product;
  } else {
    print('Could not load products');
  }
}

Future getLatestOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = '$buddiesServer/api/customer/order/latest/?access_token=$token';
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  switch (response.statusCode) {
    case (200):
      // print('Order Data: ${response.body}');

      var responseData = await json.decode(reply);
      // print('Order Data: $responseData');

      final LatestOrder _order = LatestOrder.fromJson(responseData);

      print(_order.order);

      if (_order.order.length == 0) {
        return null;
      } else {
        return _order.order;
      }

      break;
    case (500):
      print("No Recent Orders");
      return;
  }
}

Future addLikes(int productId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');

  var url = '$buddiesServer/api/customer/like_product/?access_token=$_token';

  final Map<String, dynamic> body = {'prodId': '$productId'};

  await http.post(url, body: body, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }).then((http.Response response) {
    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      getCustomerDetails();
      print(responseData);

      print('Updated Liked Products');

      return responseData;
    } else {
      print('Unable To Add Liked Products');

      print(responseData);
      return;
    }
  });
}

Future dislikeProduct(int productId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');

  var url =
      '$buddiesServer/api/customer/delete_liked_product/?access_token=$_token';

  final Map<String, dynamic> body = {'prodId': '${productId}'};

  await http.post(url, body: body, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }).then((http.Response response) {
    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      getCustomerDetails();
      print(responseData);

      print('Updated Liked Products');

      return responseData;
    } else {
      print('Unable To Add Liked Products');

      print(responseData);
      return;
    }
  });
}

Future getDriverLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  print('The Latest Order Token is $_token');

  var url = '$buddiesServer/api/customer/driver/location/?access_token=$_token';
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    var responseData = json.decode(reply);

    print(responseData);
    return responseData;
  } else {
    print(reply);
    return;
  }
}

Stream updateDriverLocation(Duration refreshTime) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await getDriverLocation();
  }
}

void smokingBuddies() {
  var url = '$buddiesServer/api/customer/order/latest/';

  final Map<String, dynamic> params = {'access_token': _token};

  http.put(url, body: params, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(response.body);

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    // print('Response body: ${response.body}');
  });
}

Future<void> addToken(access) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('token', access);

  prefs.setBool('vaildToken', true);

  var token = prefs.getString('token');

  print(token);
}

Future<void> addRefresh(refresh) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('refresh', _refreshTkn);

  var refresh = prefs.getString('refresh');

  print(refresh);
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

Future getCustomerDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = '$buddiesServer/api/customer/details/?access_token=$token';
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  switch (response.statusCode) {
    case (200):
      // print('Order Data: ${response.body}');

      var responseData = json.decode(reply);
      // print('Order Data: $responseData');
      print('Received Data');
      final Profile x = Profile.fromJson(responseData);
      userProfile = x.customerDetail;
      print(x.customerDetail);
      if (userProfile != null) {
        recCategories.add(x.customerDetail.feel);
        recCategories.add(x.customerDetail.needsHelpWith);
        recCategories.add(x.customerDetail.preferedStrain);
        recCategories.add(x.customerDetail.customerType);

        print('Made Recommendation List');

        print('The needs products like this $recCategories');
        hasProfile = true;
        return x.customerDetail;
      } else {
        print('profile is null');
        return null;
      }

      break;

    case (500):
      print('User does not have a profile');
      hasProfile = false;

      break;
  }
}

void logOut() {
  var url = '$buddiesServer/api/social/revoke-token/';

  final Map<String, dynamic> _logOut = {
    'client_id': clientId,
    'client_secret': clientSecret,
    'token': _token
  };

  http.post(url, body: _logOut, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(_logOut);

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData.values);
    print('Response body: ${response.body}');
  });
}

void refreshToken() {
  var url = '$buddiesServer/api/social/refresh-token/';

  final Map<String, dynamic> _refreshToken = {
    'access_token': _token,
    'refresh_token': _refreshTkn,
  };

  http.post(url, body: _refreshToken, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    // print(_refreshToken);

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
  });
}

Future rateDriver(ratingCapsule, orderId) async {
  isUploaded = true;

  var url = '$buddiesServer/api/customer/rate_driver/';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print('my token is $token');

  final Map<String, dynamic> driverRating = {
    'access_token': token,
    'tip': '${ratingCapsule['tip']}',
    'driver_rating': '${ratingCapsule['starRating']}',
    'orderId': '$orderId'
  };

  print('The Rating $driverRating');

  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/x-www-form-urlencoded');

  request.add(utf8.encode(json.encode(driverRating)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  switch (response.statusCode) {
    case (200):
      var responseData = json.decode(reply);

      print('The response is $responseData');
      isUploaded = true;
      break;

    case (500):
      print('500 Error $reply');
      isUploaded = false;

      break;
  }
  return isUploaded;
}

Future checkCoupon(couponName, dispensaryId) async {
  isUploaded = true;

  var coup;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url =
      '$buddiesServer/coupon/${couponName}/?dispensary_id=${dispensaryId}' +
          '&access_token=$token';

  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  var responseData = json.decode(reply);

  switch (response.statusCode) {
    case (200):
      Coupon _coupon = Coupon.fromJson(responseData);

      print('Found Valid Coupon');
      print(_coupon.validCategories);
      couponData = _coupon;

      return _coupon;

      break;

    case (404):
      coup = null;
      couponData = null;

      print('No Coupon Available');
      return coup;

      break;
  }

  return coup;
}

Future getMyEvents() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print('my token is $token');

  var events;
  final Map<String, dynamic> body = {
    'access_token': token,
  };

  var url = "$buddiesServer/api/events/my_events/";

  await http.post(url, body: body, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }).then((http.Response response) {
    print(response.body);

    var responseData = json.decode(response.body);

    switch (response.statusCode) {
      case (200):
        UserEvents userEvents = UserEvents.fromJson(responseData);
        print('My Events ${userEvents.events[0]}');
        events = userEvents.events;
        print('Events received');
        print('Events ${events}');

        return userEvents;
        break;

      case (500):
        print('No Events In This City');
        return '';
        break;
    }
  });

  return userEvents;
}

Future getEmailRefreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('refesh Token called');
  var refresh = prefs.getString(_refreshTkn);

  var url = "$buddiesServer/api/token/refresh/";

  final Map<String, dynamic> _refresh = {'refresh': refresh};

  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/x-www-form-urlencoded');

  request.add(utf8.encode(json.encode(_refresh)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();

  final Map<String, dynamic> responseData = json.decode(reply);
  print(responseData);
}

Future cancelOrder(orderId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print('my token is $token');

  final Map<String, dynamic> body = {
    'access_token': token,
    'order_id': '$orderId',
  };

  var url = "$buddiesServer/api/customer/drop/order/";

  await http.post(url, body: body, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        var responseData = json.decode(response.body);
        ResponseStatus status = ResponseStatus.fromJson(responseData);
        print('Order $orderId has been cancelled. Status ${status.status}');
        isUploaded = true;

        break;

      case (500):
        print('Could Not Cancel Order');

        isUploaded = false;
        break;
    }
  });
}

class ResponseStatus {
  String status;

  ResponseStatus({this.status});

  ResponseStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

Future<dynamic> createOrder(stripeToken, dispensaryId, order, address,
    deliveryType, couponCode, nonce) async {
  var url = '$buddiesServer/api/customer/order/add/';
  // print(url);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  final Map<String, dynamic> createOrder = {
    'access_token': token,
    'stripe_token': stripeToken,
    'dispensary_id': "$dispensaryId",
    'address': address,
    'order_details': order,
    'delivery_type': deliveryType,
    'rate_id': 'se-449195932',
    'source': nonce
  };
  print('my order is $createOrder');

  await http.post(url, body: json.encode(createOrder), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        var responseData = json.decode(response.body);
        ResponseStatus status = ResponseStatus.fromJson(responseData);
        print('The response is ${status.status}');

        switch (status.status) {
          case ('success'):
            print(status.status);
            orderError = 0;
            orderPlaced = true;
            print('Moving To Successful Order Screen');
            return orderPlaced;

            break;
          case ('failed'):
            orderPlaced = false;
            orderError = 1;
            print('Wait For Current Order To Be Delivered');

            return orderPlaced;
            break;
        }
        break;

      case (500):
        print('500 Error Failed to upload');
        orderError = 2;
        orderPlaced = false;

        return orderPlaced;

        break;
    }
    return orderPlaced;
  });
}

Future createPreferences(
  _ratingsCapsule,
) async {
  var currentSelfie = _ratingsCapsule[0]['customer_selfie'];
  //Variables
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  Map<String, dynamic> body = {
    'access_token': token,
    'address': '${_ratingsCapsule[0]['address']}',
    'prefered_strain_type': '${_ratingsCapsule[1]['prefered_strain_type']}',
    'phone': "${_ratingsCapsule[0]['phone']}",
    'wants_to_feel': _ratingsCapsule[1]['wants_to_feel'],
    'customer_type': _ratingsCapsule[1]['customer_type'],
    'age': '${_ratingsCapsule[0]['age']}',
    'current_selfie': base64Encode(currentSelfie.readAsBytesSync()),
    'level': _ratingsCapsule[1]['level'],
    'needs_help_with': _ratingsCapsule[1]['needs_help_with'],
    'recommended_for_user': '${_ratingsCapsule[2]}'
  };

  var url = "$buddiesServer/api/customer/create_customer_details/";
  print(body);

  await http.post(url, body: json.encode(body), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case (201):
        print('uploaded successfully');
        isUploaded = true;
        break;

      case (400):
        print('Bad Data');

        break;
      case (500):
        print('Failed Upload');
        isUploaded = false;

        break;
    }
    return isUploaded;
  });
}

Future rateOrder(ratingCapsule, orderId) async {
  isUploaded = false;
  var url = '$buddiesServer/api/customer/rate_order/';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print('my token is $token');
  print(ratingCapsule);

  final Map<String, dynamic> orderRating = {
    'access_token': token,
    'effect_total_rating': '${ratingCapsule['effectRating']}',
    'prodId': '${ratingCapsule['prodId']}',
    'usage_total_rating': '${ratingCapsule['usageRating']}',
    'star_rating': '${ratingCapsule['starRating']}',
    'orderId': '$orderId'
  };

  print(orderRating);
  await http.post(url, body: orderRating, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        final Map<String, dynamic> responseData = json.decode(response.body);

        print('The response is $responseData');
        isUploaded = true;
        break;

      case (500):
        print('Could not rate order ${ratingCapsule['prodId']}');
        isUploaded = false;

        break;
    }
    return isUploaded;
  });
}

Future getShippingRate(dispensary, order) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$buddiesServer/api/customer/order/get_rate/?access_token=$token';
  Map<String, dynamic> orderRating = {
    'dispensary': dispensary,
    'order_detail': order
  };

  await http.post(url, body: json.encode(orderRating), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        var responseData = json.decode(response.body);
        if (responseData.length >= 2) {
          print('dd');
          print(responseData[1]['rate_response']['rates']
              .where((element) =>
             // element['carrier_delivery_days'] == 2 &&
              element['package_type'] == 'medium_flat_rate_box').first);
              // [].where((element) =>
              // element['carrier_delivery_days'] == 2 &&
              // element['package_type'] == 'medium_flat_rate_box')
          //    responseData[1]
          Rate rateData =
              Rate.fromJson(responseData[1]['rate_response']['rates']
              .where((element) =>
             // element['carrier_delivery_days'] == 2 &&
              element['package_type'] == 'medium_flat_rate_box').first);

          print('uploaded successfully-----');
          print(rateData);
          print(rateData.carrierId);
        }
        break;

      case (400):
        print('Bad Data');

        break;
      case (500):
        print(response.body);
        print(json.encode(orderRating));
        print('Failed Upload');
        isUploaded = false;

        break;
      default:
        print('Unable to get rates');
    }
  });
}

Future getSquarePayments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$buddiesServer/square-customer/1/?access_token=$token';

  await http.get(url, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        var responseData = json.decode(response.body);
        ActiveSquareAccount _accountdata =
            ActiveSquareAccount.fromJson(responseData);

        print(_accountdata);
        squareData = _accountdata;

        return squareData;
        break;

      case (400):
        print('Bad Data');

        break;
      case (500):
        print('Failed Upload');

        break;
      default:
        print('Unable to get payment');
    }

    return squareData;
  });

  print('uploaded successfully');
}

Future addSquarePaymentMethod(_cardData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$buddiesServer/square-customer/1/add_card/?access_token=$token';
  print('Getting Nonce Upload results');

  await http.post(url, body: _cardData, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }).then((http.Response response) {
    print('Getting Nonce Upload results');
    switch (response.statusCode) {
      case (200):
        print('uploaded successfully\nNew Card Added');
        var responseData = json.decode(response.body);

        CardResponse squareData = CardResponse.fromJson((responseData));
        print(squareData.card.last4);
        return squareData;
        break;

      case (400):
        print('Bad Data');

        break;
      case (500):
        print('Failed Upload');
        isUploaded = false;

        break;
      default:
        print('Unable to get rates');
    }
    return squareData;
  });
}

Future deleteCard(noonce) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url =
      '$buddiesServer/api/customer/order/delete_card/?access_token=$token';

  Map<String, dynamic> _cardData = {"card_id": noonce};

  await http.post(url, body: json.encode(_cardData), headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    switch (response.statusCode) {
      case (200):
        print('Delete Card');
        break;

      case (400):
        print('Bad Data');

        break;
      case (500):
        print('Failed Upload');
        isUploaded = false;

        break;
      default:
        print('Unable to get rates');
    }
  });
}

Future flagOrder(orderId, reason) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$buddiesServer/api/customer/flag_order/?access_token=$token';

  Map<String, dynamic> _flaggedOrder = {'order_id': orderId, 'reason': reason};

  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');

  request.add(utf8.encode(json.encode(_flaggedOrder)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  print('Flagging Order\nPlease Wait');

  switch (response.statusCode) {
    case (200):
      print('Flagged order');
      var responseData = json.decode(reply);

      break;

    case (404):
      couponData = null;

      print('No Coupon Available');

      break;

    default:
      print(' Cannot flag');
  }
}
