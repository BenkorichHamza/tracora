import 'dart:convert';

import 'package:tracora/app/data/models/user_model.dart';

class MoneyTransaction {
  final String sql = '''
CREATE TABLE money_transaction (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    ids  STRING UNIQUE,
    missionIds  STRING,
    createdBy  STRING,
    updatedBy  STRING,
    deletedBy  STRING,
    employeeIds STRING,
    credit      DOUBLE,
    amount      DOUBLE,
    type        TEXT,
    description TEXT,
    employee_id INTEGER REFERENCES user (id),
    user_id INTEGER REFERENCES user (id),
    dateTime    INTEGER,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER
);
''';
  final int? id;
  final String? ids;
  final String? missionIds;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? employeeIds;
  final double? credit;
  final double? amount;
  final String? type;
  final String? description;
  final UserModel? employee;
  final UserModel? user;
  final int? dateTime;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  MoneyTransaction({
    this.id,
    this.ids,
    this.missionIds,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.employeeIds,
    this.credit,
    this.amount,
    this.type,
    this.description,
    this.employee,
    this.user,
    this.dateTime,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  MoneyTransaction copyWith({
    int? id,
    String? ids,
    String? missionIds,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? employeeIds,
    double? credit,
    double? amount,
    String? type,
    String? description,
    UserModel? employee,
    UserModel? user,
    int? dateTime,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return MoneyTransaction(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      missionIds: missionIds ?? this.missionIds,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      employeeIds: employeeIds ?? this.employeeIds,
      credit: credit ?? this.credit,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      employee: employee ?? this.employee,
      user: user ?? this.user,
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
    if (missionIds != null) {
      result.addAll({'missionIds': missionIds});
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
    if (credit != null) {
      result.addAll({'credit': credit});
    }
    if (amount != null) {
      result.addAll({'amount': amount});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (employee != null) {
      result.addAll({'employee': employee!.toMap()});
    }
    if (user != null) {
      result.addAll({'user': user!.toMap()});
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
    if (missionIds != null) {
      result.addAll({'missionIds': ids});
    }
    if (credit != null) {
      result.addAll({'credit': credit});
    }
    if (amount != null) {
      result.addAll({'amount': amount});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (employee != null) {
      result.addAll({'employee_id': employee?.id});
    }
    if (user != null) {
      result.addAll({'user_id': user?.id});
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

  factory MoneyTransaction.fromMap(Map<String, dynamic> map) {
    return MoneyTransaction(
      id: map['id']?.toInt(),
      ids: map['ids'],
      missionIds: map['missionIds'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      employeeIds: map['employeeIds'],
      credit: map['credit']?.toDouble(),
      amount: map['amount']?.toDouble(),
      type: map['type'],
      description: map['description'],
      employee:
          map['employee'] != null ? UserModel.fromMap(map['employee']) : null,
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      dateTime: map['dateTime']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyTransaction.fromJson(String source) =>
      MoneyTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MoneyTransaction(id: $id, ids: $ids, missionIds: $missionIds, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, employeeIds: $employeeIds, credit: $credit, amount: $amount, type: $type, description: $description, employee: $employee, user: $user, dateTime: $dateTime, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoneyTransaction &&
        other.id == id &&
        other.ids == ids &&
        other.missionIds == missionIds &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.employeeIds == employeeIds &&
        other.credit == credit &&
        other.amount == amount &&
        other.type == type &&
        other.description == description &&
        other.employee == employee &&
        other.user == user &&
        other.dateTime == dateTime &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ids.hashCode ^
        missionIds.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        employeeIds.hashCode ^
        credit.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        description.hashCode ^
        employee.hashCode ^
        user.hashCode ^
        dateTime.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
