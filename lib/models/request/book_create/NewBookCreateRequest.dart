import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

class NewBookCreateRequestModel {
  String authorId;
  String categoryId;
  String shelfId;
  int price;
  String? donorId;
  String? libraryId;
  int? isDontedCheckBox;
  int copies;
  String? title;
  String edition;
  String? isbn;
  String? donorName;
  String? donorEmail;
  String? donorPhone;
  String publishDate;
  String? publishName;
  String description;
  String? newCategoryName;
  String? newAuthorName;
  // bool? isFromGoogle;
  //  String? previewLink;
  //  String? infoLink;
  //  String? pdfDownloadLink;

  NewBookCreateRequestModel({
    required this.authorId,
    required this.categoryId,
    required this.shelfId,
     this.title,
    required this.edition,
    required this.publishDate,
     this.publishName,
    this.isDontedCheckBox,
    required this.description,
    required this.price,
    required this.copies,
     this.isbn,
    this.donorEmail,
    this.donorName,
    this.donorPhone,
    this.donorId,
    this.libraryId,
    // this.isFromGoogle,
    this.newCategoryName,
    this.newAuthorName,
    // this.previewLink,
    // this.pdfDownloadLink,
    // this.infoLink

  });
  // Convert JSON to BrickKilnRequestModel
  factory NewBookCreateRequestModel.fromJson(Map<String, dynamic> json) {
    return NewBookCreateRequestModel(
      authorId: json["author_id"] ?? "",
      categoryId: json["category_id"] ?? "",
      shelfId: json["shelf_id"] ?? "",
      title: json["title"] ?? "",
      edition: json["edition"] ?? "",
      publishDate: json["publish_date"] ?? "",
      publishName: json["publisher"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? "",
      isbn: json["isbn"] ?? "",
      donorId: json["donor_id"] ?? "",
      libraryId: json["library_id"] ?? "",
      copies: json["copies"] ?? "",
      donorName: json["new_donor_name"] ?? "",
      donorPhone: json["new_donor_phone"] ?? "",
      donorEmail: json["new_donor_email"] ?? "",
      isDontedCheckBox: json["is_donated"] ?? "",
      newCategoryName: json["new_category_name"] ?? "",
      newAuthorName: json["new_author_name"] ?? "",
      // previewLink: json['volumeInfo']?['previewLink'] ?? "",
      // infoLink: json['volumeInfo']?['infoLink'] ?? "",
      // pdfDownloadLink:
      // json['accessInfo']?['pdf']?['downloadLink'] ??
      //     json['accessInfo']?['webReaderLink'] ??
      //     json['volumeInfo']?['previewLink'] ??
      //     "",
      // isFromGoogle: json["is_from_google"] ?? false,

    );
  }

  // Convert the model into a JSON object
  Map<String, dynamic> toJson() {
    return {
      "author_id": authorId,
      "category_id": categoryId,
      "shelf_id": shelfId,
      "title": title,
      "edition": edition,
      "publish_date": publishDate,
      "publisher": publishName,
      "description": description,
      "price": price,
      "copies": copies,
      "isbn": isbn,
      "donor_id": donorId,
      "library_id": libraryId,
      "new_donor_phone": donorPhone,
      "new_donor_email": donorEmail,
      "new_donor_name": donorName,
      "is_donated": isDontedCheckBox,
      "new_category_name": newCategoryName,
      // "is_from_google": isFromGoogle,
      "new_author_name": newAuthorName,
      // "preview_link": previewLink,
      // "info_link": infoLink,
      // "pdf_download_link": pdfDownloadLink,

    };
  }

  // Convert the model into FormData for multipart requests
  Future<FormData> toFormData() async {
    Map<String, dynamic> map = toJson();

    // if (chimneyPicture.isNotEmpty) {
    //   final file = File(chimneyPicture);
    //   if (!await file.exists()) {
    //     throw Exception("The file does not exist at the provided path: $chimneyPicture");
    //   }
    //   map['transaction_screenshot'] =
    //   await MultipartFile.fromFile(chimneyPicture, filename: basename(chimneyPicture));
    // }
    return FormData.fromMap(map);

  }
}
