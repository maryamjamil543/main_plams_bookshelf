class Author {
  int? id;
  String name;
  String? bio;

  Author({
     this.id,
    required this.name,
    this.bio,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bio': bio,
  };
}
