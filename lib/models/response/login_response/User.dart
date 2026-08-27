class User {
  int? id;
  String? name;
  String? username;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? lastLoginAt;
  String? role;
  String? parentOwnerId;
  bool? requestedOwner;
  String? avatar;
  String? phone;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.role,
    this.parentOwnerId,
    this.requestedOwner,
    this.avatar,
    this.phone,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastLoginAt = json['last_login_at'];
    role = json['role'];
    parentOwnerId = json['parent_owner_id']?.toString();
    requestedOwner = json['requested_owner'];
    avatar = json['avatar'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['last_login_at'] = lastLoginAt;
    data['role'] = role;
    data['parent_owner_id'] = parentOwnerId;
    data['requested_owner'] = requestedOwner;
    data['avatar'] = avatar;
    data['phone'] = phone;
    return data;
  }
}
