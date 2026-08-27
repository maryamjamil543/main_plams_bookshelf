class ServerResponse {
  int? statusCode;
  dynamic? status;
  String? message;
  List<dynamic>? error;

  ServerResponse({this.status, this.message, this.error,this.statusCode});

  ServerResponse.fromJson(Map<String, dynamic> json,{int? code}) {
    statusCode = code;
    status = json['success']?? json['status'];
    message = json['message'];
    if (json['errors'] != null && json['errors'] is Map) {
      error = [];
      (json['errors'] as Map).forEach((key, value) {
        if (value is List) {
          error?.addAll(value.map((e) => e.toString()));
        } else if (value != null) {
          error?.add(value.toString());
        }
      });
    } else if (json['error'] != null && json['error'] is List) {
      error = List<String>.from(json['error'].map((e) => e.toString()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
