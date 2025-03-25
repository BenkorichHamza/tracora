import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';

class StockTransaction {
  final String sql = '''
CREATE TABLE stock_transaction (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    ids  STRING UNIQUE,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    employeeIds     STRING,
    employee_id     INTEGER REFERENCES user (id),
    user_id         INTEGER REFERENCES user (id),
    type            TEXT,
    description     TEXT,
    topay           REAL,
    total           REAL,
    credit          REAL,
    payment         REAL,
    tax             REAL,
    dateTime        INTEGER,
    createdAt       INTEGER,
    updatedAt       INTEGER,
    deletedAt       INTEGER
)
''';
  final int? id;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? employeeIds;
  final UserModel? employee;
  final UserModel? user;
  final String? type;
  final String? description;
  final double? topay;
  final double? total;
  final double? payment;
  final double? credit;
  final double? tax;
  final List<ProductTransaction>? productTransactions;
  final int? dateTime;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  StockTransaction({
    this.id,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.employeeIds,
    this.employee,
    this.user,
    this.type,
    this.description,
    this.topay,
    this.total,
    this.payment,
    this.credit,
    this.tax,
    this.productTransactions,
    this.dateTime,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  StockTransaction copyWith({
    int? id,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? employeeIds,
    UserModel? employee,
    UserModel? user,
    String? type,
    String? description,
    double? topay,
    double? total,
    double? payment,
    double? credit,
    double? tax,
    List<ProductTransaction>? productTransactions,
    int? dateTime,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return StockTransaction(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      employeeIds: employeeIds ?? this.employeeIds,
      employee: employee ?? this.employee,
      user: user ?? this.user,
      type: type ?? this.type,
      description: description ?? this.description,
      topay: topay ?? this.topay,
      total: total ?? this.total,
      payment: payment ?? this.payment,
      credit: credit ?? this.credit,
      tax: tax ?? this.tax,
      productTransactions: productTransactions ?? this.productTransactions,
      dateTime: dateTime ?? this.dateTime,
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
    if (employeeIds != null) {
      result.addAll({'employeeIds': employeeIds});
    }
    if (employee != null) {
      result.addAll({'employee': employee!.toMap()});
    }
    if (user != null) {
      result.addAll({'user': user!.toMap()});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (topay != null) {
      result.addAll({'topay': topay});
    }
    if (total != null) {
      result.addAll({'total': total});
    }
    if (payment != null) {
      result.addAll({'payment': payment});
    }
    if (credit != null) {
      result.addAll({'credit': credit});
    }
    if (tax != null) {
      result.addAll({'tax': tax});
    }
    if (productTransactions != null) {
      result.addAll({
        'productTransactions':
            productTransactions!.map((x) => x?.toMap()).toList(),
      });
    }
    if (dateTime != null) {
      result.addAll({'dateTime': dateTime});
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

  Map<String, dynamic> toSqfliteMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (ids != null) {
      result.addAll({'ids': ids});
    }
    if (employee?.id != null) {
      result.addAll({'employee_id': employee?.id});
    }
    if (user?.id != null) {
      result.addAll({'user_id': user!.id});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (topay != null) {
      result.addAll({'topay': topay});
    }
    if (payment != null) {
      result.addAll({'payment': payment});
    }
    if (credit != null) {
      result.addAll({'credit': credit});
    }
    if (total != null) {
      result.addAll({'total': total});
    }
    if (tax != null) {
      result.addAll({'tax': tax});
    }
    if (dateTime != null) {
      result.addAll({'dateTime': dateTime});
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

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id']?.toInt(),
      ids: map['ids'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      employeeIds: map['employeeIds'],
      employee:
          map['employee'] != null ? UserModel.fromMap(map['employee']) : null,
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      type: map['type'],
      description: map['description'],
      topay: map['topay']?.toDouble(),
      total: map['total']?.toDouble(),
      payment: map['payment']?.toDouble(),
      credit: map['credit']?.toDouble(),
      tax: map['tax']?.toDouble(),
      productTransactions:
          map['productTransactions'] != null
              ? List<ProductTransaction>.from(
                map['productTransactions']?.map(
                  (x) => ProductTransaction.fromMap(x),
                ),
              )
              : null,
      dateTime: map['dateTime']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StockTransaction.fromJson(String source) =>
      StockTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockTransaction(id: $id, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, employeeIds: $employeeIds, employee: $employee, user: $user, type: $type, description: $description, topay: $topay, total: $total, payment: $payment, credit: $credit, tax: $tax, productTransactions: $productTransactions, dateTime: $dateTime, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockTransaction &&
        other.id == id &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.employeeIds == employeeIds &&
        other.employee == employee &&
        other.user == user &&
        other.type == type &&
        other.description == description &&
        other.topay == topay &&
        other.total == total &&
        other.payment == payment &&
        other.credit == credit &&
        other.tax == tax &&
        listEquals(other.productTransactions, productTransactions) &&
        other.dateTime == dateTime &&
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
        employeeIds.hashCode ^
        employee.hashCode ^
        user.hashCode ^
        type.hashCode ^
        description.hashCode ^
        topay.hashCode ^
        total.hashCode ^
        payment.hashCode ^
        credit.hashCode ^
        tax.hashCode ^
        productTransactions.hashCode ^
        dateTime.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
