import 'dart:convert';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/server_response.dart';

GetLibrariesResponse getLibrariesResponseFromJson(String str) =>
    GetLibrariesResponse.fromJson(json.decode(str));

String getLibrariesResponseToJson(GetLibrariesResponse data) =>
    json.encode(data.toJson());

class GetLibrariesResponse extends ServerResponse {
  List<Library>? data;

  GetLibrariesResponse({super.status, super.message, super.error, this.data});

  GetLibrariesResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List).map((e) => Library.fromJson(e)).toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (data != null) {
      map['data'] = data!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}
