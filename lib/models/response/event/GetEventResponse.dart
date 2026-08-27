
import 'dart:convert';
import 'package:flutter_base/models/response/event/Events.dart';
import 'package:flutter_base/models/response/server_response.dart';

GetEventListResponse eventListResponseFromJson(String str) =>
    GetEventListResponse.fromJson(json.decode(str));

String eventListResponseToJson(GetEventListResponse data) =>
    json.encode(data.toJson());

class GetEventListResponse extends ServerResponse {
  List<Event>? data;

  GetEventListResponse({super.status, super.message, super.error, this.data});

  GetEventListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List).map((e) => Event.fromJson(e)).toList();
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
