import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

class SubscriptionDetailRequestModel {
  String paymentName;
  String subscriptionType;
  String chimneyPicture;


  SubscriptionDetailRequestModel({
    required this.paymentName,
    required this.subscriptionType,

    required this.chimneyPicture,



  });

  // Convert JSON to BrickKilnRequestModel
  factory SubscriptionDetailRequestModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetailRequestModel(
      paymentName: json["payment_method_id"] ?? "",
      subscriptionType: json["subscription_package_id"] ?? "",
      chimneyPicture: json["transaction_screenshot"] ?? "",

    );
  }

  // Convert the model into a JSON object
  Map<String, dynamic> toJson() {
    return {
      "payment_method_id": paymentName,
      "subscription_package_id": subscriptionType,
      "transaction_screenshot": chimneyPicture,
    };
  }

  // Convert the model into FormData for multipart requests
  Future<FormData> toFormData() async {
    Map<String, dynamic> map = toJson();

    if (chimneyPicture.isNotEmpty) {
      final file = File(chimneyPicture);
      if (!await file.exists()) {
        throw Exception("The file does not exist at the provided path: $chimneyPicture");
      }
      map['transaction_screenshot'] =
      await MultipartFile.fromFile(chimneyPicture, filename: basename(chimneyPicture));
    }
    return FormData.fromMap(map);

  }
}
