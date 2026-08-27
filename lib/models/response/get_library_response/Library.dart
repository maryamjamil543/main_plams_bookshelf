import 'package:flutter_base/models/response/login_response/OwnerModel.dart';

class Library {
   int? id;
   String? name;
   String? location;
   String? type;
   Owner? owner;
   String? booksCount;
   String? createdAt;
   String? updatedAt;

  Library({
     this.id,
     this.name,
     this.location,
     this.type,
    this.owner,
     this.booksCount,
     this.createdAt,
     this.updatedAt,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      type: json['type'],
      owner: json['owner'] != null
          ? Owner.fromJson(json['owner'])
          : null,
      booksCount: json['books_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'type': type,
    'owner': owner?.toJson(),
    'books_count': booksCount,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
