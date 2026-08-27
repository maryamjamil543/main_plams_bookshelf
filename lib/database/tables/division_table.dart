
import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/sync/Division.dart';

@UseRowClass(Division, constructor: "fromDb")
class DivisionTable extends Table {
  IntColumn get id => integer()();
  TextColumn get division => text()();
}
