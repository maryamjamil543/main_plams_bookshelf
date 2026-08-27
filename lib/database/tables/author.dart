import 'package:drift/drift.dart';
import '../../models/response/login_response/Author.dart';
@UseRowClass(AuthorBaseData, constructor: "fromDb")
class AuthorTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}