class Profile {
  CustomerDetail customerDetail;

  Profile({this.customerDetail});

  Profile.fromJson(Map<String, dynamic> json) {
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail.toJson();
    }
    return data;
  }
}

class CustomerDetail {
  String state;
  String name;
  int age;
  String recommendedForUser;
  String city;
  String customerType;
  String address;
  String level;
  String currentSelfie;
  List<LikedDispensaries> likedDispensaries;
  List<LikedProducts> likedProducts;
  String needsHelpWith;
  String phone;
  String preferedStrain;
  String feel;
  String address2;
  String zip;

  CustomerDetail(
      {this.state,
      this.name,
      this.age,
      this.recommendedForUser,
      this.customerType,
      this.address,
      this.level,
      this.currentSelfie,
      this.likedDispensaries,
      this.likedProducts,
      this.needsHelpWith,
      this.phone,
      this.preferedStrain,
      this.feel,
      this.zip,
      this.city,
      this.address2});

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    name = json['name'];
    age = json['age'];
    city = json['city'];

    recommendedForUser = json['recommended_for_user'];
    customerType = json['customer_type'];
    address = json['address'];
    address2 = json['address_2'];
    level = json['level'];
    currentSelfie = json['current_selfie'];
    if (json['liked_dispensaries'] != null) {
      likedDispensaries = new List<LikedDispensaries>();
      json['liked_dispensaries'].forEach((v) {
        likedDispensaries.add(new LikedDispensaries.fromJson(v));
      });
    }
    if (json['liked_products'] != null) {
      likedProducts = new List<LikedProducts>();
      json['liked_products'].forEach((v) {
        likedProducts.add(new LikedProducts.fromJson(v));
      });
    }
    needsHelpWith = json['needs_help_with'];
    phone = json['phone'];
    preferedStrain = json['prefered_strain_type'];
    feel = json['wants_to_feel'];
    zip = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['name'] = this.name;
    data['age'] = this.age;
    data['recommended_for_user'] = this.recommendedForUser;
    data['customer_type'] = this.customerType;
    data['address'] = this.address;
    data['level'] = this.level;
    data['current_selfie'] = this.currentSelfie;
    if (this.likedDispensaries != null) {
      data['liked_dispensaries'] =
          this.likedDispensaries.map((v) => v.toJson()).toList();
    }
    if (this.likedProducts != null) {
      data['liked_products'] =
          this.likedProducts.map((v) => v.toJson()).toList();
    }
    data['needs_help_with'] = this.needsHelpWith;
    data['phone'] = this.phone;
    data['prefered_strain_type'] = this.preferedStrain;
    data['wants_to_feel'] = this.feel;
    data['address_2'] = this.address2;
    data['zip_code'] = this.zip;

    return data;
  }
}

class LikedDispensaries {
  int id;
  String name;
  String cbdOnly;
  List<Null> shippingDates;
  String shippingMethod;
  String phone;
  String address;
  String dispensaryLogo;
  String dispensaryPhoto;
  String sponsoredDispensary;
  String category;
  String deliveryOptions;
  double stateTaxRate;
  double deliveryFee;
  String cardsAccepted;
  String medicalOnly;
  String city;
  String state;
  int zipCode;
  double lat;
  double lng;
  String latlng;
  List<Null> openingHours;
  double ratings;
  bool newDispensary;

  LikedDispensaries(
      {this.id,
      this.name,
      this.cbdOnly,
      this.shippingDates,
      this.shippingMethod,
      this.phone,
      this.address,
      this.dispensaryLogo,
      this.dispensaryPhoto,
      this.sponsoredDispensary,
      this.category,
      this.deliveryOptions,
      this.stateTaxRate,
      this.deliveryFee,
      this.cardsAccepted,
      this.medicalOnly,
      this.city,
      this.state,
      this.zipCode,
      this.lat,
      this.lng,
      this.latlng,
      this.openingHours,
      this.ratings,
      this.newDispensary});

  LikedDispensaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['dispensary_name'];
    cbdOnly = json['cbd_Only'];

    shippingMethod = json['shipping_method'];
    phone = json['phone'];
    address = json['street_address'];
    dispensaryLogo = json['dispensary_logo'];
    dispensaryPhoto = json['dispensary_photo'];
    sponsoredDispensary = json['sponsored_dispensary'];
    category = json['category'];
    deliveryOptions = json['customer_delivery_options'];
    stateTaxRate = json['state_tax_rate'];
    deliveryFee = json['delivery_fee'];
    cardsAccepted = json['cards_accepted'];
    medicalOnly = json['medical_only'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_Code'];
    lat = json['lat'];
    lng = json['lng'];
    latlng = json['latlng'];

    ratings = json['ratings'].toDouble();
    newDispensary = json['new_dispensary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dispensary_name'] = this.name;
    data['cbd_Only'] = this.cbdOnly;

    data['shipping_method'] = this.shippingMethod;
    data['phone'] = this.phone;
    data['street_address'] = this.address;
    data['dispensary_logo'] = this.dispensaryLogo;
    data['dispensary_photo'] = this.dispensaryPhoto;
    data['sponsored_dispensary'] = this.sponsoredDispensary;
    data['category'] = this.category;
    data['customer_delivery_options'] = this.deliveryOptions;
    data['state_tax_rate'] = this.stateTaxRate;
    data['delivery_fee'] = this.deliveryFee;
    data['cards_accepted'] = this.cardsAccepted;
    data['medical_only'] = this.medicalOnly;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip_Code'] = this.zipCode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['latlng'] = this.latlng;

    data['ratings'] = this.ratings;
    data['new_dispensary'] = this.newDispensary;
    return data;
  }
}

class LikedProducts {
  int id;
  String name;
  String shortDesc;
  String usage;
  String effect;
  int quantity;
  List<Sizes> sizes;
  String image;
  LikedDispensaries dispensaryId;
  String image2;
  String image3;
  String productType;
  String productCategory;
  double thcContent;
  double cbdContent;

  LikedProducts(
      {this.id,
      this.name,
      this.shortDesc,
      this.usage,
      this.effect,
      this.quantity,
      this.sizes,
      this.image,
      this.dispensaryId,
      this.image2,
      this.image3,
      this.productType,
      this.productCategory,
      this.thcContent,
      this.cbdContent});

  LikedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDesc = json['short_description'];
    usage = json['usage'];
    effect = json['effect'];
    quantity = json['quantity'];
    if (json['sizes'] != null) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    image = json['image'];
    dispensaryId = json['dispensary_id'] != null
        ? new LikedDispensaries.fromJson(json['dispensary_id'])
        : null;
    image2 = json['image2'];
    image3 = json['image3'];
    productType = json['Product_Type'];
    productCategory = json['Product_Category'];
    thcContent = json['thc_content'];
    cbdContent = json['cbd_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDesc;
    data['usage'] = this.usage;
    data['effect'] = this.effect;
    data['quantity'] = this.quantity;
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    if (this.dispensaryId != null) {
      data['dispensary_id'] = this.dispensaryId.toJson();
    }
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['Product_Type'] = this.productType;
    data['Product_Category'] = this.productCategory;
    data['thc_content'] = this.thcContent;
    data['cbd_content'] = this.cbdContent;
    return data;
  }
}

class Sizes {
  int id;
  int size;
  int productId;
  double price;

  Sizes({this.id, this.size, this.productId, this.price});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    productId = json['product_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    return data;
  }
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
