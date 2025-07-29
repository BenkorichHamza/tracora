import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/helper/extensions.dart';

class ProductTransactionTile<T> extends StatelessWidget {
  const ProductTransactionTile({super.key, required this.productTransaction});

  final ProductTransaction productTransaction;

  @override
  Widget build(BuildContext context) {
    var product = productTransaction.product;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ListTile(
        dense: true,
        leading: product?.leading(),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: Text(product?.translateName ?? ''),
        trailing: SizedBox(
          width: 150,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (productTransaction.qte.formatNumber() ?? '0'),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: Text(
                  (productTransaction.total.formatPrice() ?? '0'),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
