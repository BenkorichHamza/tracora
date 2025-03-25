import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tracora/app/data/models/employee_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/modules/MissionForm/views/product_mission_view.dart';

class Mission {
  final int? id;
  final String? ids;
  final String? title;
  final int? startAt;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final int? endAt;
  final bool? done;
  final String? comment;
  final EmployeeModel? employee;
  final List<MissionProduct>? missionProducts;
  Mission({
    this.id,
    this.ids,
    this.title,
    this.startAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.endAt,
    this.done,
    this.comment,
    this.employee,
    this.missionProducts,
  });

  Mission copyWith({
    int? id,
    String? ids,
    String? title,
    int? startAt,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    int? endAt,
    bool? done,
    String? comment,
    EmployeeModel? employee,
    List<MissionProduct>? missionProducts,
  }) {
    return Mission(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      title: title ?? this.title,
      startAt: startAt ?? this.startAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      endAt: endAt ?? this.endAt,
      done: done ?? this.done,
      comment: comment ?? this.comment,
      employee: employee ?? this.employee,
      missionProducts: missionProducts ?? this.missionProducts,
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
    if (title != null) {
      result.addAll({'title': title});
    }
    if (startAt != null) {
      result.addAll({'startAt': startAt});
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
    if (endAt != null) {
      result.addAll({'endAt': endAt});
    }
    if (done != null) {
      result.addAll({'done': done});
    }
    if (comment != null) {
      result.addAll({'comment': comment});
    }
    if (employee != null) {
      result.addAll({'employee': employee!.toMap()});
    }
    if (missionProducts != null) {
      result.addAll({
        'missionProducts': missionProducts!.map((x) => x?.toMap()).toList(),
      });
    }

    return result;
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id']?.toInt(),
      ids: map['ids'],
      title: map['title'],
      startAt: map['startAt']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      endAt: map['endAt']?.toInt(),
      done: map['done'],
      comment: map['comment'],
      employee:
          map['employee'] != null
              ? EmployeeModel.fromMap(map['employee'])
              : null,
      missionProducts:
          map['missionProducts'] != null
              ? List<MissionProduct>.from(
                map['missionProducts']?.map((x) => MissionProduct.fromMap(x)),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mission.fromJson(String source) =>
      Mission.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mission(id: $id, ids: $ids, title: $title, startAt: $startAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, endAt: $endAt, done: $done, comment: $comment, employee: $employee, missionProducts: $missionProducts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mission &&
        other.id == id &&
        other.ids == ids &&
        other.title == title &&
        other.startAt == startAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.endAt == endAt &&
        other.done == done &&
        other.comment == comment &&
        other.employee == employee &&
        listEquals(other.missionProducts, missionProducts);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ids.hashCode ^
        title.hashCode ^
        startAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        endAt.hashCode ^
        done.hashCode ^
        comment.hashCode ^
        employee.hashCode ^
        missionProducts.hashCode;
  }
}

class MissionProduct {
  final Product? product;
  final double? qte;
  MissionProduct({this.product, this.qte});

  MissionProduct copyWith({Product? product, double? qte}) {
    return MissionProduct(
      product: product ?? this.product,
      qte: qte ?? this.qte,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }
    if (qte != null) {
      result.addAll({'qte': qte});
    }

    return result;
  }

  factory MissionProduct.fromMap(Map<String, dynamic> map) {
    return MissionProduct(
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      qte: map['qte']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MissionProduct.fromJson(String source) =>
      MissionProduct.fromMap(json.decode(source));

  @override
  String toString() => 'MissionProduct(product: $product, qte: $qte)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MissionProduct &&
        other.product == product &&
        other.qte == qte;
  }

  @override
  int get hashCode => product.hashCode ^ qte.hashCode;
}
