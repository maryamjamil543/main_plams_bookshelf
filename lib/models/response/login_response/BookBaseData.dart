import 'package:flutter_base/models/response/book_response/Self.dart';
import 'package:flutter_base/models/response/login_response/Category.dart';
import 'package:flutter_base/models/response/login_response/Donor.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';

import 'Author.dart';

class BookBaseData {
  List<Category>? categories;
  List<AuthorBaseData>? authors;
  List<Donor>? donors;
  List<Room>? rooms;
  List<Shelf>? shelves;

  BookBaseData({
    this.categories,
     this.authors,
    this.donors,
    this.rooms,
    this.shelves,
  });

  BookBaseData.fromJson(Map<String, dynamic> json) {

    if (json['categories'] != null) {
      categories = List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x)));
    } else {
      categories = [];
    }

    if (json['authors'] != null) {
      authors = List<AuthorBaseData>.from(
          json['authors'].map((x) => AuthorBaseData.fromJson(x)));
    } else {
      authors = [];
    }

    if (json['donors'] != null) {
      donors = List<Donor>.from(
          json['donors'].map((x) => Donor.fromJson(x)));
    } else {
      donors = [];
    }
    //
    if (json['rooms'] != null) {
      rooms = List<Room>.from(
          json['rooms'].map((x) => Room.fromJson(x)));
    } else {
      rooms = [];
    }
    //
    if (json['shelves'] != null) {
      shelves = List<Shelf>.from(
          json['shelves'].map((x) => Shelf.fromJson(x)));
    } else {
      shelves = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories?.map((x) => x.toJson()).toList(),
      'authors': authors?.map((x) => x.toJson()).toList(),
      'donors': donors?.map((x) => x.toJson()).toList(),
      'rooms': rooms?.map((x) => x.toJson()).toList(),
      'shelves': shelves?.map((x) => x.toJson()).toList(),
    };
  }
}