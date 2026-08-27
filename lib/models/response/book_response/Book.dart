import 'package:flutter_base/models/response/book_response/Author.dart';
import 'package:flutter_base/models/response/book_response/OwnerDetail.dart';
import 'package:flutter_base/models/response/book_response/Publisher.dart';
import 'package:flutter_base/models/response/book_response/Self.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';


class Book {
  int? id;
  String? title;
  Author? author;
  String? isbn;
  Publisher? publisher;
  String? publishedYear;
  String? description;
  String? coverImage;
  String? status;
  int? totalCopies;
  OwnerDetails? ownerDetails;
  Library? library;
   Shelf? shelf;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isFromGoogle;
   String? infoLink;
   String? source;
   String? pdfDownloadLink;

  Book({
     this.id,
    this.title,
    this.author,
     this.isbn,
    this.publisher,
    this.publishedYear,
    this.description,
     this.coverImage,
     this.status,
    this.ownerDetails,
    this.library,
    this.shelf,
     this.createdAt,
     this.updatedAt,
    this.pdfDownloadLink,
    this.infoLink,
    this.isFromGoogle= true,
    this.source ="google",
    this.totalCopies
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author:json['author'] != null ? Author.fromJson(json['author']) : null,
      isbn: json['isbn'],
      publisher :json['publisher'] != null ? Publisher.fromJson(json['publisher']) : null,
      publishedYear: json['published_year'],
      description: json['description'],
      coverImage: json['cover_image'],
      status: json['status'],
      totalCopies: json['total_copies'],
      ownerDetails:json['owner_details'] != null ? OwnerDetails.fromJson(json['owner_details']) : null,
      library: json['library'] != null ? Library.fromJson(json['library']) : null,
      shelf: json['shelf'] != null ? Shelf.fromJson(json['shelf']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
        pdfDownloadLink: json['pdf_download_link'],
        infoLink: json['info_link'],
      // isFromGoogle: false,
      source: json['source'] ?? "server",
      isFromGoogle: json['source'] == "google",

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author?.toJson(),
    'isbn': isbn,
    'publisher': publisher?.toJson(),
    'published_year': publishedYear,
    'description': description,
    'cover_image': coverImage,
    'status': status,
    'total_copies': totalCopies,
    'owner_details': ownerDetails?.toJson(),
    'library': library?.toJson(),
    'shelf': shelf?.toJson(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'pdf_download_link': pdfDownloadLink,
    'source': source,
    'info_link': infoLink,


  };
  Book.fromDb({
    required int id,
    String? title,
    String? description,
    String? publishedYear,
    String? coverImage,
    String? authorName,
    String? status,
    int? totalCopies,
  }) {
    this.id = id;
    this.title = title;
    this.status= status;
    this.totalCopies=totalCopies;
    this.description = description;
    this.publishedYear = publishedYear;
    this.coverImage = coverImage;
    this.author = authorName != null ? Author(name: authorName) : null;
  }
}
