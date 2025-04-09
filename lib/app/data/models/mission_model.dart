import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tracora/app/data/models/employee_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/user_model.dart';

class Mission {
  static String sql = '''
CREATE TABLE mission (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  ids         STRING,
  title       STRING,
  startAt     INTEGER,
  createdAt   INTEGER,
  updatedAt   INTEGER,
  deletedAt   INTEGER,
  done        BOOLEAN,
  comment     STRING,
  user_id  INTEGER REFERENCES user (id)
)

''';
  final int? id;
  final String? ids;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? title;
  final int? dateTime;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  final int? endAt;
  final bool? done;
  final String? comment;
  final UserModel? user;
  final List<MissionProduct>? missionProducts;
  Mission({
    this.id,
    this.ids,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.title,
    this.dateTime,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.endAt,
    this.done,
    this.comment,
    this.user,
    this.missionProducts,
  });

  Mission copyWith({
    int? id,
    String? ids,
    String? createdBy,
    String? updatedBy,
    String? deletedBy,
    String? title,
    int? dateTime,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    int? endAt,
    bool? done,
    String? comment,
    UserModel? user,
    List<MissionProduct>? missionProducts,
  }) {
    return Mission(
      id: id ?? this.id,
      ids: ids ?? this.ids,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      endAt: endAt ?? this.endAt,
      done: done ?? this.done,
      comment: comment ?? this.comment,
      user: user ?? this.user,
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
    if (createdBy != null) {
      result.addAll({'createdBy': createdBy});
    }
    if (updatedBy != null) {
      result.addAll({'updatedBy': updatedBy});
    }
    if (deletedBy != null) {
      result.addAll({'deletedBy': deletedBy});
    }
    if (title != null) {
      result.addAll({'title': title});
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
    if (endAt != null) {
      result.addAll({'endAt': endAt});
    }
    if (done != null) {
      result.addAll({'done': done});
    }
    if (comment != null) {
      result.addAll({'comment': comment});
    }
    if (user != null) {
      result.addAll({'user': user!.toMap()});
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
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      deletedBy: map['deletedBy'],
      title: map['title'],
      dateTime: map['dateTime']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
      endAt: map['endAt']?.toInt(),
      done: map['done'],
      comment: map['comment'],
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
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
    return 'Mission(id: $id, ids: $ids, createdBy: $createdBy, updatedBy: $updatedBy, deletedBy: $deletedBy, title: $title, dateTime: $dateTime, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, endAt: $endAt, done: $done, comment: $comment, user: $user, missionProducts: $missionProducts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mission &&
        other.id == id &&
        other.ids == ids &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.deletedBy == deletedBy &&
        other.title == title &&
        other.dateTime == dateTime &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.endAt == endAt &&
        other.done == done &&
        other.comment == comment &&
        other.user == user &&
        listEquals(other.missionProducts, missionProducts);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ids.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        deletedBy.hashCode ^
        title.hashCode ^
        dateTime.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        endAt.hashCode ^
        done.hashCode ^
        comment.hashCode ^
        user.hashCode ^
        missionProducts.hashCode;
  }
}

class MissionProduct {
  static String sql = '''
CREATE TABLE mission_product (
  product_id INTEGER REFERENCES product (id),
  mission_id INTEGER REFERENCES mission (id),
  qte        DOUBLE
)
''';
  final Product? product;
  final Mission? mission;
  final double? qte;
  MissionProduct({this.product, this.mission, this.qte});

  MissionProduct copyWith({Product? product, Mission? mission, double? qte}) {
    return MissionProduct(
      product: product ?? this.product,
      mission: mission ?? this.mission,
      qte: qte ?? this.qte,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }
    if (mission != null) {
      result.addAll({'mission': mission!.toMap()});
    }
    if (qte != null) {
      result.addAll({'qte': qte});
    }

    return result;
  }

  factory MissionProduct.fromMap(Map<String, dynamic> map) {
    return MissionProduct(
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      mission: map['mission'] != null ? Mission.fromMap(map['mission']) : null,
      qte: map['qte']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MissionProduct.fromJson(String source) =>
      MissionProduct.fromMap(json.decode(source));

  @override
  String toString() =>
      'MissionProduct(product: $product, mission: $mission, qte: $qte)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MissionProduct &&
        other.product == product &&
        other.mission == mission &&
        other.qte == qte;
  }

  @override
  int get hashCode => product.hashCode ^ mission.hashCode ^ qte.hashCode;
}
