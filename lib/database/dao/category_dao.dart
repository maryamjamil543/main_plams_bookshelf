import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/division_table.dart';
import 'package:flutter_base/models/response/login_response/Category.dart';
import 'package:flutter_base/models/response/sync/Division.dart';

import '../tables/category_table.dart';
part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoryTable])
class CategoryDao extends DatabaseAccessor<MyDatabase>
    with _$CategoryDaoMixin
    implements ICategoryTable {
  CategoryDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(categoryTable)).go();
  }

  @override
  Future<int> insertData(Category data) {
    return into(categoryTable).insertOnConflictUpdate(
      CategoryTableCompanion.insert(
        id: data.id??-1,
        name: data.name?? "",
      ),
    );
  }

  @override
  Future<Category?> getData() {
    return (select(categoryTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<Category>> getAllData() async {
    return await (select(categoryTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }
  // Future<List<Category>> getAllData() async {
  //   final data = await (select(categoryTable)).get();
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
  Future<void> insertAllData(List<Category>? list) async {
    return await batch((batch) {
      batch.insertAll(categoryTable, [
        CategoryTableCompanion.insert(
          id: -1,
            name: 'Please Select',
        ),
        for (Category item in list!)
          CategoryTableCompanion.insert(
            id: item.id!,
            name: item.name ?? "",
          ),
        // CategoryTableCompanion.insert(
        //   id: 1,
        //   name: 'Other (Add new)',
        // ),
      ]);
    });
  }
}

abstract class ICategoryTable {
  Future<List<Category>?> getAllData();
  Future<void> insertAllData(List<Category>? divisions);


  Future<void> deleteAll();
}
