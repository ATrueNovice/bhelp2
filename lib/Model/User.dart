import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String profilePic;

  User({@required this.email, @required this.name, @required this.profilePic});

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      profilePic: json['picture']['data']['url'],
    );
  }
}

class GoogleUser {
  final String name;
  final String email;
  final String profilePic;

  GoogleUser(
      {@required this.email, @required this.name, @required this.profilePic});

  factory GoogleUser.fromJSON(Map<String, dynamic> json) {
    return GoogleUser(
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }
}
class GoogleToken {
  String status;
  String token;

  GoogleToken({this.status, this.token});

  GoogleToken.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}