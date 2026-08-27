class UserDistrict {
  int? id;
  String? name;
  String? shortCode;

  UserDistrict({this.id, this.name, this.shortCode});

  UserDistrict.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_code'] = this.shortCode;
    return data;
  }
}