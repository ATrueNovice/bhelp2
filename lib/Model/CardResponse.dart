class CardResponse {
  Card card;

  CardResponse({this.card});

  CardResponse.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}

class Card {
  BillingAddress billingAddress;
  String cardBrand;
  String cardholderName;
  int expMonth;
  int expYear;
  String id;
  String last4;

  Card(
      {this.billingAddress,
      this.cardBrand,
      this.cardholderName,
      this.expMonth,
      this.expYear,
      this.id,
      this.last4});

  Card.fromJson(Map<String, dynamic> json) {
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
