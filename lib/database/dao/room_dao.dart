import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/database/tables/division_table.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';

import '../tables/room.dart';
part 'room_dao.g.dart';

@DriftAccessor(tables: [RoomTable])
class RoomDao extends DatabaseAccessor<MyDatabase>
    with _$RoomDaoMixin
    implements IRoomTable {
  RoomDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(roomTable)).go();
  }

  @override
  Future<int> insertData(Room data) {
    return into(roomTable).insertOnConflictUpdate(
      RoomTableCompanion.insert(
        id: data.id??-1,
        name: data.name?? "", libraryId: data.libraryId ??-1,
      ),
    );
  }

  @override
  Future<Room?> getData() {
    return (select(roomTable)..limit(1)).getSingleOrNull();
  }

  @override
  Future<List<Room>> getAllData() async {
    return await (select(roomTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }

  @override
  Future<void> insertAllData(List<Room>? list) async {
    return await batch((batch) {
      batch.insertAll(roomTable, [
        RoomTableCompanion.insert(
          id: -1,
          name: 'Please Select', libraryId: -1,
        ),
        for (Room item in list!)
          RoomTableCompanion.insert(
            id: item.id!,
            name: item.name ?? "",
            libraryId: item.id!,
          )
      ]);
    });
  }
}

abstract class IRoomTable {
  Future<List<Room>?> getAllData();
  Future<void> insertAllData(List<Room>? divisions);
  Future<void> deleteAll();
}
