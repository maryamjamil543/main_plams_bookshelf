class LibraryLogin {
  int? id;
  String? name;
  String? type;
  String? status;
  String? subscriptionType;
  String? subscriptionExpiresAt;
  String? location;
  String? inviteToken;
  String? description;
  String? contactEmail;
  String? contactPhone;
  String? paymentEasypaisa;
  String? paymentJazzcash;
  String? paymentBank;
  String? image;
  String? paymentReceipt;
  String? ownerId;
  String? createdAt;
  String? updatedAt;
  String? packageId;

  LibraryLogin({
    this.id,
    this.name,
    this.type,
    this.status,
    this.subscriptionType,
    this.subscriptionExpiresAt,
    this.location,
    this.inviteToken,
    this.description,
    this.contactEmail,
    this.contactPhone,
    this.paymentEasypaisa,
    this.paymentJazzcash,
    this.paymentBank,
    this.image,
    this.paymentReceipt,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.packageId,
  });

  LibraryLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    subscriptionType = json['subscription_type'];
    subscriptionExpiresAt = json['subscription_expires_at'];
    location = json['location'];
    inviteToken = json['invite_token'];
    description = json['description'];
    contactEmail = json['contact_email'];
    contactPhone = json['contact_phone'];
    paymentEasypaisa = json['payment_easypaisa'];
    paymentJazzcash = json['payment_jazzcash'];
    paymentBank = json['payment_bank'];
    image = json['image'];
    paymentReceipt = json['payment_receipt'];
    ownerId = json['owner_id']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    packageId = json['package_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'subscription_type': subscriptionType,
      'subscription_expires_at': subscriptionExpiresAt,
      'location': location,
      'invite_token': inviteToken,
      'description': description,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'payment_easypaisa': paymentEasypaisa,
      'payment_jazzcash': paymentJazzcash,
      'payment_bank': paymentBank,
      'image': image,
      'payment_receipt': paymentReceipt,
      'owner_id': ownerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'package_id': packageId,
    };
  }
}
