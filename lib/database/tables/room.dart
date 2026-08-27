import 'package:drift/drift.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';

import '../../models/response/login_response/Category.dart';
@UseRowClass(Room, constructor: "fromDb")
class RoomTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get libraryId  => integer()();
}