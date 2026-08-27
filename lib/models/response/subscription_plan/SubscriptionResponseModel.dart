import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'package:flutter_base/models/response/server_response.dart';

import '../login_response/PlatformPackage.dart';

class SubscriptionResponseModel extends ServerResponse{
  final String? status;
  final String? library;
  final List<PlatformPackage>? plans;
  final List<PaymentMethod>? paymentMethods;

  SubscriptionResponseModel({
    this.status,
    this.library,
    this.plans,
    this.paymentMethods,
  });

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseModel(
      status: json['status'],
      library: json['library'],
      plans: json['plans'] != null
          ? List<PlatformPackage>.from(
        json['plans'].map((x) => PlatformPackage.fromJson(x)),
      )
          : [],
      paymentMethods: json['payment_methods'] != null
          ? List<PaymentMethod>.from(
        json['payment_methods']
            .map((x) => PaymentMethod.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'library': library,
      'plans': plans?.map((e) => e.toJson()).toList(),
      'payment_methods':
      paymentMethods?.map((e) => e.toJson()).toList(),
    };
  }
}