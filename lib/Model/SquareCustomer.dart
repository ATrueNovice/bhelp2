class ActiveSquareAccount {
  Customer customer;

  ActiveSquareAccount({this.customer});

  ActiveSquareAccount.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  Address address;
  List<Cards> cards;
  String createdAt;
  String creationSource;
  String familyName;
  String givenName;
  List<Groups> groups;
  String id;
  Preferences preferences;
  String referenceId;
  List<String> segmentIds;
  String updatedAt;

  Customer(
      {this.address,
      this.cards,
      this.createdAt,
      this.creationSource,
      this.familyName,
      this.givenName,
      this.groups,
      this.id,
      this.preferences,
      this.referenceId,
      this.segmentIds,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['cards'] != null) {
      cards = new List<Cards>();
      json['cards'].forEach((v) {
        cards.add(new Cards.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    creationSource = json['creation_source'];
    familyName = json['family_name'];
    givenName = json['given_name'];
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    id = json['id'];
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
    referenceId = json['reference_id'];
    segmentIds = json['segment_ids'].cast<String>();
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.cards != null) {
      data['cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['creation_source'] = this.creationSource;
    data['family_name'] = this.familyName;
    data['given_name'] = this.givenName;
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    if (this.preferences != null) {
      data['preferences'] = this.preferences.toJson();
    }
    data['reference_id'] = this.referenceId;
    data['segment_ids'] = this.segmentIds;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Address {
  String addressLine1;
  String administrativeDistrictLevel1;
  String country;
  String locality;
  String postalCode;

  Address(
      {this.addressLine1,
      this.administrativeDistrictLevel1,
      this.country,
      this.locality,
      this.postalCode});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    administrativeDistrictLevel1 = json['administrative_district_level_1'];
    country = json['country'];
    locality = json['locality'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['administrative_district_level_1'] = this.administrativeDistrictLevel1;
    data['country'] = this.country;
    data['locality'] = this.locality;
    data['postal_code'] = this.postalCode;
    return data;
  }
}

class Cards {
  BillingAddress billingAddress;
  String cardBrand;
  String cardholderName;
  int expMonth;
  int expYear;
  String id;
  String last4;

  Cards(
      {this.billingAddress,
      this.cardBrand,
      this.cardholderName,
      this.expMonth,
      this.expYear,
      this.id,
      this.last4});

  Cards.fromJson(Map<String, dynamic> json) {
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
    cardBrand = json['card_brand'];
    cardholderName = json['cardholder_name'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    id = json['id'];
    last4 = json['last_4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress.toJson();
    }
    data['card_brand'] = this.cardBrand;
    data['cardholder_name'] = this.cardholderName;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['id'] = this.id;
    data['last_4'] = this.last4;
    return data;
  }
}

class BillingAddress {
  String addressLine1;
  String addressLine2;
  String administrativeDistrictLevel1;
  String country;
  String locality;
  String postalCode;

  BillingAddress(
      {this.addressLine1,
      this.addressLine2,
      this.administrativeDistrictLevel1,
      this.country,
      this.locality,
      this.postalCode});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    administrativeDistrictLevel1 = json['administrative_district_level_1'];
    country = json['country'];
    locality = json['locality'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['administrative_district_level_1'] = this.administrativeDistrictLevel1;
    data['country'] = this.country;
    data['locality'] = this.locality;
    data['postal_code'] = this.postalCode;
    return data;
  }
}

class Groups {
  String id;
  String name;

  Groups({this.id, this.name});

  Groups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Preferences {
  bool emailUnsubscribed;

  Preferences({this.emailUnsubscribed});

  Preferences.fromJson(Map<String, dynamic> json) {
    emailUnsubscribed = json['email_unsubscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_unsubscribed'] = this.emailUnsubscribed;
    return data;
  }
}
