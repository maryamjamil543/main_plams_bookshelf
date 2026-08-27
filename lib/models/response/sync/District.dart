class District {
  int? id;
  int? divisionIdFk;
  String? district;

  District({this.id, this.divisionIdFk, this.district});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionIdFk = json['division_idFk'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_idFk'] = this.divisionIdFk;
    data['district'] = this.district;
    return data;
  }

  District.fromDb({
    int? id,
    int? divisionIdFk,
    String? district,
  }) {
    if (id != null) this.id = id;
    if (divisionIdFk != null) this.divisionIdFk = divisionIdFk;
    if (district != null) this.district = district;
  }
}