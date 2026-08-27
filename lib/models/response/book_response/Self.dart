class Shelf {
  int? id;
  String? name;
  int? libraryId;

  Shelf({this.id, this.name,this.libraryId});

  Shelf.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');

    name = json['name']?.toString() ?? '';
    libraryId== json['library_id'] is int
        ? json['library_id']
        : int.tryParse(json['library_id']?.toString() ?? '');


  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'library_id': libraryId,
    };
  }
  Shelf.fromDb({
    required int id,
    required String name,
    int? libraryId,
  }) {
    this.id = id;
    this.name = name;
    this.libraryId = libraryId;
  }
}