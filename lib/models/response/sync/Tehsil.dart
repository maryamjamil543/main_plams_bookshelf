class Tehsil {
  int? id;
  int? divisionIdFk;
  int? districtIdFk;
  String? tehsil;

  Tehsil({this.id, this.divisionIdFk, this.districtIdFk, this.tehsil});

  Tehsil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionIdFk = json['division_idFk'];
    districtIdFk = json['district_idFk'];
    tehsil = json['tehsil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_idFk'] = this.divisionIdFk;
    data['district_idFk'] = this.districtIdFk;
    data['tehsil'] = this.tehsil;
    return data;
  }

  Tehsil.fromDb({
    int? id,
    int? divisionIdFk,
    int? districtIdFk,
    String? tehsil,
  }) {
    if (id != null) this.id = id;
    if (divisionIdFk != null) this.divisionIdFk = divisionIdFk;
    if (districtIdFk != null) this.districtIdFk = districtIdFk;
    if (tehsil != null) this.tehsil = tehsil;
  }
}