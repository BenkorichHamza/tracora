import 'package:get/get.dart';

import '../modules/Brand/bindings/brand_binding.dart';
import '../modules/Brand/views/brand_view.dart';
import '../modules/BrandForm/bindings/brand_form_binding.dart';
import '../modules/BrandForm/views/brand_form_view.dart';
import '../modules/Category/bindings/category_binding.dart';
import '../modules/Category/views/category_view.dart';
import '../modules/CategoryForm/bindings/category_form_binding.dart';
import '../modules/CategoryForm/views/category_form_view.dart';
import '../modules/Customer/bindings/customer_binding.dart';
import '../modules/Customer/bindings/customer_binding.dart';
import '../modules/Customer/views/customer_view.dart';
import '../modules/Customer/views/customer_view.dart';
import '../modules/CustomerDetails/bindings/customer_details_binding.dart';
import '../modules/CustomerDetails/views/customer_details_view.dart';
import '../modules/CustomerForm/bindings/customer_form_binding.dart';
import '../modules/CustomerForm/views/customer_form_view.dart';
import '../modules/CustomerPayment/bindings/customer_payment_binding.dart';
import '../modules/CustomerPayment/views/customer_payment_view.dart';
import '../modules/CustomerPaymentDetails/bindings/customer_payment_details_binding.dart';
import '../modules/CustomerPaymentDetails/views/customer_payment_details_view.dart';
import '../modules/CustomerPaymentForm/bindings/customer_payment_form_binding.dart';
import '../modules/CustomerPaymentForm/views/customer_payment_form_view.dart';
import '../modules/FeesPayment/bindings/fees_payment_binding.dart';
import '../modules/FeesPayment/views/fees_payment_view.dart';
import '../modules/FeesPaymentDetails/bindings/fees_payment_details_binding.dart';
import '../modules/FeesPaymentDetails/views/fees_payment_details_view.dart';
import '../modules/FeesPaymentForm/bindings/fees_payment_form_binding.dart';
import '../modules/FeesPaymentForm/views/fees_payment_form_view.dart';
import '../modules/Product/bindings/product_binding.dart';
import '../modules/Product/views/product_view.dart';
import '../modules/ProductForm/bindings/product_form_binding.dart';
import '../modules/ProductForm/views/product_form_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/Purchase/bindings/purchase_binding.dart';
import '../modules/Purchase/views/purchase_view.dart';
import '../modules/PurchaseDetails/bindings/purchase_details_binding.dart';
import '../modules/PurchaseDetails/views/purchase_details_view.dart';
import '../modules/PurchaseForm/bindings/purchase_form_binding.dart';
import '../modules/PurchaseForm/views/purchase_form_view.dart';
import '../modules/Sale/bindings/sale_binding.dart';
import '../modules/Sale/views/sale_view.dart';
import '../modules/SaleDetails/bindings/sale_details_binding.dart';
import '../modules/SaleDetails/views/sale_details_view.dart';
import '../modules/SaleForm/bindings/sale_form_binding.dart';
import '../modules/SaleForm/views/sale_form_view.dart';
import '../modules/Settings/bindings/settings_binding.dart';
import '../modules/Settings/views/settings_view.dart';
import '../modules/Statistic/bindings/statistic_binding.dart';
import '../modules/Statistic/views/statistic_view.dart';
import '../modules/Supplier/bindings/supplier_binding.dart';
import '../modules/Supplier/views/supplier_view.dart';
import '../modules/SupplierDetails/bindings/supplier_details_binding.dart';
import '../modules/SupplierDetails/views/supplier_details_view.dart';
import '../modules/SupplierForm/bindings/supplier_form_binding.dart';
import '../modules/SupplierForm/views/supplier_form_view.dart';
import '../modules/SupplierPayment/bindings/supplier_payment_binding.dart';
import '../modules/SupplierPayment/views/supplier_payment_view.dart';
import '../modules/SupplierPaymentDetails/bindings/supplier_payment_details_binding.dart';
import '../modules/SupplierPaymentDetails/views/supplier_payment_details_view.dart';
import '../modules/SupplierPaymentForm/bindings/supplier_payment_form_binding.dart';
import '../modules/SupplierPaymentForm/views/supplier_payment_form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_FORM,
      page: () => const ProductFormView(),
      binding: ProductFormBinding(),
    ),
    GetPage(
      name: _Paths.BRAND,
      page: () => const BrandView(),
      binding: BrandBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.BRAND_FORM,
      page: () => const BrandFormView(),
      binding: BrandFormBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_FORM,
      page: () => const CategoryFormView(),
      binding: CategoryFormBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER,
      page: () => const CustomerView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_FORM,
      page: () => const CustomerFormView(),
      binding: CustomerFormBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER,
      page: () => const SupplierView(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_FORM,
      page: () => const SupplierFormView(),
      binding: SupplierFormBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE,
      page: () => const PurchaseView(),
      binding: PurchaseBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_FORM,
      page: () => const PurchaseFormView(),
      binding: PurchaseFormBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_DETAILS,
      page: () => const PurchaseDetailsView(),
      binding: PurchaseDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SALE_DETAILS,
      page: () => const SaleDetailsView(),
      binding: SaleDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SALE,
      page: () => const SaleView(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: _Paths.SALE_FORM,
      page: () => const SaleFormView(),
      binding: SaleFormBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_PAYMENT,
      page: () => const SupplierPaymentView(),
      binding: SupplierPaymentBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_PAYMENT_FORM,
      page: () => const SupplierPaymentFormView(),
      binding: SupplierPaymentFormBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_PAYMENT_DETAILS,
      page: () => const SupplierPaymentDetailsView(),
      binding: SupplierPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT,
      page: () => const CustomerPaymentView(),
      binding: CustomerPaymentBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT_DETAILS,
      page: () => const CustomerPaymentDetailsView(),
      binding: CustomerPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT_FORM,
      page: () => const CustomerPaymentFormView(),
      binding: CustomerPaymentFormBinding(),
    ),
    GetPage(
      name: _Paths.FEES_PAYMENT,
      page: () => const FeesPaymentView(),
      binding: FeesPaymentBinding(),
    ),
    GetPage(
      name: _Paths.FEES_PAYMENT_DETAILS,
      page: () => const FeesPaymentDetailsView(),
      binding: FeesPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.FEES_PAYMENT_FORM,
      page: () => const FeesPaymentFormView(),
      binding: FeesPaymentFormBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_DETAILS,
      page: () => const SupplierDetailsView(),
      binding: SupplierDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_DETAILS,
      page: () => const CustomerDetailsView(),
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => const StatisticView(),
      binding: StatisticBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
