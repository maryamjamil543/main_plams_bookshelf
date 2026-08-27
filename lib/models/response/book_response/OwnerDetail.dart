class OwnerDetails {
  int id;
  String name;
  String email;

  OwnerDetails({
    required this.id,
    required this.name,
    required this.email,
  });

  factory OwnerDetails.fromJson(Map<String, dynamic> json) {
    return OwnerDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
