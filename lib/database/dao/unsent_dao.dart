import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/unsent_table.dart';
import 'package:flutter_base/models/response/Unsent.dart';

part 'unsent_dao.g.dart';

@DriftAccessor(tables: [UnsentTable])
class UnsentDao extends DatabaseAccessor<MyDatabase>
    with _$UnsentDaoMixin
    implements IUnsentTable {
  UnsentDao(super.db);

  @override
  Future<void> deleteAll() {
     return (delete(unsentTable)).go();
  }

  @override
  Future<List<Unsent>?> getAllData() async {
    return await (select(unsentTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.rowId, mode: OrderingMode.asc)]))
        .get();
  }

  @override
  Future<Unsent?> getData() async {
      return (select(unsentTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<void> insertAllData(List<Unsent>? unsents) async {
    return await batch((batch) {
      batch.insertAll(unsentTable, [
        for (Unsent item in unsents!)
          UnsentTableCompanion.insert(
              unsentDateTime: item.unsentDateTime ?? -1,
              unsentType: item.unsentType ?? "",
              unsentData: item.unsentData ?? "",
              unsentTitle: item.unsentTitle ?? "")
      ]);
    });
  }

  @override
  Future<int> insertData(Unsent unsent) {
    return into(unsentTable).insertOnConflictUpdate(
      UnsentTableCompanion.insert(
          unsentDateTime: unsent.unsentDateTime ?? -1,
          unsentType: unsent.unsentType ?? "",
          unsentData: unsent.unsentData ?? "",
          unsentTitle: unsent.unsentTitle ?? ""),
    );
  }
}

abstract class IUnsentTable {
  Future<Unsent?> getData();

  Future<List<Unsent>?> getAllData();

  Future<int> insertData(Unsent unsent);

  Future<void> insertAllData(List<Unsent>? unsents);

  // Future <int> updateUser(LoginResponseTableCompanion user);
  //
  // Future <int> updateUserData(UserDetailsResponse usr) ;
  //
  // Future <void> deleteUserRecord(LoginResponseTableCompanion user);

  Future<void> deleteAll();
}