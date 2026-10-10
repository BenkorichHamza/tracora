import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tracora/app/data/models/role.dart';
import 'package:tracora/app/data/models/warehouse.dart';

class UserModel {
  final String sql = '''
CREATE TABLE user (
    id          STRING PRIMARY KEY,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    warehouse_id         STRING REFERENCES warehouse (id),
    type        TEXT,
    firstName   TEXT,
    lastName    TEXT,
    address     TEXT,
    phone       TEXT,
    fax         TEXT,
    fix         TEXT,
    email       TEXT,
    companyName TEXT,
    updatedAt   INTEGER,
    createdAt   INTEGER,
    deletedAt   INTEGER,
    code        TEXT,
    due        DOUBLE,
    payment        DOUBLE,
    deleted     BOOLEAN,
    nif         STRING,
    nis         STRING,
    nin         STRING,
    password    STRING,
    img         STRING
)
''';
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? type;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phone;
  final String? fax;
  final String? fix;
  final String? email;
  final Warehouse? warehouse;

  final String? companyName;
  final int? updatedAt;
  final double? due;
  final double? payment;
  final int? createdAt;
  final int? deletedAt;
  final String? code;
  final String? nif;
  final String? nis;
  final String? nin;
  final String? password;
  final String? img;

  final List<Role>? roles;
  UserModel({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.type,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.fax,
    this.fix,
    this.email,
    this.warehouse,
    this.companyName,
    this.updatedAt,
    this.due,
    this.payment,
    this.createdAt,
    this.deletedAt,
    this.code,
    this.nif,
    this.nis,
    this.nin,
    this.password,
    this.img,
    this.roles,
  });
  double get toPay => (due ?? 0) - (payment ?? 0);

  UserModel copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? type,
    String? firstName,
    String? lastName,
    String? address,
    String? phone,
    String? fax,
    String? fix,
    String? email,
    Warehouse? warehouse,
    String? companyName,
    int? updatedAt,
    double? due,
    double? payment,
    int? createdAt,
    int? deletedAt,
    String? code,
    String? nif,
    String? nis,
    String? nin,
    String? password,
    String? img,
    List<Role>? roles,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      type: type ?? this.type,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      fax: fax ?? this.fax,
      fix: fix ?? this.fix,
      email: email ?? this.email,
      warehouse: warehouse ?? this.warehouse,
      companyName: companyName ?? this.companyName,
      updatedAt: updatedAt ?? this.updatedAt,
      due: due ?? this.due,
      payment: payment ?? this.payment,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      code: code ?? this.code,
      nif: nif ?? this.nif,
      nis: nis ?? this.nis,
      nin: nin ?? this.nin,
      password: password ?? this.password,
      img: img ?? this.img,
      roles: roles ?? this.roles,
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
    if (type != null) {
      result.addAll({'type': type});
    }
    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (fax != null) {
      result.addAll({'fax': fax});
    }
    if (fix != null) {
      result.addAll({'fix': fix});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (warehouse != null) {
      result.addAll({'warehouse_id': warehouse?.id});
    }
    if (companyName != null) {
      result.addAll({'companyName': companyName});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (due != null) {
      result.addAll({'due': due});
    }
    if (payment != null) {
      result.addAll({'payment': payment});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (deletedAt != null) {
      result.addAll({'deletedAt': deletedAt});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (nif != null) {
      result.addAll({'nif': nif});
    }
    if (nis != null) {
      result.addAll({'nis': nis});
    }
    if (nin != null) {
      result.addAll({'nin': nin});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (img != null) {
      result.addAll({'img': img});
    }

    if (roles != null) {
      result.addAll({'roles': List.from(roles!.map((e) => e.toMap()))});
    }

    return result;
  }

  Map<String, dynamic> toSharedPrefMap() {
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
    if (type != null) {
      result.addAll({'type': type});
    }
    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (fax != null) {
      result.addAll({'fax': fax});
    }
    if (fix != null) {
      result.addAll({'fix': fix});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (warehouse != null) {
      result.addAll({'warehouse_id': warehouse?.id});
      result.addAll({'warehouse': warehouse?.toMap()});
    }
    if (companyName != null) {
      result.addAll({'companyName': companyName});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (due != null) {
      result.addAll({'due': due});
    }
    if (payment != null) {
      result.addAll({'payment': payment});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (deletedAt != null) {
      result.addAll({'deletedAt': deletedAt});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (nif != null) {
      result.addAll({'nif': nif});
    }
    if (nis != null) {
      result.addAll({'nis': nis});
    }
    if (nin != null) {
      result.addAll({'nin': nin});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (img != null) {
      result.addAll({'img': img});
    }
    if (roles != null) {
      result.addAll({'roles': List.from(roles!.map((e) => e.toMap()))});
    }

    return result;
  }

  String toSharedPrefJson() => json.encode(toSharedPrefMap());

  Map<String, dynamic> toSyncMap() {
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
    if (type != null) {
      result.addAll({'type': type});
    }

    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (fax != null) {
      result.addAll({'fax': fax});
    }
    if (fix != null) {
      result.addAll({'fix': fix});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (warehouse != null) {
      result.addAll({'warehouse_id': warehouse?.id});
    }
    if (companyName != null) {
      result.addAll({'companyName': companyName});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (due != null) {
      result.addAll({'due': due});
    }
    if (payment != null) {
      result.addAll({'payment': payment});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (deletedAt != null) {
      result.addAll({'deletedAt': deletedAt});
    }
    if (code != null) {
      result.addAll({'code': code});
    }
    if (nif != null) {
      result.addAll({'nif': nif});
    }
    if (nis != null) {
      result.addAll({'nis': nis});
    }
    if (nin != null) {
      result.addAll({'nin': nin});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (img != null) {
      result.addAll({'img': img});
    }

    if (roles != null) {
      result.addAll({'roles': List.from(roles!.map((e) => e.id))});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      type: map['type'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      phone: map['phone'],
      fax: map['fax'],
      fix: map['fix'],
      email: map['email'],
      warehouse: Warehouse.fromMap(map['warehouse'] ?? {}),
      companyName: map['companyName'],
      updatedAt: map['updatedAt']?.toInt(),
      due: map['due']?.toDouble(),
      payment: map['payment']?.toDouble(),
      createdAt: map['createdAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      code: map['code'],
      nif: map['nif']?.toString(),
      nis: map['nis']?.toString(),
      nin: map['nin']?.toString(),
      password: map['password']?.toString(),
      img: map['img'],
      roles:
          (map['roles'] as List<dynamic>?)
              ?.map((e) => Role.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, type: $type, firstName: $firstName, lastName: $lastName, address: $address, phone: $phone, fax: $fax, fix: $fix, email: $email, companyName: $companyName, updatedAt: $updatedAt, due: $due, payment: $payment, createdAt: $createdAt, deletedAt: $deletedAt, code: $code, nif: $nif, nis: $nis, nin: $nin, password: $password, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.type == type &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.phone == phone &&
        other.fax == fax &&
        other.fix == fix &&
        other.email == email &&
        other.companyName == companyName &&
        other.warehouse == warehouse &&
        other.updatedAt == updatedAt &&
        other.due == due &&
        other.payment == payment &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt &&
        other.code == code &&
        other.nif == nif &&
        other.nis == nis &&
        other.nin == nin &&
        other.password == password &&
        other.img == img;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        type.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        fax.hashCode ^
        fix.hashCode ^
        email.hashCode ^
        companyName.hashCode ^
        warehouse.hashCode ^
        updatedAt.hashCode ^
        due.hashCode ^
        payment.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode ^
        code.hashCode ^
        nif.hashCode ^
        nis.hashCode ^
        nin.hashCode ^
        password.hashCode ^
        img.hashCode;
  }
}

class Customer {}

class Supplier {}

class Employee {}
