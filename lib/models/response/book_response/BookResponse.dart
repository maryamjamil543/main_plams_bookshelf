import 'dart:convert';

import 'package:flutter_base/models/response/book_response/Book.dart';
import 'package:flutter_base/models/response/server_response.dart';

BookResponse getBookResponseFromJson(String str) =>
    BookResponse.fromJson(json.decode(str));

String getBookResponseToJson(BookResponse data) =>
    json.encode(data.toJson());

class BookResponse extends ServerResponse {
  List<Book> data;

  BookResponse({
    super.status,
    super.message,
    super.error,
    required this.data,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      status: json['status'],
      message: json['message'],
      error: json['error'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['data'] = data.map((e) => e.toJson()).toList();
    return map;
  }
}
