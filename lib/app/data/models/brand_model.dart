import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

class Brand {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? name;
  final String? nameAr;
  final String? image;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final String sql = '''CREATE TABLE brand (
    id  STRING PRIMARY KEY,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    name  TEXT,
    nameAr  TEXT,
    image   STRING,
    createdAt INTEGER,
    updatedAt INTEGER,
    deletedAt INTEGER
)''';

  Brand({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name,
    this.nameAr,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Brand copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? name,
    String? nameAr,
    String? image,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
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
    if (image != null) {
      result.addAll({'image': image});
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
      id: map['id'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      name: map['name'],
      nameAr: map['nameAr'],
      image: map['image'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Brand.fromJson(String source) => Brand.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Brand(id: $id, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, name: $name, nameAr: $nameAr, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Brand &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        name.hashCode ^
        nameAr.hashCode ^
        image.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
