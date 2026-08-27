import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_base/database/dao/district_dao.dart';
import 'package:flutter_base/database/dao/division_dao.dart';
import 'package:flutter_base/database/dao/platform_package_dao.dart';
import 'package:flutter_base/database/dao/payment_method_dao.dart';
import 'package:flutter_base/database/dao/unsent_dao.dart';
import 'package:flutter_base/database/tables/author.dart';
import 'package:flutter_base/database/tables/category_table.dart';
import 'package:flutter_base/database/tables/country_table.dart';
import 'package:flutter_base/database/tables/district_table.dart';
import 'package:flutter_base/database/tables/division_table.dart';
import 'package:flutter_base/database/tables/donor.dart';
import 'package:flutter_base/database/tables/favorite_book_table.dart';
import 'package:flutter_base/database/tables/payment_method_table.dart';
import 'package:flutter_base/database/tables/platform_package_table.dart';
import 'package:flutter_base/database/tables/room.dart';
import 'package:flutter_base/database/tables/shelf.dart';
import 'package:flutter_base/database/tables/unsent_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/response/Unsent.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/book_response/Self.dart';
import '../models/response/login_response/Author.dart';
import '../models/response/login_response/Category.dart';
import '../models/response/login_response/Country.dart';
import '../models/response/login_response/Donor.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../models/response/login_response/PlatformPackage.dart';
import '../models/response/login_response/Room.dart';
import '../models/response/sync/District.dart';
import '../models/response/sync/Division.dart';
import 'dao/author_dao.dart';
import 'dao/category_dao.dart';
import 'dao/country_dao.dart';
import 'dao/donor_dao.dart';
import 'dao/favorite_book_dao.dart';
import 'dao/room_dao.dart';
import 'dao/shelf_dao.dart';

part 'my_database.g.dart';

@DriftDatabase(tables: [
  UnsentTable,
  DivisionTable,
  DistrictTable,
  DonorTable,
  AuthorTable,
  RoomTable,
  CategoryTable,
  ShelfTable,
  CountryTable,
  PlatformPackageTable,
  PaymentMethodTable,
  FavoriteBookTable
], daos: [
  UnsentDao,
  CountryDao,
  PlatformPackageDao,
  PaymentMethodDao,
  CategoryDao,
  DonorDao,
  RoomDao,
  ShelfDao,
  AuthorDao,
  DistrictDao,
  DivisionDao,
  FavoriteBookDao,

])


class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());


  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
