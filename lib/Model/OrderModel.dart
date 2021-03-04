class LatestOrder {
  List<Order> order;

  LatestOrder({this.order});

  LatestOrder.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = new List<Order>();
      json['order'].forEach((v) {
        order.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int id;
  Customer customer;
  Venue venue;
  bool orderRated;
  String deliveryType;
  Driver driver;
  List<OrderDetails> orderDetails;
  String total;
  String status;
  String address;
  String createdAt;
  bool orderFlagged;
  String userMessage;

  Order(
      {this.id,
      this.customer,
      this.venue,
      this.orderRated,
      this.driver,
      this.orderDetails,
      this.deliveryType,
      this.total,
      this.status,
      this.address,
      this.createdAt,
      this.orderFlagged,
      this.userMessage});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    venue = json['dispensary'] != null
        ? new Venue.fromJson(json['dispensary'])
        : null;
    orderRated = json['order_rated'];
    deliveryType = json['delivery_type'];

    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
    total = json['total'];
    status = json['status'];
    address = json['address'];
    createdAt = json['created_at'];
    orderFlagged = json['order_flagged'];
    userMessage = json['user_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.venue != null) {
      data['dispensary'] = this.venue.toJson();
    }
    data['order_rated'] = this.orderRated;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    data['delivery_type'] = this.deliveryType;

    data['total'] = this.total;
    data['status'] = this.status;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['order_flagged'] = this.orderFlagged;
    data['user_message'] = this.userMessage;
    return data;
  }
}

class Customer {
  int id;
  String name;
  String avatar;
  String phone;

  Customer({this.id, this.name, this.avatar, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['current_selfie'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['current_selfie'] = this.avatar;
    data['phone'] = this.phone;
    return data;
  }
}

class Venue {
  int id;
  String name;
  String phone;
  String logo;
  String photo;
  String streetAddress;
  double lat;
  double lng;

  Venue(
      {this.id,
      this.name,
      this.phone,
      this.logo,
      this.photo,
      this.streetAddress,
      this.lat,
      this.lng});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['dispensary_name'];
    phone = json['phone'];
    logo = json['dispensary_logo'];
    photo = json['dispensary_photo'];
    streetAddress = json['street_address'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue_name'] = this.name;
    data['phone'] = this.phone;
    data['dispensary_logo'] = this.logo;
    data['dispensary_photo'] = this.photo;
    data['street_address'] = this.streetAddress;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Driver {
  int id;
  String name;
  String photo;
  String phone;

  Driver({this.id, this.name, this.photo, this.phone});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['phone'] = this.phone;
    return data;
  }
}

class OrderDetails {
  int id;
  int productSize;
  int quantity;
  double subTotal;
  int prodId;
  String product;
  String usage;
  String effect;
  String image;
  String category;

  OrderDetails(
      {this.id,
      this.productSize,
      this.quantity,
      this.subTotal,
      this.prodId,
      this.product,
      this.usage,
      this.effect,
      this.image,
      this.category});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSize = json['product_size'];
    quantity = json['quantity'];
    subTotal = json['sub_total'];
    prodId = json['prodId'];
    product = json['product'];
    usage = json['usage'];
    effect = json['effect'];
    image = json['image'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_size'] = this.productSize;
    data['quantity'] = this.quantity;
    data['sub_total'] = this.subTotal;
    data['prodId'] = this.prodId;
    data['product'] = this.product;
    data['usage'] = this.usage;
    data['effect'] = this.effect;
    data['image'] = this.image;
    data['category'] = this.category;
    return data;
  }
}

// #Notworking
// def customer_get_latest_order(request):
//     customer = get_user(request)
//     if not customer:
//         return JsonResponse({'invalid token'})
//     order = OrderSerializer(Order.objects.filter(
//         customer=customer).order_by('-id').first()).data
//     return JsonResponse({"order": order})
