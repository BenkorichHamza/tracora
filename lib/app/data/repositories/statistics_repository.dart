import 'package:tracora/app/core/db_helper.dart';
import 'package:tracora/app/data/models/statistic_model.dart';

class StatisticsRepository {
  final DbHelper _dbHelper = DbHelper();
  Future<StatisticModel> getStatistic({int? from, int? to}) async {
    from = from ?? 0;
    to = to ?? DateTime.now().millisecondsSinceEpoch;
    var db = await _dbHelper.db;
    var maps = await db.rawQuery('''
SELECT 
  (SELECT SUM(amount) FROM money_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to)  AS totalCustomerPayment,
  (SELECT SUM(amount) FROM money_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to)  AS totalSupplierPayment,
  (SELECT SUM(amount) FROM money_transaction WHERE type = 'fees' AND dateTime BETWEEN $from AND $to) AS totalFeesPayment,
  (SELECT SUM(payment) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) AS totalPurchasePayment,
  (SELECT SUM(payment) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) AS totalSalePayment,
  (SELECT SUM(toPay) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) AS totalPurchase,
  (SELECT SUM(toPay) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) AS totalSale,

  (SELECT SUM(toPay) - COALESCE(SUM(payment), 0)-(SELECT SUM(amount) FROM money_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) AS totalCustomerCredit,
  (SELECT SUM(toPay) - COALESCE(SUM(payment), 0) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to)-(SELECT SUM(amount) FROM money_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) AS totalSupplierCredit,

  ((SELECT SUM(toPay) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) 
    - (SELECT SUM(toPay) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) 
    - (SELECT SUM(amount) FROM money_transaction WHERE type = 'fees' AND dateTime BETWEEN $from AND $to)) AS totalBenefit,

  (SELECT SUM(toPay) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) - 
  (SELECT SUM(toPay) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) AS totalStockValue,

  (SELECT COUNT(*) FROM stock_transaction WHERE type = 'purchase' AND dateTime BETWEEN $from AND $to) AS purchaseCount,
  (SELECT COUNT(*) FROM stock_transaction WHERE type = 'sale' AND dateTime BETWEEN $from AND $to) AS saleCount,
  (SELECT COUNT(*) FROM product) AS productCount,
  (SELECT COUNT(*) FROM user WHERE type = 'customer') AS customerCount,
  (SELECT COUNT(*) FROM user WHERE type = 'supplier') AS supplierCount;

''');
    return StatisticModel.fromMap(maps[0]);
  }
}
