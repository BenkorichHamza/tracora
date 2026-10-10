import 'dart:convert';

import 'package:tracora/app/data/models/product_model.dart';

class BarcodeModel {
  final sql = """CREATE TABLE barcode (
    id STRING PRIMARY KEY,
    code STRING,  
    type STRING,
    createdAt INTEGER,
    updatedAt INTEGER,
    deletedAt INTEGER,
    product_ids STRING REFERENCES product (ids)
)""";

  final String? id;
  final String? code;
  final String? type;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final Product? product;
  BarcodeModel({
    this.id,
    this.code,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.product,
  });

  BarcodeModel copyWith({
    String? id,
    String? code,
    String? type,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    Product? product,
  }) {
    return BarcodeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (deletedAt != null) {
      result.addAll({'deletedAt': deletedAt});
    }
    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }

    return result;
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    return BarcodeModel(
      id: map['id'],
      code: map['code'],
      type: map['type'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeModel.fromJson(String source) =>
      BarcodeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BarcodeModel(id: $id, code: $code, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BarcodeModel &&
        other.id == id &&
        other.code == code &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        product.hashCode;
  }
}
