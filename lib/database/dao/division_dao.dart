import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/division_table.dart';
import 'package:flutter_base/models/response/sync/Division.dart';
part 'division_dao.g.dart';

@DriftAccessor(tables: [DivisionTable])
class DivisionDao extends DatabaseAccessor<MyDatabase>
    with _$DivisionDaoMixin
    implements IDivisionTable {
  DivisionDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(divisionTable)).go();
  }

  @override
  Future<int> insertData(Division data) {
    return into(divisionTable).insertOnConflictUpdate(
      DivisionTableCompanion.insert(
        id: data.id??-1,
        division: data.division ?? "",
      ),
    );
  }

  @override
  Future<Division?> getData() {
    return (select(divisionTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<Division>> getAllData() async {
    return await (select(divisionTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.division, mode: OrderingMode.asc)
          ]))
        .get();
  }



  @override
  Future<void> insertAllData(List<Division>? list) async {
    return await batch((batch) {
      batch.insertAll(divisionTable, [
        DivisionTableCompanion.insert(
          id: -1,
          division: 'Please Select',
        ),
        for (Division item in list!)
          DivisionTableCompanion.insert(
            id: item.id??-1,
            division: item.division ?? "",
          )
      ]);
    });
  }
}

abstract class IDivisionTable {
  Future<Division?> getData();

  Future<List<Division>?> getAllData();


  Future<int> insertData(Division division);

  Future<void> insertAllData(List<Division>? divisions);

  // Future <int> updateUser(LoginResponseTableCompanion user);
  //
  // Future <int> updateUserData(UserDetailsResponse usr) ;
  //
  // Future <void> deleteUserRecord(LoginResponseTableCompanion user);

  Future<void> deleteAll();
}
