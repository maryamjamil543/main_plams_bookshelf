import 'package:flutter_base/models/response/login_response/Country.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'BookBaseData.dart';
import 'package:flutter_base/models/response/server_response.dart';

class BaseDataResponse extends ServerResponse {
  List<PlatformPackage> platformPackages;
  List<PaymentMethod> paymentMethods;
  List<Country> countries;
  BookBaseData? bookBaseData;

  BaseDataResponse({
    super.status,
    super.message,
    super.error,
    List<PlatformPackage>? platformPackages,
    List<PaymentMethod>? paymentMethods,
    List<Country>? countries,
    this.bookBaseData,
  })  : platformPackages = platformPackages ?? [],
        paymentMethods = paymentMethods ?? [],
        countries = countries ?? [];

  factory BaseDataResponse.fromJson(Map<String, dynamic> json) {
    return BaseDataResponse(
      status: json['status'],
      message: json['message'],
      error: json['error'],
      platformPackages: json['platform_packages'] != null
          ? List<PlatformPackage>.from(
          json['platform_packages'].map((x) => PlatformPackage.fromJson(x)))
          : [],
      paymentMethods: json['payment_methods'] != null
          ? List<PaymentMethod>.from(
          json['payment_methods'].map((x) => PaymentMethod.fromJson(x)))
          : [],
      countries: json['countries'] != null
          ? List<Country>.from(json['countries'].map((x) => Country.fromJson(x)))
          : [],
      bookBaseData:
      json['book'] != null ? BookBaseData.fromJson(json['book']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'platform_packages': platformPackages.map((x) => x.toJson()).toList(),
    'payment_methods': paymentMethods.map((x) => x.toJson()).toList(),
    'countries': countries.map((x) => x.toJson()).toList(),
    'book': bookBaseData?.toJson(),
    'status': status,
    'message': message,
    'error': error,
  };
}