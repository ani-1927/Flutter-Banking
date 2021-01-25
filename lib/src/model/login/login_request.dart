import 'dart:convert';

class LoginRequest {
  String email;
  String password;
  bool returnSecureToken;

  LoginRequest({this.email, this.password, this.returnSecureToken});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    returnSecureToken = json['returnSecureToken'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['returnSecureToken'] = this.returnSecureToken;
    return data;
  }

  String toJson() {
    return json.encode(this.toMap());
  }
}
