
import '../../response/get_library_response/Library.dart';

/// Subscription model
class Subscription {
  final int id;
  final String userId;
  final String libraryId;
  final String subscriptionType;
  final String amount;
  final String paymentMethod;
  final String transactionScreenshotPath;
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime? startDate;
  final DateTime? expiresAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Library library;

  Subscription({
    required this.id,
    required this.userId,
    required this.libraryId,
    required this.subscriptionType,
    required this.amount,
    required this.paymentMethod,
    required this.transactionScreenshotPath,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.startDate,
    this.expiresAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.library,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'] ?? '',
      libraryId: json['library_id'] ?? '',
      subscriptionType: json['subscription_type'] ?? '',
      amount: json['amount'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      transactionScreenshotPath: json['transaction_screenshot_path'] ?? '',
      status: json['status'] ?? '',
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      library: Library.fromJson(json['library']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'library_id': libraryId,
    'subscription_type': subscriptionType,
    'amount': amount,
    'payment_method': paymentMethod,
    'transaction_screenshot_path': transactionScreenshotPath,
    'status': status,
    'approved_by': approvedBy,
    'approved_at': approvedAt?.toIso8601String(),
    'start_date': startDate?.toIso8601String(),
    'expires_at': expiresAt?.toIso8601String(),
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'library': library.toJson(),
  };
}
