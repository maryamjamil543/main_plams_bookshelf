import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';

@UseRowClass(PlatformPackage, constructor: "fromDb")
class PlatformPackageTable extends Table {
  IntColumn get id => integer().unique()();

  TextColumn get name => text().nullable()();

  TextColumn get price => text().nullable()();

  TextColumn get durationType => text().nullable()();

  IntColumn get durationValue => integer().nullable()();

  IntColumn get maxLibraries => integer().nullable()();

  TextColumn get description => text().nullable()();
}