class SignUpResponse {
  List<String> nonFieldErrors;

  SignUpResponse({this.nonFieldErrors});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    nonFieldErrors = json['non_field_errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['non_field_errors'] = this.nonFieldErrors;
    return data;
  }
}