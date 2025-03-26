import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  final String sql = '''
CREATE TABLE user (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    remoteId          INTEGER,
    ids  STRING UNIQUE,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    type        TEXT,
    data        BLOB,
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
  final int? id;
  final int? remoteId;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? type;
  final Uint8List? data;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? phone;
  final String? fax;
  final String? fix;
  final String? email;
  final String? companyName;
  final int? updatedAt;
  final double? due;
  final double? payment;
  final int? createdAt;
  final int? deletedAt;
  final String? code;
  final bool? deleted;
  final String? nif;
  final String? nis;
  final String? nin;
  final String? password;
  final String? img;
  UserModel({
    this.id,
    this.remoteId,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.type,
    this.data,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.fax,
    this.fix,
    this.email,
    this.companyName,
    this.updatedAt,
    this.due,
    this.payment,
    this.createdAt,
    this.deletedAt,
    this.code,
    this.deleted,
    this.nif,
    this.nis,
    this.nin,
    this.password,
    this.img,
  });
  double get toPay => (due ?? 0) - (payment ?? 0);

  UserModel copyWith({
    int? id,
    int? remoteId,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? type,
    Uint8List? data,
    String? firstName,
    String? lastName,
    String? address,
    String? phone,
    String? fax,
    String? fix,
    String? email,
    String? companyName,
    int? updatedAt,
    double? due,
    double? payment,
    int? createdAt,
    int? deletedAt,
    String? code,
    bool? deleted,
    String? nif,
    String? nis,
    String? nin,
    String? password,
    String? img,
  }) {
    return UserModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      type: type ?? this.type,
      data: data ?? this.data,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      fax: fax ?? this.fax,
      fix: fix ?? this.fix,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      updatedAt: updatedAt ?? this.updatedAt,
      due: due ?? this.due,
      payment: payment ?? this.payment,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      code: code ?? this.code,
      deleted: deleted ?? this.deleted,
      nif: nif ?? this.nif,
      nis: nis ?? this.nis,
      nin: nin ?? this.nin,
      password: password ?? this.password,
      img: img ?? this.img,
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
    if (type != null) {
      result.addAll({'type': type});
    }
    if (data != null) {
      result.addAll({'data': data});
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
    if (deleted != null) {
      result.addAll({'deleted': deleted});
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

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      remoteId: map['remoteId']?.toInt(),
      ids: map['ids'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      type: map['type'],
      data: map['data'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      phone: map['phone'],
      fax: map['fax'],
      fix: map['fix'],
      email: map['email'],
      companyName: map['companyName'],
      updatedAt: map['updatedAt']?.toInt(),
      due: map['due']?.toDouble(),
      payment: map['payment']?.toDouble(),
      createdAt: map['createdAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      code: map['code'],
      deleted: map['deleted'],
      nif: map['nif'],
      nis: map['nis'],
      nin: map['nin'],
      password: map['password'],
      img: map['img'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, remoteId: $remoteId, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, type: $type, data: $data, firstName: $firstName, lastName: $lastName, address: $address, phone: $phone, fax: $fax, fix: $fix, email: $email, companyName: $companyName, updatedAt: $updatedAt, due: $due, payment: $payment, createdAt: $createdAt, deletedAt: $deletedAt, code: $code, deleted: $deleted, nif: $nif, nis: $nis, nin: $nin, password: $password, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.type == type &&
        other.data == data &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.phone == phone &&
        other.fax == fax &&
        other.fix == fix &&
        other.email == email &&
        other.companyName == companyName &&
        other.updatedAt == updatedAt &&
        other.due == due &&
        other.payment == payment &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt &&
        other.code == code &&
        other.deleted == deleted &&
        other.nif == nif &&
        other.nis == nis &&
        other.nin == nin &&
        other.password == password &&
        other.img == img;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        remoteId.hashCode ^
        ids.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        type.hashCode ^
        data.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        fax.hashCode ^
        fix.hashCode ^
        email.hashCode ^
        companyName.hashCode ^
        updatedAt.hashCode ^
        due.hashCode ^
        payment.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode ^
        code.hashCode ^
        deleted.hashCode ^
        nif.hashCode ^
        nis.hashCode ^
        nin.hashCode ^
        password.hashCode ^
        img.hashCode;
  }
}
