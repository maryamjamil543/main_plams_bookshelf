import 'dart:convert';
import 'package:flutter_base/models/response/server_response.dart';

import 'BorrowedBook.dart';

GetBorrowedBookResponse getLibrariesResponseFromJson(String str) =>
    GetBorrowedBookResponse.fromJson(json.decode(str));

String getLibrariesResponseToJson(GetBorrowedBookResponse data) =>
    json.encode(data.toJson());

class GetBorrowedBookResponse extends ServerResponse {
  List<BorrowedBook>? data;

  GetBorrowedBookResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    final raw = json['data'];

    if (raw is List) {
      data = raw.map((e) => BorrowedBook.fromJson(e)).toList();
    } else {
      data = [];
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