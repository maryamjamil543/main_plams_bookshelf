class Category {
  int? id;
  String? name;

  Category({this.id, this.name, });

  Category.fromJson(Map<String, dynamic> json) {
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
  Category.fromDb({
    required int id,
    required String name,
  }) {
    this.id = id;
    this.name = name;
  }
}