import 'dart:convert';
class Country {
  String? name;
  List<String>? cities;

  Country({
    this.name,
    this.cities,
  });
  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    cities = json['cities'] != null
        ? List<String>.from(json['cities'])
        : [];
  }
  Country.fromDb({
    required String name,
    String? cities,
  }) {
    this.name = name;
    this.cities =
    cities != null ? List<String>.from(jsonDecode(cities)) : [];
  }
  String citiesToDb() => jsonEncode(cities ?? []);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cities': cities,
    };
  }
}