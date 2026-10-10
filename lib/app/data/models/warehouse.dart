import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Warehouse {
  final String sql = '''
CREATE TABLE warehouse (
    id STRING PRIMARY KEY,
    name TEXT,
    nameAr TEXT,
    location TEXT,
    description TEXT,
    type TEXT,
    createdBy STRING,
    updatedBy STRING,
    deletedBy STRING,
    createdAt INTEGER,
    updatedAt INTEGER,
    deletedAt INTEGER
)
''';
  final String? id;
  final String? name;
  final String? nameAr;
  final String? location;
  final String? description;
  final String? type;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  Warehouse({
    this.id,
    this.name,
    this.nameAr,
    this.location,
    this.description,
    this.type,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Warehouse copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? location,
    String? description,
    String? type,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      location: location ?? this.location,
      description: description ?? this.description,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
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
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
    }
    if (location != null) {
      result.addAll({'location': location});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (type != null) {
      result.addAll({'type': type});
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

  Map<String, dynamic> toSyncMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (nameAr != null) {
      result.addAll({'nameAr': nameAr});
    }
    if (location != null) {
      result.addAll({'location': location});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (type != null) {
      result.addAll({'type': type});
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
    if (createdAt != null) {
      result.addAll({'created_at': createdAt});
    }
    if (updatedAt != null) {
      result.addAll({'updated_at': updatedAt});
    }
    if (deletedAt != null) {
      result.addAll({'deleted_at': deletedAt});
    }

    return result;
  }

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id'],
      name: map['name'],
      nameAr: map['nameAr'],
      location: map['location'],
      description: map['description'],
      type: map['type'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Warehouse.fromJson(String source) =>
      Warehouse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Warehouse(id: $id, name: $name, nameAr: $nameAr, location: $location, description: $description, type: $type, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Warehouse &&
        other.id == id &&
        other.name == name &&
        other.nameAr == nameAr &&
        other.location == location &&
        other.description == description &&
        other.type == type &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        nameAr.hashCode ^
        location.hashCode ^
        description.hashCode ^
        type.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }

  String? get translateName =>
      Get.locale?.languageCode == 'ar' ? nameAr ?? name : name ?? nameAr;
}
