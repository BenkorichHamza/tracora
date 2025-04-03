import 'dart:io';

import 'package:get/get.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/modules/FeesPayment/controllers/fees_payment_controller.dart';
import 'package:tracora/app/modules/FeesPaymentDetails/controllers/fees_payment_details_controller.dart';
import 'package:tracora/app/modules/FeesPaymentForm/controllers/fees_payment_form_controller.dart';
import 'package:tracora/app/modules/ProductDetails/controllers/product_details_controller.dart';
import 'package:tracora/app/modules/ProductForm/controllers/product_form_controller.dart';
import 'package:tracora/app/modules/Setting/controllers/setting_controller.dart';
import 'package:tracora/app/modules/User/controllers/user_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/controllers/user_details_controller.dart';
import 'package:tracora/app/modules/CustomerDetails/views/user_details_view.dart';
import 'package:tracora/app/modules/UserForm/controllers/user_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/UserPaymentForm/controllers/user_payment_form_controller.dart';
import 'package:tracora/app/modules/Login/controllers/login_controller.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/StockTransactionDetails/controllers/stock_transaction_details_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(LoginController());
    if (Platform.isWindows) {
      Get.put(StockTransactionController<Sale>());
      Get.put(StockTransactionDetailsController<Sale>());
      Get.put(TransactionFormController<Sale>());
      Get.put(StockTransactionController<Purchase>());
      Get.put(StockTransactionDetailsController<Purchase>());
      Get.put(TransactionFormController<Purchase>());
      Get.put(StockTransactionController<Mission>());
      Get.put(StockTransactionDetailsController<Mission>());
      Get.put(TransactionFormController<Mission>());
      Get.put(UserPaymentController<Sale>());
      Get.put(UserPaymentController<Purchase>());
      Get.put(UserPaymentFormController<Sale>());
      Get.put(UserPaymentFormController<Purchase>());
      Get.put(UserPaymentDetailsController<Sale>());
      Get.put(UserPaymentDetailsController<Purchase>());
      Get.put(UserController<Customer>());
      Get.put(UserFormController<Customer>());
      Get.put(UserDetailsController<Customer>());
      Get.put(UserController<Supplier>());
      Get.put(UserFormController<Supplier>());
      Get.put(UserDetailsController<Supplier>());
      Get.put(UserController<Employee>());
      Get.put(UserFormController<Employee>());
      Get.put(UserDetailsController<Employee>());
      Get.put(FeesPaymentController());
      Get.put(FeesPaymentDetailsController());
      Get.put(FeesPaymentFormController());
      Get.put(ProductController());
      Get.put(ProductDetailsController());
      Get.put(ProductFormController());
      Get.put(SettingController());
    }
  }
}
