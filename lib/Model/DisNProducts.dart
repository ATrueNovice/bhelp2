import 'dart:convert';

import 'package:flutter/material.dart';

class Dispensaries {
  Dispensaries({
    this.dispensary,
  });

  final List<Dispensary> dispensary;

  factory Dispensaries.fromMap(Map<String, dynamic> json) => Dispensaries(
        dispensary: List<Dispensary>.from(
            json["dispensary"].map((x) => Dispensary.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "dispensary": List<dynamic>.from(dispensary.map((x) => x.toMap())),
      };
}

class Dispensary {
  Dispensary(
      {this.id,
      this.name,
      this.cbdOnly,
      this.phone,
      this.address,
      this.dispensaryLogo,
      this.dispensaryPhoto,
      this.dispensaryCategory,
      this.sponsored,
      this.cardAccepted,
      this.medicalOnly,
      this.city,
      this.state,
      this.zipCode,
      this.lat,
      this.lng,
      this.latlng,
      this.openingHours,
      this.shippingDates,
      this.shippingMethod,
      this.rating,
      this.taxRate,
      this.deliveryOptions,
      this.newDispensary,
      this.deliveryFee});

  final int id;
  final String name;
  final String cbdOnly;
  final List<String> shippingDates;
  final String shippingMethod;
  final String phone;
  final String address;
  final String dispensaryLogo;
  final String dispensaryPhoto;
  final String dispensaryCategory;
  final String cardAccepted;
  final String sponsored;
  final String medicalOnly;
  final String city;
  final String state;
  final int zipCode;
  final double lat;
  final String deliveryOptions;
  final double lng;
  final String latlng;
  final List<OpeningHour> openingHours;
  final double rating;
  final bool newDispensary;
  final double taxRate;
  final double deliveryFee;

  factory Dispensary.fromMap(Map<String, dynamic> json) => Dispensary(
        id: json["id"],
        name: json["dispensary_name"],
        cbdOnly: json["cbd_Only"],
        phone: json["phone"],
        address: json["street_address"],
        dispensaryLogo: json["dispensary_logo"],
        dispensaryPhoto: json["dispensary_photo"],
        dispensaryCategory: json["category"],
        sponsored: json["sponsored_dispensary"],
        shippingDates: json['shipping_dates'].cast<String>(),
        shippingMethod: json['shipping_method'],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_Code"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        latlng: json["latlng"],
        medicalOnly: json["medical_only"],
        cardAccepted: json["cards_accepted"],
        deliveryOptions: json['customer_delivery_options'],
        openingHours: List<OpeningHour>.from(
            json["opening_hours"].map((x) => OpeningHour.fromMap(x))),
        rating: json["ratings"].toDouble(),
        newDispensary: json["new_dispensary"],
        taxRate: json["state_tax_rate"],
        deliveryFee: json["delivery_fee"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "dispensary_name": name,
        "cbd_Only": cbdOnly,
        "phone": phone,
        "street_address": address,
        "dispensary_logo": dispensaryLogo,
        "dispensary_photo": dispensaryPhoto,
        "category": dispensaryCategory,
        "sponsored_dispensary": sponsored,
        "shipping_dates": shippingDates,
        "shipping_method": shippingMethod,
        "city": city,
        "state": state,
        "zip_Code": zipCode,
        "customer_delivery_options": deliveryOptions,
        "lat": lat,
        "lng": lng,
        "latlng": latlng,
        "medical_only": medicalOnly,
        "cards_accepted": cardAccepted,
        "opening_hours": List<dynamic>.from(openingHours.map((x) => x.toMap())),
        "ratings": rating,
        "new_dispensary": newDispensary,
        "state_tax_rate": taxRate,
        "delivery_fee": deliveryFee,
      };
}

class OpeningHour {
  OpeningHour({
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
  });

  final dynamic dayOfWeek;
  final String openingTime;
  final String closingTime;

  factory OpeningHour.fromMap(Map<String, dynamic> json) => OpeningHour(
        dayOfWeek: json["day_of_week"],
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
      );

  Map<String, dynamic> toMap() => {
        "day_of_week": dayOfWeek,
        "opening_time": openingTime,
        "closing_time": closingTime,
      };
}

class ProductList {
  List<Product> product;

  ProductList({this.product});

  ProductList.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = new List<Product>();
      json['product'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product implements Comparable<Product> {
  final int id;
  final String name;
  final String shortDesc;
  final String usage;
  final String effect;
  final int quantity;
  final List<Sizes> sizes;
  final String image;
  final String image2;
  final String image3;
  final String productType;
  final String productCategory;
  final double thcContent;
  final double cbdContent;

  Product({
    @required this.id,
    @required this.name,
    @required this.shortDesc,
    @required this.usage,
    @required this.effect,
    @required this.quantity,
    @required this.sizes,
    @required this.image,
    @required this.image2,
    @required this.image3,
    @required this.productType,
    @required this.productCategory,
    @required this.thcContent,
    @required this.cbdContent,
  });

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      shortDesc: json["short_description"],
      usage: json["usage"],
      effect: json["effect"],
      quantity: json["quantity"],
      sizes: Sizes.listFromJson((json["sizes"] as List).cast()),
      image: json["image"],
      image2: json["image2"],
      image3: json["image3"],
      productType: json["Product_Type"],
      productCategory: json["Product_Category"],
      thcContent: json["thc_content"],
      cbdContent: json["cbd_content"],
    );
  }

  static List<Product> listFromJsonString(String jsonString) {
    Map<String, dynamic> data = (jsonDecode(jsonString) as Map).cast();
    List<Map<String, dynamic>> products = (data['product'] as List).cast();
    return products.map((item) => Product.fromJson(item)).toList();
  }

  toJson() {}
}

class Sizes {
  final int id;
  final int size;
  final int productId;

  final double price;

  Sizes({
    @required this.id,
    @required this.size,
    @required this.productId,
    @required this.price,
  });

  factory Sizes.fromJson(Map<String, dynamic> json) {
    return Sizes(
      id: json["id"],
      size: json["size"],
      productId: json["product_id"],
      price: json["price"],
    );
  }

  static List<Sizes> listFromJson(List<Map<String, dynamic>> items) {
    return items.map((item) => Sizes.fromJson(item)).toList();
  }

  static listFromJsonString(List cast) {}
}

class Locations {
  final Dispensary dis;
  final double dist;
  final int index;
  Locations({this.dis, this.dist, this.index});
}

class ProductsInHeading implements Comparable<ProductsInHeading> {
  final String heading;
  final List<Product> products;

  ProductsInHeading(this.heading, this.products);

  @override
  int compareTo(ProductsInHeading other) {
    return heading.compareTo(other.heading);
  }
}
