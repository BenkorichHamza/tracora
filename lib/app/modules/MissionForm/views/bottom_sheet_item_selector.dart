import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/mission_model.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';

class ItemBottomSheet extends StatefulWidget {
  final MissionProduct missionProduct;
  const ItemBottomSheet({super.key, required this.missionProduct});

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  late Product product;
  late double qte;
  late TextEditingController qteCtrl;
  late FocusNode qteFn;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    product = widget.missionProduct.product ?? Product();
    qte = widget.missionProduct.qte ?? 0;
    qteCtrl = TextEditingController(
      text: widget.missionProduct.qte.formatNumber(),
    );

    qteFn =
        FocusNode()..addListener(() {
          if (qteFn.hasFocus) {
            qteCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: qteCtrl.text.length,
            );
          }
        });

    qteCtrl.selection = TextSelection(
      baseOffset: 0,
      extentOffset: qteCtrl.text.length,
    );
    qteCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 120,
                            child: product.leading(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 4),
                              title: Text(
                                product.translateName ?? 'product'.tr,
                                maxLines: 3,
                              ),
                              subtitle: Text(
                                '${product.buyPrice}/${product.unity?.toUpperCase() ?? 'U'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () => Get.back(result: 0.0),
                                icon: Icon(Icons.delete_outline),
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // IconButton.outlined(
                                //   onPressed: decrement,
                                //   icon: Icon(Icons.remove),
                                // ),
                                Expanded(
                                  child: TextFormField(
                                    focusNode: qteFn,
                                    textDirection: TextDirection.ltr,
                                    // onFieldSubmitted: (v) {
                                    //   if (_formKey.currentState?.validate() !=
                                    //       true) {
                                    //     Get.back();
                                    //     return;
                                    //   }
                                    //   submit();
                                    // },
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    // validator: validate,
                                    controller: qteCtrl,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9.]"),
                                      ),
                                      TextInputFormatter.withFunction((
                                        oldValue,
                                        newValue,
                                      ) {
                                        final text = newValue.text;
                                        if (text.contains('.') &&
                                            text.split('.').last.length > 2) {
                                          return oldValue;
                                        }
                                        if (text.startsWith('00')) {
                                          return oldValue;
                                        }
                                        if (text.startsWith('.')) {
                                          return oldValue;
                                        }

                                        if (text.startsWith('0') &&
                                            !text.startsWith('0.') &&
                                            text.length > 1) {
                                          return oldValue.copyWith(
                                            text:
                                                int.tryParse(
                                                  text,
                                                )?.toString() ??
                                                '0',
                                          );
                                        }
                                        if (text.characters
                                                .where((c) => c == ".")
                                                .length >
                                            1) {
                                          return oldValue;
                                        }

                                        return newValue;
                                      }),
                                    ],
                                    decoration: InputDecoration(
                                      error:
                                          validate(qteCtrl.text) == null
                                              ? null
                                              : SizedBox(),
                                      label: Text('  ${'qte'.tr}'),
                                      contentPadding: EdgeInsets.all(0),
                                      border: OutlineInputBorder(),
                                      suffix: Text(
                                        (product.unity ?? 'u') + ' ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: submit,
                            child: Text('validate'.tr),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.back(
        result: MissionProduct(
          qte: double.tryParse(qteCtrl.text),
          product: product,
        ),
      );
    }
  }

  increment() {
    var ov = double.tryParse(qteCtrl.text) ?? 0;

    var v = ov + 1;

    qteCtrl.text = v.formatNumber()!;
  }

  decrement() {
    var ov = double.tryParse(qteCtrl.text) ?? 0;

    var v = ov - 1;
    if (v < 0) v = 0;
    qteCtrl.text = v.formatNumber()!;
  }

  String? validate(String? v) {
    if (v == null) return "invalid".tr;

    var d = double.tryParse(v);
    if (d == 0) return null;
    if (d == null) return 'invalid'.tr;
    var validInt = d == d.floor();

    return null;
  }
}
