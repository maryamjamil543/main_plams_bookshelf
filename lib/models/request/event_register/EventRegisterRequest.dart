import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:path/path.dart';
class EventRegisterRequest {
  String? name;
  String? email;
  String? phoneNumber;
  String? paymentId;
  String? notes;
  String? chimneyPicture;
  EventRegisterRequest({
    this.name,
    this.email,
    this.phoneNumber,
    this.notes,
    this.paymentId,
    this.chimneyPicture

  });
  // Convert JSON to BrickKilnRequestModel
  factory EventRegisterRequest.fromJson(Map<String, dynamic> json) {
    return EventRegisterRequest(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone"] ?? "",
      notes: json["notes"] ?? "",
      paymentId: json["payment_id"] ?? "",
      chimneyPicture: json["payment_proof"] ?? "",

    );
  }

  // Convert the model into a JSON object
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phoneNumber,
      "payment_proof": chimneyPicture,
    };
  }

  // Convert the model into FormData for multipart requests
  Future<FormData> toFormData() async {
    Map<String, dynamic> map = toJson();

    if (chimneyPicture != null && chimneyPicture!.isNotEmpty) {

      final file = File(chimneyPicture!);

      if (!await file.exists()) {
        throw Exception(
          "The file does not exist at the provided path: $chimneyPicture",
        );
      }

      map['payment_proof'] = await MultipartFile.fromFile(
        chimneyPicture!,
        filename: basename(chimneyPicture!),
      );
    }

    return FormData.fromMap(map);
  }
}
