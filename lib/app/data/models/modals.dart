import 'package:tracora/app/data/models/brand_model.dart';
import 'package:tracora/app/data/models/cart_model.dart';
import 'package:tracora/app/data/models/category_model.dart';
import 'package:tracora/app/data/models/image_model.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';

class DbModels {
  static final List<dynamic> models = [
    ImageModel(),
    Brand(),
    Cart(),
    CategoryModel(),
    MoneyTransaction(),
    Product(),
    ProductTransaction(),
    StockTransaction(),
    UserModel(),
  ];
}
