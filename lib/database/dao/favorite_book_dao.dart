import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/book_response/Book.dart' as ApiBook;
import '../tables/favorite_book_table.dart';
part 'favorite_book_dao.g.dart';

@DriftAccessor(tables: [FavoriteBookTable])
class FavoriteBookDao extends DatabaseAccessor<MyDatabase>
    with _$FavoriteBookDaoMixin
    implements IFavoriteBookTable {

  FavoriteBookDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(favoriteBookTable)).go();
  }
  Future<void> deleteByTitle(String title) {
    return (delete(favoriteBookTable)
      ..where((tbl) => tbl.title.equals(title)))
        .go();
  }
  Future<ApiBook.Book?> getByTitle(String title) {
    return (select(favoriteBookTable)
      ..where((t) => t.title.equals(title)))
        .getSingleOrNull();
  }
  @override
  Future<int> insertData(ApiBook.Book book,int userId) {
      return into(favoriteBookTable).insertOnConflictUpdate(
        FavoriteBookTableCompanion.insert(
          id: book.id!,
          title: Value(book.title),
          description: Value(book.description),
          publishedYear: Value(book.publishedYear),
          coverImage: Value(book.coverImage),
          authorName: Value(book.author?.name),
          status: Value(book.status),
          userId: userId,
          totalCopies: book.totalCopies! ?? 0,
        ),
      );
    }

  @override
  Future<ApiBook.Book?> getData() {
    return (select(favoriteBookTable)..limit(1)).getSingleOrNull();
  }

  // @override
  // Future<List<ApiBook.Book>> getAllData() async {
  //
  //   return await (select(favoriteBookTable)
  //     ..orderBy([
  //           (t) => OrderingTerm(
  //           expression: t.title,
  //           mode: OrderingMode.asc)
  //     ]))
  //       .get();
  // }

  @override
  Future<void> insertAllData(List<ApiBook.Book>? list,int userId) async {

    if (list == null) return;

    await batch((batch) {
      batch.insertAll(
        favoriteBookTable,
        list.map((item) {

          return FavoriteBookTableCompanion.insert(
            // id: item.id ?? -1,
            title: Value(item.title),
            description: Value(item.description),
            publishedYear: Value(item.publishedYear),
            coverImage: Value(item.coverImage),
            status: Value(item.status),
              totalCopies: item.totalCopies ?? 0, userId: userId, id: item.id ?? -1,
            // authorName: Value(item.author),
          );

        }).toList(),
      );
    });
  }
  Future<bool> exists(int bookId, int userId) async {
    final result = await (select(favoriteBookTable)
      ..where((t) => t.id.equals(bookId) & t.userId.equals(userId)))
        .getSingleOrNull();

    return result != null;
  }

  // GET ALL USER BOOKS
  Future<List<ApiBook.Book>> getAllData(int userId) {
    return (select(favoriteBookTable)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.title)]))
        .get();
  }

  // DELETE SINGLE
  Future<void> deleteBook(int bookId, int userId) {
    return (delete(favoriteBookTable)
      ..where((t) => t.id.equals(bookId) & t.userId.equals(userId)))
        .go();
  }

  // DELETE ALL USER DATA
  Future<void> deleteAllUser(int userId) {
    return (delete(favoriteBookTable)
      ..where((t) => t.userId.equals(userId)))
        .go();
  }
}

abstract class IFavoriteBookTable {

  Future<ApiBook.Book?> getData();

  Future<List<ApiBook.Book>> getAllData(int userId);

  Future<int> insertData(ApiBook.Book book,int userId);

  Future<void> insertAllData(List<ApiBook.Book>? books,int userId);

  Future<void> deleteAll();

}