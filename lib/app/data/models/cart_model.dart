import 'dart:convert';

import 'package:tracora/app/data/models/product_model.dart';

class Cart {
  final String sql = '''
CREATE TABLE cart (
    ids         STRING PRIMARY KEY,
    product_ids STRING REFERENCES product (ids) ,
    price      REAL,
    total      REAL,
    qte        REAL    DEFAULT (1) 
)
''';

  final String? ids;
  final Product? product;
  final double? price;
  final double? total;
  final double? qte;
  Cart({this.ids, this.product, this.price, this.total, this.qte});

  Cart copyWith({
    String? ids,
    Product? product,
    double? price,
    double? total,
    double? qte,
  }) {
    return Cart(
      ids: ids ?? this.ids,
      product: product ?? this.product,
      price: price ?? this.price,
      total: total ?? this.total,
      qte: qte ?? this.qte,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (ids != null) {
      result.addAll({'ids': ids});
    }
    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (total != null) {
      result.addAll({'total': total});
    }
    if (qte != null) {
      result.addAll({'qte': qte});
    }

    return result;
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      ids: map['ids'],
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      price: map['price']?.toDouble(),
      total: map['total']?.toDouble(),
      qte: map['qte']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(ids: $ids, product: $product, price: $price, total: $total, qte: $qte)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.ids == ids &&
        other.product == product &&
        other.price == price &&
        other.total == total &&
        other.qte == qte;
  }

  @override
  int get hashCode {
    return ids.hashCode ^
        product.hashCode ^
        price.hashCode ^
        total.hashCode ^
        qte.hashCode;
  }
}
