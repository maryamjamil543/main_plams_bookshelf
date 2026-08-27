import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/login_response/Donor.dart';
import '../tables/donor.dart';
part 'donor_dao.g.dart';

@DriftAccessor(tables: [DonorTable])
class DonorDao extends DatabaseAccessor<MyDatabase>
    with _$DonorDaoMixin
    implements IDonorTable {
  DonorDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(donorTable)).go();
  }

  @override
  Future<int> insertData(Donor data) {
    return into(donorTable).insertOnConflictUpdate(
      DonorTableCompanion.insert(
        id: data.id ?? -1,
        name: data.name ?? "",
      ),
    );
  }

  @override
  Future<Donor?> getData() {
    return (select(donorTable)
      ..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<Donor>> getAllData() async {
    return await (select(donorTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }

  // Future<List<Donor>> getAllData() async {
  //   final data = await (select(donorTable)).get();
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
  //   return data;
  // }

  @override
  Future<void> insertAllData(List<Donor>? list) async {
    return await batch((batch) {
      batch.insertAll(donorTable, [
        DonorTableCompanion.insert(
          id: -1,
          name: 'Please Select',
        ),
        for (Donor item in list!)
          DonorTableCompanion.insert(
            id: item.id!,
            name: item.name ?? "",
          ),
      ]);
    });
  }
}

abstract class IDonorTable {
  Future<List<Donor>?> getAllData();
  Future<void> insertAllData(List<Donor>? divisions);
  Future<void> deleteAll();
}
