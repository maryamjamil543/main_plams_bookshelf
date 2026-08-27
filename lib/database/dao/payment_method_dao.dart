import 'package:drift/drift.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import '../tables/payment_method_table.dart';
part 'payment_method_dao.g.dart';



@DriftAccessor(tables: [PaymentMethodTable])
class PaymentMethodDao extends DatabaseAccessor<MyDatabase>
    with _$PaymentMethodDaoMixin
    implements IPaymentMethodTable {
  PaymentMethodDao(super.db);

  @override
  Future<void> deleteAll() {
    return (delete(paymentMethodTable)).go();
  }

  Future<int> insertData(PaymentMethod data) {
    return into(paymentMethodTable).insertOnConflictUpdate(
      PaymentMethodTableCompanion.insert(
        id: data.id!,
        name: data.name ?? '',
        details: Value(data.details),
        instructions: Value(data.instructions),
      ),
    );
  }
  @override
  Future<PaymentMethod?> getData() {
    return (select(paymentMethodTable)..limit(1)).getSingleOrNull();
  }


  @override
  Future<List<PaymentMethod>> getAllData() async {
    return await (select(paymentMethodTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .get();
  }



  @override
  Future<void> insertAllData(List<PaymentMethod> list) async {
    await batch((batch) {
      batch.insertAll(
        paymentMethodTable,
        [
          for (PaymentMethod item in list)
            PaymentMethodTableCompanion.insert(
              id: item.id!,
              name: item.name ?? '',
              details: Value(item.details),
              instructions: Value(item.instructions),
            )
        ],
      );
    });
  }
}

abstract class IPaymentMethodTable {
  Future<PaymentMethod?> getData();
  Future<List<PaymentMethod>?> getAllData();
  Future<void> insertAllData(List<PaymentMethod> user);
  Future<void> deleteAll();
}
