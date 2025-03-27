import 'dart:io';

import 'package:get/get.dart';
import 'package:tracora/app/modules/Customer/controllers/customer_controller.dart';
import 'package:tracora/app/modules/CustomerPayment/controllers/customer_payment_controller.dart';
import 'package:tracora/app/modules/Login/controllers/login_controller.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/Purchase/controllers/purchase_controller.dart';
import 'package:tracora/app/modules/Sale/controllers/sale_controller.dart';
import 'package:tracora/app/modules/SaleDetails/controllers/sale_details_controller.dart';
import 'package:tracora/app/modules/SaleForm/controllers/sale_form_controller.dart';
import 'package:tracora/app/modules/Supplier/controllers/supplier_controller.dart';
import 'package:tracora/app/modules/SupplierPayment/controllers/supplier_payment_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(LoginController());
    if (Platform.isWindows) {
      Get.put(SaleController());
      Get.put(SaleDetailsController());
      Get.put(SaleFormController());
      Get.put(PurchaseController());
      Get.put(CustomerPaymentController());
      Get.put(SupplierPaymentController());
      Get.put(CustomerController());
      Get.put(SupplierController());
      Get.put(ProductController());
    }
  }
}
