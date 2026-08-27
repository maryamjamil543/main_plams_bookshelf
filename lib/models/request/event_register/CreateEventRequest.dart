import 'package:dio/dio.dart';

class CreateEventRequestModel {
   int? libraryId;
   String? title;
   String? description;
   String? location;
   String? speakers;
   String? startDate;
   String? endDate;
   String? color;
   String? feeAmount;
   String? feeCurrency;
   String? bankName;
   String? bankAccount;
   int? createdBy;

  CreateEventRequestModel({
     this.libraryId,
     this.title,
     this.description,
     this.location,
     this.speakers,
     this.startDate,
     this.endDate,
    this.color,
    this.feeAmount,
    this.feeCurrency,
    this.bankName,
    this.bankAccount,
     this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "library_id": libraryId,
      "title": title,
      "description": description,
      "location": location,
      "speakers": speakers,
      "start_date": startDate,
      "end_date": endDate,
      if (color != null) "color": color,
      if (feeAmount != null) "fee_amount": feeAmount,
      if (feeCurrency != null) "fee_currency": feeCurrency,
      if (bankName != null) "bank_name": bankName,
      if (bankAccount != null) "bank_account": bankAccount,
      "created_by": createdBy,
    };
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap(toJson());
  }
}