class Student {
  int? id;
  int? volunteerId;
  String? picture;
  String? name;
  String? fatherName;
  String? dateOfBirth;
  String? gender;
  int? mobileNo;
  String? email;
  int? districtId;
  int? tehsilId;
  String? district_name;
  String? tehsil_name;
  String? cnic;
  String? residentialAddress;
  String? createdAt;
  String? updatedAt;
  String? pictureUrl;

  Student(
      {this.id,
        this.volunteerId,
        this.picture,
        this.name,
        this.fatherName,
        this.dateOfBirth,
        this.gender,
        this.mobileNo,
        this.email,
        this.districtId,
        this.tehsilId,
        this.tehsil_name,
        this.district_name,
        this.cnic,
        this.residentialAddress,
        this.createdAt,
        this.updatedAt,
        this.pictureUrl});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    volunteerId = json['volunteer_id'];
    picture = json['picture'];
    name = json['name'];
    fatherName = json['father_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    districtId = json['district_id'];
    district_name = json['district_name'];
    tehsil_name = json['tehsil_name'];
    tehsilId = json['tehsil_id'];
    cnic = json['cnic'];
    residentialAddress = json['residential_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pictureUrl = json['picture_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['volunteer_id'] = volunteerId;
    data['picture'] = picture;
    data['name'] = name;
    data['father_name'] = fatherName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    data['district_id'] = districtId;
    data['tehsil_id'] = tehsilId;
    data['tehsil_name'] = tehsil_name;
    data['district_name'] = district_name;
    data['cnic'] = cnic;
    data['residential_address'] = residentialAddress;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['picture_url'] = pictureUrl;
    return data;
  }

  Student.fromDb({
    int? id,
    int? volunteerId,
    String? picture,
    String? name,
    String? fatherName,
    String? dateOfBirth,
    String? gender,
    int? mobileNo,
    String? email,
    int? districtId,
    int? tehsilId,
    String? district_name,
    String? tehsil_name,
    String? cnic,
    String? residentialAddress,
    String? createdAt,
    String? updatedAt,
    String? pictureUrl,
  }) {
    if (id != null) this.id = id;
    if (volunteerId != null) this.volunteerId = volunteerId;
    if (picture != null) this.picture = picture;
    if (name != null) this.name = name;
    if (fatherName != null) this.fatherName = fatherName;
    if (dateOfBirth != null) this.dateOfBirth = dateOfBirth;
    if (gender != null) this.gender = gender;
    if (mobileNo != null) this.mobileNo = mobileNo;
    if (email != null) this.email = email;
    if (districtId != null) this.districtId = districtId;
    if (tehsilId != null) this.tehsilId = tehsilId;
    if (district_name != null) this.district_name = district_name;
    if (tehsil_name != null) this.tehsil_name = tehsil_name;
    if (cnic != null) this.cnic = cnic;
    if (residentialAddress != null) this.residentialAddress = residentialAddress;
    if (createdAt != null) this.createdAt = createdAt;
    if (updatedAt != null) this.updatedAt = updatedAt;
    if (pictureUrl != null) this.pictureUrl = pictureUrl;
  }
}