
import '../subscription_plan/Subscription.dart';

class GetSubscriptionResponse {
  final String status;
  final List<Subscription> data;

  GetSubscriptionResponse({
    required this.status,
    required this.data,
  });

  factory GetSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return GetSubscriptionResponse(
      status: json['status'] ?? '',
      data: json['data'] != null
          ? List<Subscription>.from(
          json['data'].map((x) => Subscription.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
