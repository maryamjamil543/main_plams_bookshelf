import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/login_response/Country.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import '../tables/country_table.dart';
import '../tables/platform_package_table.dart';
part 'platform_package_dao.g.dart';



@DriftAccessor(tables: [PlatformPackageTable])
class PlatformPackageDao extends DatabaseAccessor<MyDatabase>
    with _$PlatformPackageDaoMixin
    implements IPlatformPackageTable {
  PlatformPackageDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(platformPackageTable)).go();
  }

  Future<int> insertData(PlatformPackage data) {
    return into(platformPackageTable).insertOnConflictUpdate(
      PlatformPackageTableCompanion.insert(
        id: data.id!,
        name: Value(data.name),
        price: Value(data.price),
        durationType: Value(data.durationType),
        durationValue: Value(data.durationValue),
        maxLibraries: Value(data.maxLibraries),
        description: Value(data.description),
      ),
    );
  }
  @override
  Future<PlatformPackage?> getData() {
    return (select(platformPackageTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<PlatformPackage?> getDataById(int id) {
    return (select(platformPackageTable)..where((tbl)=>tbl.id.equals(id))..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<PlatformPackage>> getAllData() async {
    return await (select(platformPackageTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .get();
  }

  @override
  Future<List<PlatformPackage>> getAllDataByProvinceId(int provinceId) async {
    return await (select(platformPackageTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .get();
  }

  @override
  Future<void> insertAllData(List<PlatformPackage> list) async {
    await batch((batch) {
      batch.insertAll(
        platformPackageTable,
        [
          for (PlatformPackage item in list)
            PlatformPackageTableCompanion.insert(
              id: item.id!,
              name: Value(item.name),
              price: Value(item.price),
              durationType: Value(item.durationType),
              durationValue: Value(item.durationValue),
              maxLibraries: Value(item.maxLibraries),
              description: Value(item.description),
            )
        ],
      );
    });
  }
}

abstract class IPlatformPackageTable {
  Future<PlatformPackage?> getData();
  Future<PlatformPackage?> getDataById(int id);

  Future<List<PlatformPackage>?> getAllData();

  Future<List<PlatformPackage>?> getAllDataByProvinceId(int provinceId);

  Future<int> insertData(PlatformPackage user);

  Future<void> insertAllData(List<PlatformPackage> user);


  Future<void> deleteAll();
}
