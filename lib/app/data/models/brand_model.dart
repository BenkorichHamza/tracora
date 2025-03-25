import 'dart:convert';

import 'package:get/get.dart';

class Brand {
  final int? id;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final int? remoteId;
  final String? name;
  final String? nameAr;
  final String? img;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final String sql = '''CREATE TABLE brand (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    ids  STRING UNIQUE,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    remoteId    INTEGER,
    name  TEXT,
    nameAr  TEXT,
    img   STRING,
    createdAt INTEGER,
    updatedAt INTEGER,
    deletedAt INTEGER
)''';

  Brand({
    this.id,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.remoteId,
    this.name,
    this.nameAr,
    this.img,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Brand copyWith({
    int? id,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    int? remoteId,
    String? name,
    String? nameAr,
    String? img,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
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
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
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

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id']?.toInt(),
      ids: map['ids'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      remoteId: map['remoteId']?.toInt(),
      name: map['name'],
      nameAr: map['nameAr'],
      img: map['img'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Brand.fromJson(String source) => Brand.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Brand(id: $id, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, remoteId: $remoteId, name: $name, nameAr: $nameAr, img: $img, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Brand &&
        other.id == id &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.remoteId == remoteId &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.img == img &&
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
        name.hashCode ^
        nameAr.hashCode ^
        img.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
