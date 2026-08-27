import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/login_response/Donor.dart';
@UseRowClass(Donor, constructor: "fromDb")
class DonorTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}