import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

class CategoryModel {
  final String sql = '''
CREATE TABLE category (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    ids  STRING UNIQUE,
    createdBy  STRING,
    data       BLOB,
    updatedBy  STRING,
    deletedBy  STRING,
    remoteId    INTEGER,
    name       TEXT,
    nameAr       TEXT,
    img         STRING,
    image_id    INTEGER REFERENCES image (id),
    [order]     INTEGER,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER
);

''';
  final int? id;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final int? remoteId;
  final Uint8List? data;
  final String? name;
  final String? nameAr;
  final String? img;
  final int? order;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  CategoryModel({
    this.id,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.remoteId,
    this.data,
    this.name,
    this.nameAr,
    this.img,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  CategoryModel copyWith({
    int? id,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    int? remoteId,
    Uint8List? data,
    String? name,
    String? nameAr,
    String? img,
    int? order,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      remoteId: remoteId ?? this.remoteId,
      data: data ?? this.data,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      img: img ?? this.img,
      order: order ?? this.order,
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
    if (remoteId != null) {
      result.addAll({'remoteId': remoteId});
    }
    if (data != null) {
      result.addAll({'data': data});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
    }
    if (img != null) {
      result.addAll({'img': img});
    }
    if (order != null) {
      result.addAll({'order': order});
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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt(),
      ids: map['ids'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      remoteId: map['remoteId']?.toInt(),
      data: map['data'],
      name: map['name'],
      nameAr: map['nameAr'],
      img: map['img'],
      order: map['order']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, remoteId: $remoteId, data: $data, name: $name, nameAr: $nameAr, img: $img, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.remoteId == remoteId &&
        other.data == data &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.img == img &&
        other.order == order &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ids.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        remoteId.hashCode ^
        data.hashCode ^
        name.hashCode ^
        nameAr.hashCode ^
        img.hashCode ^
        order.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
