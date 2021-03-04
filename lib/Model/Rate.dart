class Rate {
  String rateId;
  String rateType;
  String carrierId;
  ShippingAmount shippingAmount;
  ShippingAmount insuranceAmount;
  ShippingAmount confirmationAmount;
  ShippingAmount otherAmount;
  int zone;
  String packageType;
  int deliveryDays;
  bool guaranteedService;
  String estimatedDeliveryDate;
  String carrierDeliveryDays;
  String shipDate;
  bool negotiatedRate;
  String serviceType;
  String serviceCode;
  bool trackable;
  String carrierCode;
  String carrierNickname;
  String carrierFriendlyName;
  String validationStatus;
  List warningMessages;
  List errorMessages;

  Rate({
    this.rateId,
    this.rateType,
    this.carrierId,
    this.shippingAmount,
    this.insuranceAmount,
    this.confirmationAmount,
    this.otherAmount,
    this.zone,
    this.packageType,
    this.deliveryDays,
    this.guaranteedService,
    this.estimatedDeliveryDate,
    this.carrierDeliveryDays,
    this.shipDate,
    this.negotiatedRate,
    this.serviceType,
    this.serviceCode,
    this.trackable,
    this.carrierCode,
    this.carrierNickname,
    this.carrierFriendlyName,
    this.validationStatus,
  });

  Rate.fromJson(Map<String, dynamic> json) {
    rateId = json['rate_id'];
    rateType = json['rate_type'];
    carrierId = json['carrier_id'];
    shippingAmount = json['shipping_amount'] != null
        ? new ShippingAmount.fromJson(json['shipping_amount'])
        : null;
    insuranceAmount = json['insurance_amount'] != null
        ? new ShippingAmount.fromJson(json['insurance_amount'])
        : null;
    confirmationAmount = json['confirmation_amount'] != null
        ? new ShippingAmount.fromJson(json['confirmation_amount'])
        : null;
    otherAmount = json['other_amount'] != null
        ? new ShippingAmount.fromJson(json['other_amount'])
        : null;
    zone = json['zone'];
    packageType = json['package_type'];
    deliveryDays = json['delivery_days'];
    guaranteedService = json['guaranteed_service'];
    estimatedDeliveryDate = json['estimated_delivery_date'];
    carrierDeliveryDays = json['carrier_delivery_days'];
    shipDate = json['ship_date'];
    negotiatedRate = json['negotiated_rate'];
    serviceType = json['service_type'];
    serviceCode = json['service_code'];
    trackable = json['trackable'];
    carrierCode = json['carrier_code'];
    carrierNickname = json['carrier_nickname'];
    carrierFriendlyName = json['carrier_friendly_name'];
    validationStatus = json['validation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate_id'] = this.rateId;
    data['rate_type'] = this.rateType;
    data['carrier_id'] = this.carrierId;
    if (this.shippingAmount != null) {
      data['shipping_amount'] = this.shippingAmount.toJson();
    }
    if (this.insuranceAmount != null) {
      data['insurance_amount'] = this.insuranceAmount.toJson();
    }
    if (this.confirmationAmount != null) {
      data['confirmation_amount'] = this.confirmationAmount.toJson();
    }
    if (this.otherAmount != null) {
      data['other_amount'] = this.otherAmount.toJson();
    }
    data['zone'] = this.zone;
    data['package_type'] = this.packageType;
    data['delivery_days'] = this.deliveryDays;
    data['guaranteed_service'] = this.guaranteedService;
    data['estimated_delivery_date'] = this.estimatedDeliveryDate;
    data['carrier_delivery_days'] = this.carrierDeliveryDays;
    data['ship_date'] = this.shipDate;
    data['negotiated_rate'] = this.negotiatedRate;
    data['service_type'] = this.serviceType;
    data['service_code'] = this.serviceCode;
    data['trackable'] = this.trackable;
    data['carrier_code'] = this.carrierCode;
    data['carrier_nickname'] = this.carrierNickname;
    data['carrier_friendly_name'] = this.carrierFriendlyName;
    data['validation_status'] = this.validationStatus;
  }
}

class ShippingAmount {
  String currency;
  int amount;

  ShippingAmount({this.currency, this.amount});

  ShippingAmount.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['amount'] = this.amount;
    return data;
  }
}
