import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/login_response/Country.dart';
import '../tables/country_table.dart';
part 'country_dao.g.dart';



@DriftAccessor(tables: [CountryTable])
class CountryDao extends DatabaseAccessor<MyDatabase>
    with _$CountryDaoMixin
    implements ICountryTable {
  CountryDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(countryTable)).go();
  }

  @override
  Future<int> insertData(Country data) {
    return into(countryTable).insertOnConflictUpdate(
      CountryTableCompanion.insert(



        name: data.name ?? "",
        cities: Value(data.citiesToDb()),
      ),
    );
  }

  @override
  Future<Country?> getData() {
    return (select(countryTable)..limit(1)).getSingleOrNull();
  }

  // Future<Country?> getDataById(int id) {
  //   // return (select(countryTable)..where((tbl)=>tbl.name.equals(name))..limit(1)).getSingleOrNull();
  // }

  @override
  Future<List<Country>> getAllData() async {
    return await (select(countryTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .get();
  }

  @override
  Future<List<Country>> getAllDataByProvinceId(int provinceId) async {
    return await (select(countryTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .get();
  }

  @override
  Future<void> insertAllData(List<Country> list) async {
    await batch((batch) {
      batch.insertAll(
        countryTable,
        list.map((item) => CountryTableCompanion.insert(
          name: item.name ?? "",
          cities: Value(item.citiesToDb()),
        )),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}

abstract class ICountryTable {
  Future<Country?> getData();
  // Future<Country?> getDataById(int id);

  Future<List<Country>?> getAllData();

  Future<List<Country>?> getAllDataByProvinceId(int provinceId);

  Future<int> insertData(Country user);

  Future<void> insertAllData(List<Country> user);


  Future<void> deleteAll();
}
