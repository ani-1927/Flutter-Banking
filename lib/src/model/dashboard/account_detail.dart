import 'dart:convert';

class AccountDetail {
  int account;
  double balance;
  double overdraft;

  AccountDetail({this.balance, this.overdraft});

  AccountDetail.fromJson(Map<String, dynamic> json, int account) {
    try{
      balance = double.parse(json['balance'].toString());
      overdraft = double.parse(json['overdraft'].toString()) ?? 0.0;
      this.account = account;
    }catch (error){
      print(error);
      balance = 0.0;
      overdraft =  0.0;
      this.account = account;
    }

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['overdraft'] = this.overdraft;
    return data;
  }

  String toJson() {
    return json.encode(this.toMap());
  }
}
