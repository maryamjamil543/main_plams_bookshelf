class PaymentMethod {
  int? id;
  String? name;
  String? details;
  String? instructions;

  PaymentMethod({
    this.id,
    this.name,
    this.details,
    this.instructions,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    details = json['details'] ?? '';
    instructions = json['instructions'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'instructions': instructions,
    };
  }
  PaymentMethod.fromDb({
    required int id,
    required String name,
    String? details,
    String? instructions,
  }) {
    this.id = id;
    this.name = name;
    this.details = details ?? '';
    this.instructions = instructions ?? '';
  }
}
