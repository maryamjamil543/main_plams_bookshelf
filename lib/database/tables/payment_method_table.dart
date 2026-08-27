import 'package:drift/drift.dart';

import '../../models/response/login_response/PaymentMethod.dart';
@UseRowClass(PaymentMethod, constructor: "fromDb")
class PaymentMethodTable extends Table {

  IntColumn get id => integer().unique()();

  TextColumn get name => text()();

  TextColumn get details => text().nullable()();

  TextColumn get instructions => text().nullable()();
}