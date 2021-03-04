class Coupon {
  int id;
  String code;
  double amount;
  List<String> validCategories;
  String startDate;
  String endDate;
  int dispensary;
  List<int> validProducts;

  Coupon(
      {this.id,
      this.code,
      this.amount,
      this.validCategories,
      this.startDate,
      this.endDate,
      this.dispensary,
      this.validProducts});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    validCategories = json['valid_categories'].cast<String>();
    startDate = json['start_date'];
    endDate = json['end_date'];
    dispensary = json['dispensary'];
    validProducts = json['valid_products'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['valid_categories'] = this.validCategories;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['dispensary'] = this.dispensary;
    data['valid_products'] = this.validProducts;
    return data;
  }
}
