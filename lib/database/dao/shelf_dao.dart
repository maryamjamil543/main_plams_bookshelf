import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/book_response/Self.dart';
import '../tables/shelf.dart';
part 'shelf_dao.g.dart';

@DriftAccessor(tables: [ShelfTable])
class ShelfDao extends DatabaseAccessor<MyDatabase>
    with _$ShelfDaoMixin
    implements IShelfTable {
  ShelfDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(shelfTable)).go();
  }

  @override
  Future<int> insertData(Shelf data) {
    return into(shelfTable).insertOnConflictUpdate(
      ShelfTableCompanion.insert(
        id: data.id??-1,
        name: data.name?? "", libraryId: data.libraryId ??-1,
      ),
    );
  }

  @override
  Future<Shelf?> getData() {
    return (select(shelfTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<Shelf>> getAllData() async {
    return await (select(shelfTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }



  @override
  Future<void> insertAllData(List<Shelf>? list) async {
    return await batch((batch) {
      batch.insertAll(shelfTable, [
        ShelfTableCompanion.insert(
          id: -1,
          name: 'Please Select', libraryId: -1,
        ),
        for (Shelf item in list!)
          ShelfTableCompanion.insert(
            id: item.id??-1,
            name: item.name ?? "", libraryId: item.libraryId ??-1,
          )
      ]);
    });
  }
}

abstract class IShelfTable {
  Future<List<Shelf>?> getAllData();
  Future<void> insertAllData(List<Shelf>? divisions);
  Future<void> deleteAll();
}
