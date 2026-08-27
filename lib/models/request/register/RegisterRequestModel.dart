
import 'package:dio/dio.dart';
class RegisterRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String? name;
  final String? country;
  final String? city;
  final String? deviceId;

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.name,
    this.country,
    this.city,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email.trim(),
      "password": password,
      "password_confirmation": confirmPassword,
      if (name != null) "name": name,
      if (country != null) "country": country,
      if (city != null) "city": city,
      if (deviceId != null) "device_id": deviceId,
    };
  }
  Future<FormData> toFormData() async {
    return FormData.fromMap(toJson());
  }
}