import 'package:flutter_base/models/response/login_response/BookBaseData.dart';
import 'package:flutter_base/models/response/login_response/Country.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'User.dart';
import 'LibraryLogin.dart';

class Data {
  String? accessToken;
  String? tokenType;
  User? user;
  List<LibraryLogin>? libraries;
  List<PlatformPackage>? platFormPackage;
  List<PaymentMethod>? paymentMethods;
  List<Country>? country;
  BookBaseData? bookBaseData;
  Data({
    this.accessToken,
    this.tokenType,
    this.user,
    this.libraries,
    this.platFormPackage,
    this.paymentMethods,
    this.country,
    this.bookBaseData,
  });

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] ?? json['token'];
    tokenType = json['token_type'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    // Libraries
    if (json['libraries'] != null) {
      libraries = List<LibraryLogin>.from(
          json['libraries'].map((x) => LibraryLogin.fromJson(x)));
    } else {
      libraries = [];
    }

    final baseData = json['base_data'];

    if (baseData != null) {

      // Platform Packages
      if (baseData['platform_packages'] != null) {
        platFormPackage = List<PlatformPackage>.from(
            baseData['platform_packages']
                .map((x) => PlatformPackage.fromJson(x)));
      } else {
        platFormPackage = [];
      }

      // Payment Methods
      if (baseData['payment_methods'] != null) {
        paymentMethods = List<PaymentMethod>.from(
            baseData['payment_methods']
                .map((x) => PaymentMethod.fromJson(x)));
      } else {
        paymentMethods = [];
      }
      if (baseData['book'] != null) {
        bookBaseData = BookBaseData.fromJson(baseData['book']);
      } else {
        bookBaseData = null;
      }
      if (baseData['countries'] != null) {
        country = List<Country>.from(
            baseData['countries']
                .map((x) => Country.fromJson(x)));
      } else {
        country = [];
      }
    } else {
      platFormPackage = [];
      paymentMethods = [];
      country = [];
      if (baseData['book'] != null) {
        bookBaseData = BookBaseData.fromJson(baseData['book']);
      } else {
        bookBaseData = null;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['access_token'] = accessToken;
    map['token_type'] = tokenType;

    if (user != null) {
      map['user'] = user!.toJson();
    }

    if (libraries != null) {
      map['libraries'] =
          libraries!.map((x) => x.toJson()).toList();
    }

    // Put inside base_data again
    map['base_data'] = {
      'platform_packages':
      platFormPackage?.map((x) => x.toJson()).toList(),
      'payment_methods':
      paymentMethods?.map((x) => x.toJson()).toList(),
      'countries':
      country?.map((x) => x.toJson()).toList(),
      'book': bookBaseData?.toJson(),
    };

    return map;
  }
}
