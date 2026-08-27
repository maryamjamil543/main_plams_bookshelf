class Division {
  int? id;
  String? division;

  Division({this.id, this.division});

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    division = json['division'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division'] = this.division;
    return data;
  }

  Division.fromDb({
    int? id,
    String? division,
  }) {
    if (id != null) this.id = id;
    if (division != null) this.division = division;
  }
}