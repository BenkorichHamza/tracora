import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import 'package:tracora/app/data/models/image_model.dart';

class CategoryModel {
  final String sql = '''
CREATE TABLE category (
    id  STRING PRIMARY KEY,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    name       TEXT,
    nameAr       TEXT,
    image         STRING,
    [order]     INTEGER,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER
);

''';
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? name;
  final String? nameAr;
  final String? image;
  final int? order;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  CategoryModel({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name,
    this.nameAr,
    this.image,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  CategoryModel copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? name,
    String? nameAr,
    String? image,
    int? order,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
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
      id: map['id'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      name: map['name'],
      nameAr: map['nameAr'],
      image: map['image'],
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
    return 'CategoryModel(id: $id, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, name: $name, nameAr: $nameAr, image: $image, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.image == image &&
        other.order == order &&
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
        order.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
