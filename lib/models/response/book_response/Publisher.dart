class Publisher {
  int id;
  String name;
  String? address;

  Publisher({
    required this.id,
    required this.name,
    this.address,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
  };
}
