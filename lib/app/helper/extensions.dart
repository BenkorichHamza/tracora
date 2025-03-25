import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/user_model.dart';

extension INtegerParsing on int? {
  String? formatDateTime() {
    if ((this ?? 0) <= 0) return null;
    return DateFormat(
      "dd/MM/yyyy HH:mm",
    ).format(DateTime.fromMillisecondsSinceEpoch(this ?? 0));
  }

  String? formatDate() {
    if ((this ?? 0) <= 0) return null;
    return DateFormat(
      "dd/MM/yyyy",
    ).format(DateTime.fromMillisecondsSinceEpoch(this ?? 0));
  }

  DateTime? toDatetime() {
    if ((this ?? 0) <= 0) return null;
    return (DateTime.fromMillisecondsSinceEpoch(this ?? 0));
  }

  String? toTime() {
    if ((this ?? 0) <= 0) return null;
    return DateFormat(
      "HH:mm",
    ).format(DateTime.fromMillisecondsSinceEpoch(this ?? 0));
  }
}

extension NumberParsing on num? {
  String? formatPrice() {
    if (this == null || this == 0) return '0 ${'dzd'.tr}';
    return NumberFormat('#,##0.## ${"dzd".tr}', 'fr_DZ').format(this);
  }

  String? formatNumber() {
    if (this == null) return null;
    String res = this.toString();
    if (res.endsWith('.0')) {
      res = res.substring(0, res.length - 2);
    }
    return res;
  }
}

extension ProductImage on Product {
  DecorationImage? toDecorationImage() {
    return img?.toDecorationImage();
  }

  ImageProvider? toImageProvider() {
    return img?.toImageProvider();
  }

  Widget leading() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: toDecorationImage(),
          color:
              toDecorationImage() == null
                  ? [
                    Colors.teal[900]!,
                    Colors.amber,
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.purple,
                    Colors.orange,
                    Colors.cyan,
                    Colors.indigo,
                    Colors.pink,
                    Colors.brown,
                    Colors.deepOrange,
                    Colors.deepPurple,
                  ][(remoteId ?? id ?? 0) % 8]
                  : null,
        ),
        child:
            toDecorationImage() == null
                ? FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${name?.substring(0, 1).toUpperCase()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}

extension BrandImage on Brand {
  DecorationImage? toDecorationImage() {
    return img?.toDecorationImage();
  }

  ImageProvider? toImageProvider() {
    return img?.toImageProvider();
  }
}

extension CategoryImage on CategoryModel {
  DecorationImage? toDecorationImage() {
    return img?.toDecorationImage();
  }

  ImageProvider? toImageProvider() {
    return img?.toImageProvider();
  }
}

extension UserImage on UserModel {
  DecorationImage? toDecorationImage() {
    return img?.toDecorationImage();
  }

  ImageProvider? toImageProvider() {
    return img?.toImageProvider();
  }

  Widget circleAvatar({double? radius}) {
    return CircleAvatar(
      radius: radius ?? 27,
      backgroundImage: toImageProvider(),
      backgroundColor:
          id == null
              ? null
              : toImageProvider() == null
              ? toDecorationImage() == null
                  ? [
                    Colors.teal[900]!,
                    Colors.amber,
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.purple,
                    Colors.orange,
                    Colors.cyan,
                    Colors.indigo,
                    Colors.pink,
                    Colors.brown,
                    Colors.deepOrange,
                    Colors.deepPurple,
                  ][(remoteId ?? id ?? 0) % 8]
                  : null
              : null,
      child:
          id == null
              ? Icon(Icons.person, size: (radius ?? 27))
              : toImageProvider() == null
              ? FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    firstName?.substring(0, 1).toUpperCase() ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}

extension StringImage on String? {
  DecorationImage? toDecorationImage() {
    if (!File(this ?? '').existsSync()) return null;
    return DecorationImage(
      image: FileImage(File(this ?? '')),
      fit: BoxFit.cover,
    );
  }

  ImageProvider? toImageProvider() {
    if (!File(this ?? '').existsSync()) return null;
    return FileImage(File(this ?? ''));
  }
}
