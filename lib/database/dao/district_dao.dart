import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/district_table.dart';
import 'package:flutter_base/models/response/sync/District.dart';
part 'district_dao.g.dart';

@DriftAccessor(tables: [DistrictTable])
class DistrictDao extends DatabaseAccessor<MyDatabase>
    with _$DistrictDaoMixin
    implements IDistrictTable {
  DistrictDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(districtTable)).go();
  }

  @override
  Future<int> insertData(District data) {
    return into(districtTable).insertOnConflictUpdate(
      DistrictTableCompanion.insert(
        id: data.id??-1,
        district: data.district ?? "",
        divisionIdFk: data.divisionIdFk??-1,
      ),
    );
  }

  @override
  Future<District?> getData() {
    return (select(districtTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<District>> getAllData() async {
    return await (select(districtTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.district, mode: OrderingMode.asc)
          ]))
        .get();
  }

  @override
  Future<List<District>> getAllDataByDivisionId(int provinceId) async {
    return await (select(districtTable)
          ..where((tbl) => tbl.divisionIdFk.equals(provinceId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.district, mode: OrderingMode.asc)
          ]))
        .get();
  }

  @override
  Future<void> insertAllData(List<District>? list) async {
    return await batch((batch) {
      batch.insertAll(districtTable, [
        DistrictTableCompanion.insert(
          id: -1,
          district: 'Please Select',
          divisionIdFk: -1,
        ),
        for (District item in list!)
          DistrictTableCompanion.insert(
            id: item.id??-1,
            district: item.district??"",
            divisionIdFk: item.divisionIdFk??-1,
          )
      ]);
    });
  }
}

abstract class IDistrictTable {
  Future<District?> getData();

  Future<List<District>?> getAllData();

  Future<List<District>?> getAllDataByDivisionId(int provinceId);

  Future<int> insertData(District user);

  Future<void> insertAllData(List<District>? user);

  // Future <int> updateUser(LoginResponseTableCompanion user);
  //
  // Future <int> updateUserData(UserDetailsResponse usr) ;
  //
  // Future <void> deleteUserRecord(LoginResponseTableCompanion user);

  Future<void> deleteAll();
}
