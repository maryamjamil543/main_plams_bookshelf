import 'dart:convert';
import 'package:flutter_base/models/response/login_response/Country.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'BookBaseData.dart';
import 'Data.dart';
import 'User.dart';
import 'package:flutter_base/models/response/login_response/LibraryLogin.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse extends ServerResponse {
  Data? data;

  LoginResponse({super.status, super.message, super.error, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json.containsKey('access_token')) {
      final baseData = json['base_data'];

      List<PlatformPackage> packages = [];
      List<PaymentMethod> methods = [];
      List<Country> country = [];
      BookBaseData? bookBaseData;

      if (baseData != null) {

        if (baseData['platform_packages'] != null) {
          packages = List<PlatformPackage>.from(
              baseData['platform_packages']
                  .map((x) => PlatformPackage.fromJson(x)));
        }

        if (baseData['payment_methods'] != null) {
          methods = List<PaymentMethod>.from(
              baseData['payment_methods']
                  .map((x) => PaymentMethod.fromJson(x)));
        }
        if (baseData['countries'] != null) {
          country = List<Country>.from(
              baseData['countries']
                  .map((x) => Country.fromJson(x)));
        }
        if (baseData['book'] != null) {
          bookBaseData = BookBaseData.fromJson(baseData['book']);
        }
      }

      data = Data(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        libraries: json['libraries'] != null
            ? List<LibraryLogin>.from(
            json['libraries'].map((x) => LibraryLogin.fromJson(x)))
            : [],
        platFormPackage: packages,
        paymentMethods: methods,
        country: country,
        bookBaseData: bookBaseData,
      );
    } else if (json.containsKey('data') && json['data'] != null) {
      data = Data.fromJson(json['data']);
    } else {
      data = null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}
