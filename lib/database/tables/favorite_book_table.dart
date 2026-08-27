import 'package:drift/drift.dart';
import '../../models/response/book_response/Book.dart';
@UseRowClass(Book, constructor: "fromDb")
class FavoriteBookTable extends Table {
  IntColumn get id => integer()();
  IntColumn get totalCopies => integer()();
  TextColumn get status => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get publishedYear => text().nullable()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get authorName => text().nullable()();
  IntColumn get userId => integer()();

  @override
  Set<Column> get primaryKey => {id,userId};
}