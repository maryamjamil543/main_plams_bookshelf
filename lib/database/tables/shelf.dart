import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/book_response/Self.dart';
@UseRowClass(Shelf, constructor: "fromDb")
class ShelfTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get libraryId  => integer()();
}