class AuthorBaseData {
  int? id;
  String? name;

  AuthorBaseData({this.id, this.name});

  AuthorBaseData.fromJson(Map<String, dynamic> json) {
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
  AuthorBaseData.fromDb({
    required int id,
    required String name,

  }) {
    this.id = id;
    this.name = name;

  }
}