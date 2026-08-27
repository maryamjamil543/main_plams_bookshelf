

import 'package:flutter_base/models/response/server_response.dart';
import 'package:flutter_base/models/response/sync/SyncData.dart';

class SyncResponse extends ServerResponse {
  SyncData? data;

  SyncResponse({super.status, super.message, super.error, this.data});

  SyncResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? SyncData.fromJson(json['data']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = super.toJson();
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}
/*class SyncResponse {
  bool? success;
  String? message;
  SyncData? data;

  SyncResponse({this.success,this.message, this.data});

  SyncResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new SyncData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}*/
