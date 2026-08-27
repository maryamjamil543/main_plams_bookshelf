import 'package:flutter_base/models/response/sync/District.dart';
import 'package:flutter_base/models/response/sync/Division.dart';
import 'package:flutter_base/models/response/sync/Tehsil.dart';

class SyncData {
  List<Division>? division;
  List<District>? district;
  List<Tehsil>? tehsil;

  SyncData(
      {
      this.division,
      this.district,
      this.tehsil,});

  SyncData.fromJson(Map<String, dynamic> json) {
    if (json['division'] != null) {
      division = <Division>[];
      json['division'].forEach((v) {
        division!.add(new Division.fromJson(v));
      });
    }
    if (json['district'] != null) {
      district = <District>[];
      json['district'].forEach((v) {
        district!.add(new District.fromJson(v));
      });
    }
    if (json['tehsil'] != null) {
      tehsil = <Tehsil>[];
      json['tehsil'].forEach((v) {
        tehsil!.add(new Tehsil.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.division != null) {
      data['division'] = this.division!.map((v) => v.toJson()).toList();
    }
    if (this.district != null) {
      data['district'] = this.district!.map((v) => v.toJson()).toList();
    }
    if (this.tehsil != null) {
      data['tehsil'] = this.tehsil!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
