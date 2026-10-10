import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/models/warehouse.dart';

class StockTransaction {
  final String sql = '''
CREATE TABLE stock_transaction (
    id              STRING PRIMARY KEY,
    status INTEGER,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    employeeId     STRING REFERENCES user (id),
    userId         STRING REFERENCES user (id),
    from_warehouse         STRING REFERENCES warehouse (id),
    to_warehouse         STRING REFERENCES warehouse (id),
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
  final String? id;
  final int? status;
  final String? userId;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? employeeId;
  final UserModel? employee;
  final UserModel? user;
  final String? type;
  final Warehouse? from_warehouse;
  final Warehouse? to_warehouse;
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
    this.status,
    this.userId,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.employeeId,
    this.employee,
    this.user,
    this.type,
    this.from_warehouse,
    this.to_warehouse,
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
    String? id,
    int? status,
    String? userId,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? employeeId,
    UserModel? employee,
    UserModel? user,
    String? type,
    Warehouse? from_warehouse,
    Warehouse? to_warehouse,
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
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      employeeId: employeeId ?? this.employeeId,
      employee: employee ?? this.employee,
      user: user ?? this.user,
      type: type ?? this.type,
      from_warehouse: from_warehouse ?? this.from_warehouse,
      to_warehouse: to_warehouse ?? this.to_warehouse,
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
    if (status != null) {
      result.addAll({'status': status});
    }
    if (userId != null) {
      result.addAll({'userId': userId});
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
    if (employeeId != null) {
      result.addAll({'employeeId': employeeId});
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
    if (from_warehouse != null) {
      result.addAll({'fromWarehouse': from_warehouse!.toMap()});
    }
    if (to_warehouse != null) {
      result.addAll({'toWarehouse': to_warehouse!.toMap()});
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

    if (status != null) {
      result.addAll({'status': status});
    }
    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'employeeId': employee?.id ?? employeeId});
    if (user?.id != null) {
      result.addAll({'userId': user!.id});
    }
    if (from_warehouse?.id != null) {
      result.addAll({'from_warehouse': from_warehouse!.id});
    }
    if (to_warehouse?.id != null) {
      result.addAll({'to_warehouse': to_warehouse!.id});
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

  factory StockTransaction.fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      status: map['status']?.toInt(),
      userId: map['userId'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      employeeId: map['employeeId'],
      employee:
          map['employee'] != null ? UserModel.fromMap(map['employee']) : null,
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      type: map['type'],
      from_warehouse:
          map['fromWarehouse'] != null
              ? Warehouse.fromMap(map['fromWarehouse'])
              : null,
      to_warehouse:
          map['toWarehouse'] != null
              ? Warehouse.fromMap(map['toWarehouse'])
              : null,
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

  factory StockTransaction.fromApiMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      status: map['status']?.toInt(),
      userId: map['userId'],
      user: UserModel.fromMap(map['user'] ?? {}),
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      employeeId: map['employeeId'],
      type: map['type'],
      from_warehouse: Warehouse.fromMap(map['fromWarehouse'] ?? {}),
      to_warehouse: Warehouse.fromMap(map['toWarehouse'] ?? {}),
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
                  (x) => ProductTransaction.fromApiMap(x),
                ),
              )
              : null,
      dateTime: map['dateTime']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  Map<String, dynamic> toSyncMap() {
    return {
      'id': id,

      /*
    |--------------------------------------------------------------------------
    | Basic
    |--------------------------------------------------------------------------
    */
      'status': status,

      'type': type,

      'description': description,

      /*
    |--------------------------------------------------------------------------
    | Relations
    |--------------------------------------------------------------------------
    */
      'employeeId': employee?.id ?? employeeId,

      'userId': user?.id ?? userId,

      'from_warehouse': from_warehouse?.id,

      'to_warehouse': to_warehouse?.id,

      /*
    |--------------------------------------------------------------------------
    | Financial
    |--------------------------------------------------------------------------
    */
      'topay': topay,

      'total': total,

      'payment': payment,

      'credit': credit,

      'tax': tax,

      /*
    |--------------------------------------------------------------------------
    | Dates
    |--------------------------------------------------------------------------
    */
      'datetime': dateTime,
      'deletedAt': deletedAt,

      /*
    |--------------------------------------------------------------------------
    | Products Pivot
    |--------------------------------------------------------------------------
    */
      'products':
          productTransactions?.map((e) {
            return {
              'productId': e.product?.id ?? '',

              'qte': e.qte,

              'price': e.price,

              'tax': 0,

              'direction': e.direction,
            };
          }).toList() ??
          [],

      /*
    |--------------------------------------------------------------------------
    | Audit
    |--------------------------------------------------------------------------
    */
      'created_by': createdBy,

      'updated_by': updatedBy,

      'deleted_by': deletedBy,
    };
  }

  String toJson() => json.encode(toMap());
  String toSyncJson() => json.encode(toSyncMap());

  factory StockTransaction.fromJson(String source) =>
      StockTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockTransaction(id: $id, status: $status, userId: $userId, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, employeeId: $employeeId, employee: $employee, user: $user, type: $type, fromWarehouse: $from_warehouse, toWarehouse: $to_warehouse, description: $description, topay: $topay, total: $total, payment: $payment, credit: $credit, tax: $tax, productTransactions: $productTransactions, dateTime: $dateTime, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockTransaction &&
        other.id == id &&
        other.status == status &&
        other.userId == userId &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.employeeId == employeeId &&
        other.employee == employee &&
        other.user == user &&
        other.type == type &&
        other.from_warehouse == from_warehouse &&
        other.to_warehouse == to_warehouse &&
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
        status.hashCode ^
        userId.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        employeeId.hashCode ^
        employee.hashCode ^
        user.hashCode ^
        type.hashCode ^
        from_warehouse.hashCode ^
        to_warehouse.hashCode ^
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

class Sale {}

class Purchase {}

class Transfert {}

class Fees {}
