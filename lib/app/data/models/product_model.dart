import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/image_model.dart';

class Product {
  final String sql = '''
CREATE TABLE product (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    remoteId       INTEGER,
    ids  STRING UNIQUE,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    alert       DOUBLE,
    data       BLOB,
    stock       DOUBLE,
    name        TEXT,
    nameAr      TEXT,
    description      TEXT,
    isInteger   BOOLEAN,
    isOnline   BOOLEAN,
    inputPrice   BOOLEAN,
    barcode     TEXT,
    code       STRING,
    unity       STRING,
    brand_id    INTEGER REFERENCES brand (id),
    image_id    INTEGER REFERENCES image (id),
    packaging   INTEGER,
    buyPrice    REAL,
    sellPrice   DOUBLE,
    sellPrice1  DOUBLE,
    sellPrice2  DOUBLE,
    img         STRING,
    url         STRING,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER
)
''';

  final int? id;
  final int? remoteId;
  final Uint8List? data;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? name;
  final String? nameAr;
  final double? alert;
  final double? packaging;
  final bool? isInteger;
  final double? stock;
  final String? barcode;
  final String? unity;
  final Brand? brand;
  final ImageModel? image;
  final List<CategoryModel>? categories;
  final double? buyPrice;
  final double? sellPrice;
  final double? sellPrice1;
  final double? sellPrice2;
  final String? img;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  Product({
    this.id,
    this.remoteId,
    this.data,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name,
    this.nameAr,
    this.alert,
    this.packaging,
    this.isInteger,
    this.stock,
    this.barcode,
    this.unity,
    this.brand,
    this.image,
    this.categories,
    this.buyPrice,
    this.sellPrice,
    this.sellPrice1,
    this.sellPrice2,
    this.img,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Product copyWith({
    int? id,
    int? remoteId,
    Uint8List? data,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? name,
    String? nameAr,
    double? alert,
    double? packaging,
    bool? isInteger,
    double? stock,
    String? barcode,
    String? unity,
    Brand? brand,
    ImageModel? image,
    List<CategoryModel>? categories,
    double? buyPrice,
    double? sellPrice,
    double? sellPrice1,
    double? sellPrice2,
    String? img,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      data: data ?? this.data,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      alert: alert ?? this.alert,
      packaging: packaging ?? this.packaging,
      isInteger: isInteger ?? this.isInteger,
      stock: stock ?? this.stock,
      barcode: barcode ?? this.barcode,
      unity: unity ?? this.unity,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      categories: categories ?? this.categories,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      sellPrice1: sellPrice1 ?? this.sellPrice1,
      sellPrice2: sellPrice2 ?? this.sellPrice2,
      img: img ?? this.img,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (remoteId != null) {
      result.addAll({'remoteId': remoteId});
    }
    if (data != null) {
      result.addAll({'data': data});
    }
    if (ids != null) {
      result.addAll({'ids': ids});
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
    if (packaging != null) {
      result.addAll({'packaging': packaging});
    }
    if (isInteger != null) {
      result.addAll({'isInteger': isInteger});
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
      result.addAll({'brand': brand!.toMap()});
    }
    if (image != null) {
      result.addAll({'image': image!.toMap()});
    }
    if (categories != null) {
      result.addAll({
        'categories': categories!.map((x) => x?.toMap()).toList(),
      });
    }
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
    if (img != null) {
      result.addAll({'img': img});
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

    return result;
  }

  Map<String, dynamic> toSqliteMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (ids != null) {
      result.addAll({'ids': ids});
    }
    if (data != null) {
      result.addAll({'data': data});
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
    if (remoteId != null) {
      result.addAll({'remoteId': remoteId});
    }
    if (alert != null) {
      result.addAll({'alert': alert});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
    }
    if (barcode != null) {
      result.addAll({'barcode': barcode});
    }
    if (isInteger != null) {
      result.addAll({'isInteger': isInteger});
    }
    if (unity != null) {
      result.addAll({'unity': unity});
    }
    if (brand?.id != null) {
      result.addAll({'brand_id': brand!.id});
    }
    if (image?.id != null) {
      result.addAll({'image_id': image!.id});
    }
    // if (categories != null) {
    //   result.addAll({
    //     'categories': categories!.map((x) => x?.toMap()).toList(),
    //   });
    // }
    if (packaging != null) {
      result.addAll({'packaging': packaging});
    }
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
    if (img != null) {
      result.addAll({'img': img});
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

    return result;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt(),
      remoteId: map['remoteId']?.toInt(),
      data: map['data'],
      ids: map['ids'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      name: map['name'],
      nameAr: map['nameAr'],
      alert: map['alert']?.toDouble(),
      packaging: map['packaging']?.toDouble(),
      isInteger: map['isInteger'],
      stock: map['stock']?.toDouble(),
      barcode: map['barcode'],
      unity: map['unity'],
      brand: map['brand'] != null ? Brand.fromMap(map['brand']) : null,
      image: map['image'] != null ? ImageModel.fromMap(map['image']) : null,
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
      img: map['img'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, remoteId: $remoteId, data: $data, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, name: $name, nameAr: $nameAr, alert: $alert, packaging: $packaging, isInteger: $isInteger, stock: $stock, barcode: $barcode, unity: $unity, brand: $brand, image: $image, categories: $categories, buyPrice: $buyPrice, sellPrice: $sellPrice, sellPrice1: $sellPrice1, sellPrice2: $sellPrice2, img: $img, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.data == data &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.alert == alert &&
        other.packaging == packaging &&
        other.isInteger == isInteger &&
        other.stock == stock &&
        other.barcode == barcode &&
        other.unity == unity &&
        other.brand == brand &&
        other.image == image &&
        listEquals(other.categories, categories) &&
        other.buyPrice == buyPrice &&
        other.sellPrice == sellPrice &&
        other.sellPrice1 == sellPrice1 &&
        other.sellPrice2 == sellPrice2 &&
        other.img == img &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        remoteId.hashCode ^
        data.hashCode ^
        ids.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        name.hashCode ^
        nameAr.hashCode ^
        alert.hashCode ^
        packaging.hashCode ^
        isInteger.hashCode ^
        stock.hashCode ^
        barcode.hashCode ^
        unity.hashCode ^
        brand.hashCode ^
        image.hashCode ^
        categories.hashCode ^
        buyPrice.hashCode ^
        sellPrice.hashCode ^
        sellPrice1.hashCode ^
        sellPrice2.hashCode ^
        img.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
