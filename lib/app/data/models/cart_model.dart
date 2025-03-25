import 'dart:convert';

import 'package:tracora/app/data/models/product_model.dart';

class Cart {
  final String sql = '''
CREATE TABLE cart (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER REFERENCES product (id) 
                       UNIQUE ON CONFLICT REPLACE,
    price      REAL,
    total      REAL,
    qte        REAL    DEFAULT (1) 
)
''';

  final int? id;
  final Product? product;
  final double? price;
  final double? total;
  final double? qte;
  Cart({this.id, this.product, this.price, this.total, this.qte});

  Cart copyWith({
    int? id,
    Product? product,
    double? price,
    double? total,
    double? qte,
  }) {
    return Cart(
      id: id ?? this.id,
      product: product ?? this.product,
      price: price ?? this.price,
      total: total ?? this.total,
      qte: qte ?? this.qte,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
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
      id: map['id']?.toInt(),
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
    return 'Cart(id: $id, product: $product, price: $price, total: $total, qte: $qte)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.id == id &&
        other.product == product &&
        other.price == price &&
        other.total == total &&
        other.qte == qte;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product.hashCode ^
        price.hashCode ^
        total.hashCode ^
        qte.hashCode;
  }
}
