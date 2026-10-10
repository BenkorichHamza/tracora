import 'dart:convert';

import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';

class ProductTransaction {
  final String sql = '''
CREATE TABLE product_transaction (
    transactionId STRING REFERENCES stock_transaction (id),
    productId     STRING REFERENCES product (id),
    direction      INTEGER,
    qte            REAL,
    price          REAL,
    tax            REAL
)
''';
  final StockTransaction? transaction;
  final Product? product;
  final int? direction;
  final double? price;
  final double? qte;
  ProductTransaction({
    this.transaction,
    this.product,
    this.direction,
    this.price,
    this.qte,
  });

  ProductTransaction copyWith({
    StockTransaction? transaction,
    Product? product,
    int? direction,
    double? price,
    double? qte,
  }) {
    return ProductTransaction(
      transaction: transaction ?? this.transaction,
      product: product ?? this.product,
      direction: direction ?? this.direction,
      price: price ?? this.price,
      qte: qte ?? this.qte,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (transaction != null) {
      result.addAll({'transaction': transaction!.toMap()});
    }
    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }
    if (direction != null) {
      result.addAll({'direction': direction});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (qte != null) {
      result.addAll({'qte': qte});
    }

    return result;
  }

  Map<String, dynamic> toSqfliteMap() {
    final result = <String, dynamic>{};

    if (transaction?.id != null) {
      result.addAll({'transactionIds': transaction?.id});
    }
    if (product?.id != null) {
      result.addAll({'productId': product?.id});
    }
    if (direction != null) {
      result.addAll({'direction': direction});
    }
    if (price != null) {
      result.addAll({'price': price});
    }

    if (qte != null) {
      result.addAll({'qte': qte});
    }

    return result;
  }

  factory ProductTransaction.fromMap(Map<String, dynamic> map) {
    return ProductTransaction(
      transaction:
          map['transaction'] != null
              ? StockTransaction.fromMap(map['transaction'])
              : null,
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      direction: map['direction']?.toInt(),
      price: map['price']?.toDouble(),
      qte: map['qte']?.toDouble(),
    );
  }

  factory ProductTransaction.fromApiMap(Map<String, dynamic> map) {
    return ProductTransaction(
      transaction:
          map['transaction_id'] != null
              ? StockTransaction(id: map['transaction_id'])
              : null,
      product:
          map['product_id'] != null ? Product(id: map['product_id']) : null,
      direction: map['direction']?.toInt(),
      price: map['price']?.toDouble(),
      qte: map['qte']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductTransaction.fromJson(String source) =>
      ProductTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductTransaction(transactionId: $transaction, product: $product, direction: $direction, price: $price, qte: $qte)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductTransaction &&
        other.transaction == transaction &&
        other.product == product &&
        other.direction == direction &&
        other.price == price &&
        other.qte == qte;
  }

  @override
  int get hashCode {
    return transaction.hashCode ^
        product.hashCode ^
        direction.hashCode ^
        price.hashCode ^
        qte.hashCode;
  }

  double get total => (qte ?? 0) * (price ?? 0);
  double get getSaleTotal => (qte ?? 0) * (product?.sellPrice ?? 0);
}
