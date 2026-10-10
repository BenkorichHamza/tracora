import 'dart:convert';

import 'package:flutter/foundation.dart';

class Role {
  final int? id;
  final String? name;
  final String? guard_name;
  final String? created_at;
  final String? updated_at;
  final List<Permission>? permissions;

  final String sql = '''CREATE TABLE roles (
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    name  TEXT UNIQUE,
    guard_name  TEXT,
    created_at INTEGER,
    updated_at INTEGER
)''';

  Role({
    this.id,
    this.name,
    this.guard_name,
    this.created_at,
    this.updated_at,
    this.permissions,
  });

  Role copyWith({
    int? id,
    String? name,
    String? guard_name,
    String? created_at,
    String? updated_at,
    List<Permission>? permissions,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      guard_name: guard_name ?? this.guard_name,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      permissions: permissions ?? this.permissions,
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
    if (guard_name != null) {
      result.addAll({'guard_name': guard_name});
    }
    if (created_at != null) {
      result.addAll({'created_at': created_at});
    }
    if (updated_at != null) {
      result.addAll({'updated_at': updated_at});
    }
    if (permissions != null) {
      result.addAll({
        'permissions': permissions!.map((x) => x?.toMap()).toList(),
      });
    }

    return result;
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id']?.toInt(),
      name: map['name'],
      guard_name: map['guard_name'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      permissions:
          map['permissions'] != null
              ? List<Permission>.from(
                map['permissions']?.map((x) => Permission.fromMap(x)),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) => Role.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Role(id: $id, name: $name, guard_name: $guard_name, created_at: $created_at, updated_at: $updated_at, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Role &&
        other.id == id &&
        other.name == name &&
        other.guard_name == guard_name &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        listEquals(other.permissions, permissions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        guard_name.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        permissions.hashCode;
  }
}

class Permission {
  final int? id;
  final String? name;
  final String? guard_name;
  final String? created_at;
  final String? updated_at;

  final String sql = '''CREATE TABLE permissions (
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    name  TEXT UNIQUE,
    guard_name  TEXT,
    created_at INTEGER,
    updated_at INTEGER
)''';

  Permission({
    this.id,
    this.name,
    this.guard_name,
    this.created_at,
    this.updated_at,
  });

  Permission copyWith({
    int? id,
    String? name,
    String? guard_name,
    String? created_at,
    String? updated_at,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      guard_name: guard_name ?? this.guard_name,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
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
    if (guard_name != null) {
      result.addAll({'guard_name': guard_name});
    }
    if (created_at != null) {
      result.addAll({'created_at': created_at});
    }
    if (updated_at != null) {
      result.addAll({'updated_at': updated_at});
    }

    return result;
  }

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id']?.toInt(),
      name: map['name'],
      guard_name: map['guard_name'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Permission.fromJson(String source) =>
      Permission.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Permission(id: $id, name: $name, guard_name: $guard_name, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Permission &&
        other.id == id &&
        other.name == name &&
        other.guard_name == guard_name &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        guard_name.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}

class PermissionRole {
  final String sql = '''CREATE TABLE permission_role (
    role_id  INTEGER REFERENCES roles (id),
    permission_id  INTEGER REFERENCES permissions (id)
)''';
}

class RoleUser {
  final String sql = '''CREATE TABLE role_user (
    role_id  INTEGER REFERENCES roles (id),
    user_id  STRING REFERENCES user (id)
)''';
}

class PermissionUser {
  final String sql = '''CREATE TABLE permission_user (
    permission_id  INTEGER REFERENCES permissions (id),
    user_id  STRING REFERENCES user (id)
)''';
}
