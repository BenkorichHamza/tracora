import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:tracora/app/data/models/barcode.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';

class Product {
  final String sql = '''

CREATE TABLE product (
    id         STRING PRIMARY KEY,
    createdBy   STRING,
    updatedBy   STRING,
    deletedBy   STRING,
    alert       DOUBLE,
    data        BLOB,
    stock       DOUBLE,
    name        TEXT,
    nameAr      TEXT,
    description TEXT,
    isInteger   BOOLEAN,
    isOnline    BOOLEAN,
    inputPrice  BOOLEAN,
    barcode     TEXT,
    code        STRING,
    unity       STRING,
    brandId   STRING REFERENCES brand (id),
    packaging   INTEGER,
    buyPrice    REAL,
    sellPrice   DOUBLE,
    sellPrice1  DOUBLE,
    sellPrice2  DOUBLE,
    image         STRING,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER,
    tva         DOUBLE,
    marge1      DOUBLE,
    marge2      DOUBLE,
    marge       DOUBLE,
    ttc         DOUBLE,
    fabDate     INTEGER,
    perDate     INTEGER,
    stockValue  DOUBLE
)
''';

  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? name;
  final String? nameAr;
  final double? alert;
  final double? rest;
  final double? packaging;
  final bool? isInteger;
  final double? stock;
  final String? barcode;
  final String? unity;
  final Brand? brand;
  final List<CategoryModel>? categories;
  final double? buyPrice;
  final double? sellPrice;
  final double? sellPrice1;
  final double? sellPrice2;
  final double? tva;
  final double? ttc;
  final double? marge;
  final double? marge1;
  final double? marge2;
  final String? code;
  final double? stockValue;
  final int? fabDate;
  final int? perDate;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final List<BarcodeModel>? barcodes;
  Product({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name,
    this.nameAr,
    this.alert,
    this.rest,
    this.packaging,
    this.isInteger,
    this.stock,
    this.barcode,
    this.unity,
    this.brand,
    this.categories,
    this.buyPrice,
    this.sellPrice,
    this.sellPrice1,
    this.sellPrice2,
    this.tva,
    this.ttc,
    this.marge,
    this.marge1,
    this.marge2,
    this.code,
    this.stockValue,
    this.fabDate,
    this.perDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.barcodes,
  });

  Product copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? name,
    String? nameAr,
    double? alert,
    double? rest,
    double? packaging,
    bool? isInteger,
    double? stock,
    String? barcode,
    String? unity,
    Brand? brand,
    List<CategoryModel>? categories,
    double? buyPrice,
    double? sellPrice,
    double? sellPrice1,
    double? sellPrice2,
    double? tva,
    double? ttc,
    double? marge,
    double? marge1,
    double? marge2,
    String? code,
    double? stockValue,
    int? fabDate,
    int? perDate,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    List<BarcodeModel>? barcodes,
  }) {
    return Product(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      alert: alert ?? this.alert,
      rest: rest ?? this.rest,
      packaging: packaging ?? this.packaging,
      isInteger: isInteger ?? this.isInteger,
      stock: stock ?? this.stock,
      barcode: barcode ?? this.barcode,
      unity: unity ?? this.unity,
      brand: brand ?? this.brand,
      categories: categories ?? this.categories,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      sellPrice1: sellPrice1 ?? this.sellPrice1,
      sellPrice2: sellPrice2 ?? this.sellPrice2,
      tva: tva ?? this.tva,
      ttc: ttc ?? this.ttc,
      marge: marge ?? this.marge,
      marge1: marge1 ?? this.marge1,
      marge2: marge2 ?? this.marge2,
      code: code ?? this.code,
      stockValue: stockValue ?? this.stockValue,
      fabDate: fabDate ?? this.fabDate,
      perDate: perDate ?? this.perDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      barcodes: barcodes ?? this.barcodes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (createdBy != null) {
      result.addAll({'createdBy': createdBy});
    }
    if (updatedBy != null) {
      result.addAll({'updatedBy': updatedBy});
    }
    if (deletedBy != null) {
      result.addAll({'deletedBy': deletedBy});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
    }
    if (alert != null) {
      result.addAll({'alert': alert});
    }
    // if (rest != null) {
    //   result.addAll({'rest': rest});
    // }
    if (packaging != null) {
      result.addAll({'packaging': packaging});
    }
    if (isInteger != null) {
      // result.addAll({'isInteger': isInteger});
    }
    if (stock != null) {
      result.addAll({'stock': stock});
    }
    if (barcode != null) {
      result.addAll({'barcode': barcode});
    }
    if (unity != null) {
      result.addAll({'unity': unity});
    }
    if (brand != null) {
      result.addAll({'brandId': brand!.id});
    }
    // if (categories != null) {
    //   result.addAll({'categories': categories!.map((x) => x.id).toList()});
    // }
    if (buyPrice != null) {
      result.addAll({'buyPrice': buyPrice});
    }
    if (sellPrice != null) {
      result.addAll({'sellPrice': sellPrice});
    }
    if (sellPrice1 != null) {
      result.addAll({'sellPrice1': sellPrice1});
    }
    if (sellPrice2 != null) {
      result.addAll({'sellPrice2': sellPrice2});
    }
    if (tva != null) {
      result.addAll({'tva': tva});
    }
    if (ttc != null) {
      result.addAll({'ttc': ttc});
    }
    if (marge != null) {
      result.addAll({'marge': marge});
    }
    if (marge1 != null) {
      result.addAll({'marge1': marge1});
    }
    if (marge2 != null) {
      result.addAll({'marge2': marge2});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (stockValue != null) {
      result.addAll({'stockValue': stockValue});
    }
    if (fabDate != null) {
      result.addAll({'fabDate': fabDate});
    }
    if (perDate != null) {
      result.addAll({'perDate': perDate});
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
    if (barcodes != null) {
      result.addAll({'barcodes': barcodes!.map((x) => x?.toMap()).toList()});
    }

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      name: map['name'],
      nameAr: map['nameAr'],
      alert: map['alert']?.toDouble(),
      rest: map['rest']?.toDouble(),
      packaging: map['packaging']?.toDouble(),
      isInteger: map['isInteger'] == 1,
      stock: map['stock']?.toDouble(),
      barcode: map['barcode'],
      unity: map['unity'],
      brand: map['brand'] != null ? Brand.fromMap(map['brand']) : null,
      categories:
          map['categories'] != null
              ? List<CategoryModel>.from(
                map['categories']?.map((x) => CategoryModel.fromMap(x)),
              )
              : null,
      buyPrice: map['buyPrice']?.toDouble(),
      sellPrice: map['sellPrice']?.toDouble(),
      sellPrice1: map['sellPrice1']?.toDouble(),
      sellPrice2: map['sellPrice2']?.toDouble(),
      tva: map['tva']?.toDouble(),
      ttc: map['ttc']?.toDouble(),
      marge: map['marge']?.toDouble(),
      marge1: map['marge1']?.toDouble(),
      marge2: map['marge2']?.toDouble(),
      code: map['code']?.toString(),
      stockValue: map['stockValue']?.toDouble(),
      fabDate: map['fabDate']?.toInt(),
      perDate: map['perDate']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      barcodes:
          map['barcodes'] != null
              ? List<BarcodeModel>.from(
                map['barcodes']?.map((x) => BarcodeModel.fromMap(x)),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, name: $name, nameAr: $nameAr, alert: $alert, rest: $rest, packaging: $packaging, isInteger: $isInteger, stock: $stock, barcode: $barcode, unity: $unity, brand: $brand, categories: $categories, buyPrice: $buyPrice, sellPrice: $sellPrice, sellPrice1: $sellPrice1, sellPrice2: $sellPrice2, tva: $tva, ttc: $ttc, marge: $marge, marge1: $marge1, marge2: $marge2, code: $code, stockValue: $stockValue, fabDate: $fabDate, perDate: $perDate, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, barcodes: $barcodes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.alert == alert &&
        other.rest == rest &&
        other.packaging == packaging &&
        other.isInteger == isInteger &&
        other.stock == stock &&
        other.barcode == barcode &&
        other.unity == unity &&
        other.brand == brand &&
        listEquals(other.categories, categories) &&
        other.buyPrice == buyPrice &&
        other.sellPrice == sellPrice &&
        other.sellPrice1 == sellPrice1 &&
        other.sellPrice2 == sellPrice2 &&
        other.tva == tva &&
        other.ttc == ttc &&
        other.marge == marge &&
        other.marge1 == marge1 &&
        other.marge2 == marge2 &&
        other.code == code &&
        other.stockValue == stockValue &&
        other.fabDate == fabDate &&
        other.perDate == perDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        listEquals(other.barcodes, barcodes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        name.hashCode ^
        nameAr.hashCode ^
        alert.hashCode ^
        rest.hashCode ^
        packaging.hashCode ^
        isInteger.hashCode ^
        stock.hashCode ^
        barcode.hashCode ^
        unity.hashCode ^
        brand.hashCode ^
        categories.hashCode ^
        buyPrice.hashCode ^
        sellPrice.hashCode ^
        sellPrice1.hashCode ^
        sellPrice2.hashCode ^
        tva.hashCode ^
        ttc.hashCode ^
        marge.hashCode ^
        marge1.hashCode ^
        marge2.hashCode ^
        code.hashCode ^
        stockValue.hashCode ^
        fabDate.hashCode ^
        perDate.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        barcodes.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
  List<double> get prices => [sellPrice ?? 0, sellPrice1 ?? 0, sellPrice2 ?? 0];
  double getPrice<T>(int sellMode) =>
      [Sale, Customer].contains(T) ? prices[sellMode] ?? 0 : buyPrice ?? 0;
}
