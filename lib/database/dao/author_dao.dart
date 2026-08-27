import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/division_table.dart';
import 'package:flutter_base/models/response/sync/Division.dart';

import '../../models/response/login_response/Author.dart';
import '../tables/author.dart';
part 'author_dao.g.dart';

@DriftAccessor(tables: [AuthorTable])
class AuthorDao extends DatabaseAccessor<MyDatabase>
    with _$AuthorDaoMixin
    implements IAuhthorTable {
  AuthorDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(authorTable)).go();
  }

  @override
  Future<int> insertData(AuthorBaseData data) {
    return into(authorTable).insertOnConflictUpdate(
      AuthorTableCompanion.insert(
        id: data.id??-1,
        name: data.name?? "",
      ),
    );
  }

  @override
  Future<AuthorBaseData?> getData() {
    return (select(authorTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<AuthorBaseData>> getAllData() async {
    return await (select(authorTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }

  // Future<List<AuthorBaseData>> getAllData() async {
  //   final data = await (select(authorTable)).get();
  //
  //   data.sort((a, b) {
  //     if (a.id == -1) return -1; // Please Select first
  //     if (b.id == -1) return 1;
  //
  //     if (a.id == -2) return 1; // Other last
  //     if (b.id == -2) return -1;
  //
  //     return (a.id ?? 0).compareTo(b.id ?? 0);
  //   });
  //
  //   return data;
  // }

  @override
  Future<void> insertAllData(List<AuthorBaseData>? list) async {
    return await batch((batch) {
      batch.insertAll(authorTable, [
        AuthorTableCompanion.insert(
          id: -1,
          name: 'Please Select',
        ),

        for (AuthorBaseData item in list!)
          AuthorTableCompanion.insert(
            id: item.id!,
            name: item.name ?? "",
          ),
        //    AuthorTableCompanion.insert(
        //   id: 1,
        //   name: 'Other (Add new)',
        // ),

      ]);
    });
  }
}

abstract class IAuhthorTable {
  Future<List<AuthorBaseData>?> getAllData();
  Future<void> insertAllData(List<AuthorBaseData>? divisions);
  Future<void> deleteAll();
}
