
class LoginRequestModel {
  String email;
  String? password;
  String? deviceId;

  LoginRequestModel({required this.email, this.password, this.deviceId});

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {
      'email': email.replaceAll("-", "").trim(),
      'password': password
    };
    return map;
  }
}
