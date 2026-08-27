
import 'package:flutter_base/generated/l10n.dart';

class Event {
  int? id;
  int? libraryId;
  int? attendeesCount;
  String? title;
  String? description;
  String? location;
  String? speakers;
  DateTime? startDate;
  DateTime? endDate;
  String? color;
  String? type;
  String? feeAmount;
  String? feeCurrency;

  Event({
    this.id,
    this.title,
    this.description,
    this.location,
    this.speakers,
    this.startDate,
    this.endDate,
    this.color,
    this.type,
    this.feeAmount,
    this.feeCurrency,
    this.libraryId,
    this.attendeesCount
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    attendeesCount: json['attendees_count'],
      libraryId: json['library_id'] != null
          ? int.tryParse(json['library_id'].toString())
          : null,
    title: json['title'],
    description: json['description'],
    location: json['location'],
    speakers: json['speakers'],
    startDate: json['start_date'] != null
        ? DateTime.parse(json['start_date']).toLocal()
        : null,
    endDate: json['end_date'] != null
        ? DateTime.parse(json['end_date']).toLocal()
        : null,
    color: json['color'],
    type: json['type'],
    feeAmount: json['fee_amount'],
    feeCurrency: json['fee_currency'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'library_id': libraryId,
    'attendees_count': attendeesCount,
    'title': title,
    'description': description,
    'location': location,
    'speakers': speakers,
    'start_date': startDate?.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'color': color,
    'type': type,
    'fee_amount': feeAmount,
    'fee_currency': feeCurrency,
  };
}