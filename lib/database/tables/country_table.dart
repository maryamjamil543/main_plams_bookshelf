import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/login_response/Country.dart';

@UseRowClass(Country, constructor: "fromDb")
class CountryTable extends Table {
  TextColumn get name => text()();

  TextColumn get cities => text().nullable()();

  @override
  Set<Column> get primaryKey => {name};
}