
import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/sync/District.dart';

@UseRowClass(District, constructor: "fromDb")
class DistrictTable extends Table {
  IntColumn get id => integer()();
  TextColumn get district => text()();
  IntColumn get divisionIdFk => integer()();
}
