class ClientDetail {
  List<int> accounts;
  int age;
  String name;

  ClientDetail({this.accounts, this.age, this.name});

  ClientDetail.fromJson(Map<String, dynamic> json) {
    accounts = json['accounts'].cast<int>();
    age = json['age'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accounts'] = this.accounts;
    data['age'] = this.age;
    data['name'] = this.name;
    return data;
  }
}
