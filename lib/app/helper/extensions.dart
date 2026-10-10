import 'dart:io';
import 'dart:typed_data';

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
  String formatPrice() {
    if (this == null || this == 0) return '0 ${'dzd'.tr}';
    return NumberFormat('#,##0.## ${"dzd".tr}', 'fr_DZ').format(this);
  }

  String formatNumber() {
    if (this == null) return "0";
    String res = this.toString();
    if (res.endsWith('.0')) {
      res = res.substring(0, res.length - 2);
    }
    return res;
  }
}

extension ProductImage on Product {
  Widget leading() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              [
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
              ][(id.hashCode) % 12],
        ),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '${name?.substring(0, 1).toUpperCase()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

extension BrandImage on Brand {
  DecorationImage? toDecorationImage() {
    return image?.toDecorationImage();
  }

  ImageProvider? toImageProvider() {
    return image?.toImageProvider();
  }
}

extension CategoryImage on CategoryModel {}

extension UserImage on UserModel {
  Widget circleAvatar({double? radius}) {
    return CircleAvatar(
      radius: radius ?? 27,

      backgroundColor:
          id == null
              ? Colors.transparent
              : [
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
              ][(id.hashCode) % 12],
      child:
          id == null
              ? Icon(Icons.person, size: (radius ?? 27))
              : FittedBox(
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
              ),
    );
  }
}

extension StringImage on String? {
  DecorationImage? toDecorationImage() {
    if ((this ?? '').isEmpty) return null;
    return DecorationImage(
      image: FileImage(File(this ?? '')),
      fit: BoxFit.cover,
    );
  }

  ImageProvider? toImageProvider() {
    if ((this ?? '').isEmpty) return null;
    return FileImage(File(this ?? ''));
  }
}

extension DataImage on Uint8List? {
  DecorationImage? toDecorationImage() {
    if (this == null) return null;
    return DecorationImage(image: MemoryImage(this!), fit: BoxFit.cover);
  }

  ImageProvider? toImageProvider() {
    if (this == null) return null;
    return MemoryImage(this!);
  }
}
