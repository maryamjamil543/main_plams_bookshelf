import 'package:drift/drift.dart';

import '../../models/response/login_response/Category.dart';
@UseRowClass(Category, constructor: "fromDb")
class CategoryTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}