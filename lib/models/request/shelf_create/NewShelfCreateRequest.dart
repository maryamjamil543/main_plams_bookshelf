import 'package:dio/dio.dart';

class CreateShelfRequestModel {
  int? libraryId;
  int? roomId;
  String? name;
  int? capacity;

  CreateShelfRequestModel({
    this.libraryId,
    this.roomId,
    this.name,
    this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      "library_id": libraryId,
      "room_id": roomId,
      "name": name,
      "capacity": capacity,
    };
  }

  Future<FormData> toFormData() async =>
      FormData.fromMap(toJson());
}