import 'package:dio/dio.dart';

class CreateRoomRequestModel {
  int? libraryId;
  String? name;

  CreateRoomRequestModel({this.libraryId, this.name});

  Map<String, dynamic> toJson() {
    return {
      "library_id": libraryId,
      "name": name,
    };
  }

  Future<FormData> toFormData() async => FormData.fromMap(toJson());
}