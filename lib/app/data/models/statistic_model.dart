import 'dart:convert';

class StatisticModel {
  final double? totalCustomerPayment;
  final double? totalSupplierPayment;
  final double? totalPurchasePayment;
  final double? totalSalePayment;
  final double? totalFeesPayment;
  final double? totalPurchase;
  final double? totalSale;
  final double? totalCustomerCredit;
  final double? totalSupplierCredit;
  final double? totalBenefit;
  final double? totalStockValue;
  final int? purchaseCount;
  final int? saleCount;
  final int? productCount;
  final int? customerCount;
  final int? supplierCount;
  StatisticModel({
    this.totalCustomerPayment,
    this.totalSupplierPayment,
    this.totalPurchasePayment,
    this.totalSalePayment,
    this.totalFeesPayment,
    this.totalPurchase,
    this.totalSale,
    this.totalCustomerCredit,
    this.totalSupplierCredit,
    this.totalBenefit,
    this.totalStockValue,
    this.purchaseCount,
    this.saleCount,
    this.productCount,
    this.customerCount,
    this.supplierCount,
  });

  StatisticModel copyWith({
    double? totalCustomerPayment,
    double? totalSupplierPayment,
    double? totalPurchasePayment,
    double? totalSalePayment,
    double? totalFeesPayment,
    double? totalPurchase,
    double? totalSale,
    double? totalCustomerCredit,
    double? totalSupplierCredit,
    double? totalBenefit,
    double? totalStockValue,
    int? purchaseCount,
    int? saleCount,
    int? productCount,
    int? customerCount,
    int? supplierCount,
  }) {
    return StatisticModel(
      totalCustomerPayment: totalCustomerPayment ?? this.totalCustomerPayment,
      totalSupplierPayment: totalSupplierPayment ?? this.totalSupplierPayment,
      totalPurchasePayment: totalPurchasePayment ?? this.totalPurchasePayment,
      totalSalePayment: totalSalePayment ?? this.totalSalePayment,
      totalFeesPayment: totalFeesPayment ?? this.totalFeesPayment,
      totalPurchase: totalPurchase ?? this.totalPurchase,
      totalSale: totalSale ?? this.totalSale,
      totalCustomerCredit: totalCustomerCredit ?? this.totalCustomerCredit,
      totalSupplierCredit: totalSupplierCredit ?? this.totalSupplierCredit,
      totalBenefit: totalBenefit ?? this.totalBenefit,
      totalStockValue: totalStockValue ?? this.totalStockValue,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      saleCount: saleCount ?? this.saleCount,
      productCount: productCount ?? this.productCount,
      customerCount: customerCount ?? this.customerCount,
      supplierCount: supplierCount ?? this.supplierCount,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (totalCustomerPayment != null) {
      result.addAll({'totalCustomerPayment': totalCustomerPayment});
    }
    if (totalSupplierPayment != null) {
      result.addAll({'totalSupplierPayment': totalSupplierPayment});
    }
    if (totalPurchasePayment != null) {
      result.addAll({'totalPurchasePayment': totalPurchasePayment});
    }
    if (totalSalePayment != null) {
      result.addAll({'totalSalePayment': totalSalePayment});
    }
    if (totalFeesPayment != null) {
      result.addAll({'totalFeesPayment': totalFeesPayment});
    }
    if (totalPurchase != null) {
      result.addAll({'totalPurchase': totalPurchase});
    }
    if (totalSale != null) {
      result.addAll({'totalSale': totalSale});
    }
    if (totalCustomerCredit != null) {
      result.addAll({'totalCustomerCredit': totalCustomerCredit});
    }
    if (totalSupplierCredit != null) {
      result.addAll({'totalSupplierCredit': totalSupplierCredit});
    }
    if (totalBenefit != null) {
      result.addAll({'totalBenefit': totalBenefit});
    }
    if (totalStockValue != null) {
      result.addAll({'totalStockValue': totalStockValue});
    }
    if (purchaseCount != null) {
      result.addAll({'purchaseCount': purchaseCount});
    }
    if (saleCount != null) {
      result.addAll({'saleCount': saleCount});
    }
    if (productCount != null) {
      result.addAll({'productCount': productCount});
    }
    if (customerCount != null) {
      result.addAll({'customerCount': customerCount});
    }
    if (supplierCount != null) {
      result.addAll({'supplierCount': supplierCount});
    }

    return result;
  }

  factory StatisticModel.fromMap(Map<String, dynamic> map) {
    return StatisticModel(
      totalCustomerPayment: map['totalCustomerPayment']?.toDouble(),
      totalSupplierPayment: map['totalSupplierPayment']?.toDouble(),
      totalPurchasePayment: map['totalPurchasePayment']?.toDouble(),
      totalSalePayment: map['totalSalePayment']?.toDouble(),
      totalFeesPayment: map['totalFeesPayment']?.toDouble(),
      totalPurchase: map['totalPurchase']?.toDouble(),
      totalSale: map['totalSale']?.toDouble(),
      totalCustomerCredit: map['totalCustomerCredit']?.toDouble(),
      totalSupplierCredit: map['totalSupplierCredit']?.toDouble(),
      totalBenefit: map['totalBenefit']?.toDouble(),
      totalStockValue: map['totalStockValue']?.toDouble(),
      purchaseCount: map['purchaseCount']?.toInt(),
      saleCount: map['saleCount']?.toInt(),
      productCount: map['productCount']?.toInt(),
      customerCount: map['customerCount']?.toInt(),
      supplierCount: map['supplierCount']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticModel.fromJson(String source) =>
      StatisticModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatisticModel(totalCustomerPayment: $totalCustomerPayment, totalSupplierPayment: $totalSupplierPayment, totalPurchasePayment: $totalPurchasePayment, totalSalePayment: $totalSalePayment, totalFeesPayment: $totalFeesPayment, totalPurchase: $totalPurchase, totalSale: $totalSale, totalCustomerCredit: $totalCustomerCredit, totalSupplierCredit: $totalSupplierCredit, totalBenefit: $totalBenefit, totalStockValue: $totalStockValue, purchaseCount: $purchaseCount, saleCount: $saleCount, productCount: $productCount, customerCount: $customerCount, supplierCount: $supplierCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatisticModel &&
        other.totalCustomerPayment == totalCustomerPayment &&
        other.totalSupplierPayment == totalSupplierPayment &&
        other.totalPurchasePayment == totalPurchasePayment &&
        other.totalSalePayment == totalSalePayment &&
        other.totalFeesPayment == totalFeesPayment &&
        other.totalPurchase == totalPurchase &&
        other.totalSale == totalSale &&
        other.totalCustomerCredit == totalCustomerCredit &&
        other.totalSupplierCredit == totalSupplierCredit &&
        other.totalBenefit == totalBenefit &&
        other.totalStockValue == totalStockValue &&
        other.purchaseCount == purchaseCount &&
        other.saleCount == saleCount &&
        other.productCount == productCount &&
        other.customerCount == customerCount &&
        other.supplierCount == supplierCount;
  }

  @override
  int get hashCode {
    return totalCustomerPayment.hashCode ^
        totalSupplierPayment.hashCode ^
        totalPurchasePayment.hashCode ^
        totalSalePayment.hashCode ^
        totalFeesPayment.hashCode ^
        totalPurchase.hashCode ^
        totalSale.hashCode ^
        totalCustomerCredit.hashCode ^
        totalSupplierCredit.hashCode ^
        totalBenefit.hashCode ^
        totalStockValue.hashCode ^
        purchaseCount.hashCode ^
        saleCount.hashCode ^
        productCount.hashCode ^
        customerCount.hashCode ^
        supplierCount.hashCode;
  }
}
