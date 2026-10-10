import 'package:get/get.dart';

import '../modules/Brand/bindings/brand_binding.dart';
import '../modules/Brand/views/brand_view.dart';
import '../modules/BrandForm/bindings/brand_form_binding.dart';
import '../modules/BrandForm/views/brand_form_view.dart';
import '../modules/Category/bindings/category_binding.dart';
import '../modules/Category/views/category_view.dart';
import '../modules/CategoryForm/bindings/category_form_binding.dart';
import '../modules/CategoryForm/views/category_form_view.dart';
import '../modules/CustomerDetails/bindings/user_details_binding.dart';
import '../modules/CustomerDetails/views/user_details_view.dart';
import '../modules/FeesPayment/bindings/fees_payment_binding.dart';
import '../modules/FeesPayment/views/fees_payment_view.dart';
import '../modules/FeesPaymentDetails/bindings/fees_payment_details_binding.dart';
import '../modules/FeesPaymentDetails/views/fees_payment_details_view.dart';
import '../modules/FeesPaymentForm/bindings/fees_payment_form_binding.dart';
import '../modules/FeesPaymentForm/views/fees_payment_form_view.dart';
import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/PosHome/bindings/pos_home_binding.dart';
import '../modules/PosHome/views/pos_home_view.dart';
import '../modules/Product/bindings/product_binding.dart';
import '../modules/Product/views/product_view.dart';
import '../modules/ProductDetails/bindings/product_details_binding.dart';
import '../modules/ProductDetails/views/product_details_view.dart';
import '../modules/ProductForm/bindings/product_form_binding.dart';
import '../modules/ProductForm/views/product_form_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/RolePermission/bindings/role_permission_binding.dart';
import '../modules/RolePermission/views/role_permission_view.dart';
import '../modules/Setting/bindings/setting_binding.dart';
import '../modules/Setting/views/setting_view.dart';
import '../modules/Statistic/bindings/statistic_binding.dart';
import '../modules/Statistic/views/statistic_view.dart';
import '../modules/StockTransaction/bindings/transaction_binding.dart';
import '../modules/StockTransaction/views/transaction_view.dart';
import '../modules/StockTransactionDetails/bindings/sale_details_binding.dart';
import '../modules/StockTransactionDetails/views/stock_transaction_details_view.dart';
import '../modules/Synchronisation/bindings/synchronisation_binding.dart';
import '../modules/Synchronisation/views/synchronisation_view.dart';
import '../modules/User/bindings/user_binding.dart';
import '../modules/User/views/user_view.dart';
import '../modules/UserPayment/bindings/user_payment_binding.dart';
import '../modules/UserPayment/views/user_payment_view.dart';
import '../modules/UserPaymentDetails/bindings/user_payment_details_binding.dart';
import '../modules/UserPaymentDetails/views/user_payment_details_view.dart';
import '../modules/UserPaymentForm/bindings/user_payment_form_binding.dart';
import '../modules/UserPaymentForm/views/user_payment_form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/warehouse/bindings/warehouse_binding.dart';
import '../modules/warehouse/views/warehouse_view.dart';
import '../modules/warehouse_details/bindings/warehouse_details_binding.dart';
import '../modules/warehouse_details/views/warehouse_details_view.dart';
import '../modules/warehouse_form/bindings/warehouse_form_binding.dart';
import '../modules/warehouse_form/views/warehouse_form_view.dart';

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
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.SALE_DETAILS,
      page: () => const StockTransactionDetailsView(),
      binding: SaleDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SALE,
      page: () => const StockTransactionView(),
      binding: SaleBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT,
      page: () => const UserPaymentView(),
      binding: CustomerPaymentBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT_DETAILS,
      page: () => const UserPaymentDetailsView(),
      binding: UserPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_PAYMENT_FORM,
      page: () => const UserPaymentFormView(),
      binding: UserPaymentFormBinding(),
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
      name: _Paths.CUSTOMER_DETAILS,
      page: () => const UserDetailsView(),
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => const StatisticView(),
      binding: StatisticBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.POS_HOME,
      page: () => const PosHomeView(),
      binding: PosHomeBinding(),
    ),
    GetPage(
      name: _Paths.SYNCHRONISATION,
      page: () => const SynchronisationView(),
      binding: SynchronisationBinding(),
    ),
    GetPage(
      name: _Paths.WAREHOUSE,
      page: () => const WarehouseView(),
      binding: WarehouseBinding(),
    ),
    GetPage(
      name: _Paths.WAREHOUSE_FORM,
      page: () => const WarehouseFormView(),
      binding: WarehouseFormBinding(),
    ),
    GetPage(
      name: _Paths.WAREHOUSE_DETAILS,
      page: () => const WarehouseDetailsView(),
      binding: WarehouseDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ROLE_PERMISSION,
      page: () => const RolePermissionView(),
      binding: RolePermissionBinding(),
    ),
  ];
}
