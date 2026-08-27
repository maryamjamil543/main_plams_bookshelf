import 'package:flutter_base/models/response/book_response/Author.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/OwnerModel.dart';

import 'ActiveLoan.dart';

class BorrowedBook {
   int? id;
   String? title;
   String? isbn;
   String? location;
   String? type;
   String? status;
   String? coverImage;
   Owner? owner;
   Author? author;
   Library? library;
   ActiveLoan? activeLoan;
   String? booksCount;
   String? createdAt;
   String? updatedAt;

  BorrowedBook({
     this.id,
     this.title,
     this.location,
     this.type,
    this.owner,
     this.booksCount,
     this.createdAt,
     this.updatedAt,
    this.status,
    this.coverImage,
    this.isbn,
    this.activeLoan,
    this.author,
    this.library,
  });

   factory BorrowedBook.fromJson(Map<String, dynamic> json) {
     return BorrowedBook(
       id: json['id'] is int
           ? json['id']
           : int.tryParse(json['id'].toString()),

       title: json['title'],
       isbn: json['isbn'],
       coverImage: json['cover_image'],
       location: json['location'],
       type: json['type'],
       status: json['status'],

       owner: json['owner'] is Map<String, dynamic>
           ? Owner.fromJson(json['owner'])
           : null,
       author: json['author'] is Map<String, dynamic>
           ? Author.fromJson(json['author'])
           : null,
       library: json['library'] is Map<String, dynamic>
           ? Library.fromJson(json['library'])
           : null,
       activeLoan: json['active_loan'] is Map<String, dynamic>
           ? ActiveLoan.fromJson(json['active_loan'])
           : null,
       booksCount: json['books_count']?.toString(),
       createdAt: json['created_at'],
       updatedAt: json['updated_at'],
     );
   }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'location': location,
    'isbn': isbn,
    'type': type,
    'cover_image': coverImage,
    'status': status,
    'owner': owner?.toJson(),
    'library': library?.toJson(),
    'author': author?.toJson(),
    'active_loan': activeLoan?.toJson(),
    'books_count': booksCount,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
