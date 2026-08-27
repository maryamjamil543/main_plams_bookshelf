class Donor {
  int? id;
  String? name;

  Donor({this.id, this.name});

  Donor.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  Donor.fromDb({
    required int id,
    required String name,
  }) {
    this.id = id;
    this.name = name;
  }
}