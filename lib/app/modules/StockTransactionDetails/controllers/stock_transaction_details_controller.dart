import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/money_transaction.dart';
import 'package:tracora/app/data/models/product_model.dart';
import 'package:tracora/app/data/models/product_transaction_model.dart';
import 'package:tracora/app/data/models/stock_transaction_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/data/repositories/money_transaction_repository.dart';
import 'package:tracora/app/data/repositories/stock_transaction_repository.dart';
import 'package:tracora/app/helper/delete_dialog.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/Product/controllers/product_controller.dart';
import 'package:tracora/app/modules/Statistic/controllers/statistic_controller.dart';
import 'package:tracora/app/modules/StockTransaction/controllers/transaction_controller.dart';
import 'package:tracora/app/modules/TransactionForm/controllers/transaction_form_controller.dart';
import 'package:tracora/app/modules/UserPayment/controllers/user_payment_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';

class StockTransactionDetailsController<T> extends GetxController
    with GetTickerProviderStateMixin {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  final _synchronisationLoading = false.obs;
  bool get synchronisationLoading => this._synchronisationLoading.value;
  set synchronisationLoading(bool value) =>
      this._synchronisationLoading.value = value;

  final _changed = false.obs;
  bool get changed => this._changed.value;
  set changed(bool value) => this._changed.value = value;

  final _stockTransactions = <StockTransaction>[].obs;
  List<StockTransaction> get stockTransactions => this._stockTransactions.value;
  set stockTransactions(List<StockTransaction> value) =>
      this._stockTransactions.value = value;

  final _moneyTransactions = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get moneyTransactions => this._moneyTransactions.value;
  set moneyTransactions(List<MoneyTransaction> value) =>
      this._moneyTransactions.value = value;

  final StockTransactionRepository repository = StockTransactionRepository();
  final _stockTansaction = StockTransaction().obs;
  StockTransaction get stockTransaction => this._stockTansaction.value;
  set stockTransaction(StockTransaction value) =>
      this._stockTansaction.value = value;

  final _productTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get productTransactions =>
      this._productTransactions.value;
  set productTransactions(List<ProductTransaction> value) =>
      this._productTransactions.value = value;

  final _transfertProductTransactions = <ProductTransaction>[].obs;
  List<ProductTransaction> get transfertProductTransactions =>
      this._transfertProductTransactions.value;
  set transfertProductTransactions(List<ProductTransaction> value) =>
      this._transfertProductTransactions.value = value;

  final _transfertSales = <StockTransaction>[].obs;
  List<StockTransaction> get transfertSales => this._transfertSales.value;
  set transfertSales(List<StockTransaction> value) =>
      this._transfertSales.value = value;

  final _transfertOnlineSales = <StockTransaction>[].obs;
  List<StockTransaction> get transfertOnlineSales =>
      this._transfertOnlineSales.value;
  set transfertOnlineSales(List<StockTransaction> value) =>
      this._transfertOnlineSales.value = value;

  final _transfertPayments = <MoneyTransaction>[].obs;
  List<MoneyTransaction> get transfertPayments => this._transfertPayments.value;
  set transfertPayments(List<MoneyTransaction> value) =>
      this._transfertPayments.value = value;

  final _sync = false.obs;
  get sync => this._sync.value;
  set sync(value) => this._sync.value = value;

  late TabController tabCtrl;

  String get userType =>
      T == Sale || T == Customer
          ? "customer"
          : T == Purchase || T == Supplier
          ? "supplier"
          : "employee";
  String get transactionType =>
      T == Sale || T == Customer
          ? "sale"
          : T == Purchase || T == Supplier
          ? "purchase"
          : "transfert";

  double get total => productTransactions.fold(
    0.0,
    (previousValue, element) =>
        previousValue + (element.qte ?? 0) * (element.price ?? 0),
  );

  double saledQteOf(ProductTransaction? pt) =>
      pt?.product == null
          ? 0
          : transfertProductTransactions
              .where((e) => e.product?.id == pt?.product?.id)
              .fold(0.0, (a, b) => a + (b.qte ?? 0) * (b.direction ?? 0))
              .abs();
  double restQteOf(ProductTransaction? pt) =>
      pt?.product == null ? 0 : (pt!.qte ?? 0) - saledQteOf(pt);

  late StreamSubscription listener;
  late StreamSubscription paymentListener;

  @override
  void onInit() {
    tabCtrl = TabController(length: 4, vsync: this);
    if (Get.arguments?['sale'] is StockTransaction) {
      stockTransaction = Get.arguments?["sale"] ?? stockTransaction;
      productTransactions =
          stockTransaction.productTransactions ?? productTransactions;
    }
    if (stockTransaction.id != null) {
      getStockTransaction();
    }
    getProductTransactions();
    if (T == Transfert) {
      // getTransfertStockTransactions();
      // listenToSales();
      // listenToPayments();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getProductTransactions() async {
    try {
      // loading = true;
      productTransactions = await repository.getProductTransactions(
        stockTransaction.id ?? "",
      );
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  delete() async {
    var b = await deleteConfirmation();
    if (b != true) return;
    await repository.deleteTransaction(stockTransaction);
    Get.find<StockTransactionController<T>>().getAll();
    stockTransaction = StockTransaction();
    productTransactions = <ProductTransaction>[];
  }

  Future getStockTransaction() async {
    try {
      var r = await StockTransactionRepository().getStockTransactionById(
        id: stockTransaction.id ?? "",
      );
      stockTransaction = r ?? stockTransaction;
      Get.find<StockTransactionController<Transfert>>().getAll();
      getProductTransactions();
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  listenToSSales() async {
    try {
      await listener.cancel();
    } catch (e) {}
    // listener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(Get.find<HomeController>().collection)
    //     .collection("transferts")
    //     .doc(stockTransaction.id)
    //     .collection("stockTransactions")
    //     .snapshots()
    //     .listen((data) async {
    //       if (data.docChanges.isEmpty) return;
    //       var sales =
    //           data.docs.map((d) => StockTransaction.fromMap(d.data())).toList();
    //       await Future.forEach(sales, (s) async {
    //         if (s.type == "sale") {
    //           await StockTransactionRepository<Sale>().insert(s);
    //         } else {
    //           await StockTransactionRepository<Purchase>().insert(s);
    //         }
    //       });
    //     });
  }

  listenToPayments() async {
    try {
      await paymentListener.cancel();
    } catch (e) {}
    // paymentListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(Get.find<HomeController>().collection)
    //     .collection("transferts")
    //     .doc(stockTransaction.id)
    //     .collection("moneyTransactions")
    //     .snapshots()
    //     .listen((data) async {
    //       var sales =
    //           data.docs.map((d) => MoneyTransaction.fromMap(d.data())).toList();
    //       await Future.forEach(sales, (s) async {
    //         await MoneyTransactionRepository().insertMoneyTransaction(s);
    //       });
    //     });
  }

  edit() {
    Get.lazyPut(() => ProductController());
    changed = true;
    // Get.find<StockTransactionController<T>>().init(stockTransaction);
    Get.find<StockTransactionController<T>>().addNewForm(
      stockTransaction.copyWith(productTransactions: productTransactions),
    );
  }

  late StreamSubscription syncListener;

  double get totalSalePayments =>
      transfertSales.fold(0.0, (a, b) => a + (b.payment ?? 0));

  double get totalPayments =>
      transfertPayments.fold(0.0, (a, b) => a + (b.amount ?? 0));

  double get totalSaled =>
      transfertSales.fold(0.0, (a, b) => a + (b.total ?? 0));

  double get totalCaisse => totalPayments + totalSalePayments;
  listenToSync() {
    sync = false;
    try {
      syncListener.cancel();
    } catch (e) {}
    // syncListener = FirebaseFirestore.instance
    //     .collection("collections")
    //     .doc(Get.find<HomeController>().collection)
    //     .collection("transferts")
    //     .doc(stockTransaction.id)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen((event) {
    //       sync = !event.metadata.hasPendingWrites;
    //     });
  }

  Future<void> printTicket() async {
    final TicketSize? size = await Get.bottomSheet<TicketSize>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              Get.find<HomeController>().theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                'Select ticket size',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _ticketSizeTile(
                icon: Icons.description_outlined,
                title: 'A5',
                subtitle: '148 × 210 mm',
                size: TicketSize.a5,
              ),

              _ticketSizeTile(
                icon: Icons.receipt_long_outlined,
                title: '80 mm',
                subtitle: 'Standard POS receipt',
                size: TicketSize.mm80,
              ),

              _ticketSizeTile(
                icon: Icons.receipt_outlined,
                title: '58 mm',
                subtitle: 'Small POS receipt',
                size: TicketSize.mm58,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );

    if (size == null) return;

    try {
      loading = true;

      final pdf = await _generateTicketPdf(size);

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }

  Widget _ticketSizeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required TicketSize size,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.back(result: size);
      },
    );
  }

  Future<Uint8List> _generateTicketPdf(TicketSize ticketSize) async {
    final pdf = pw.Document();

    final pageFormat = _getPageFormat(ticketSize);

    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: _getPageMargin(ticketSize),
        build: (context) {
          return _buildTicket(ticketSize: ticketSize, date: now);
        },
      ),
    );

    return pdf.save();
  }

  PdfPageFormat _getPageFormat(TicketSize size) {
    switch (size) {
      case TicketSize.a5:
        return PdfPageFormat.a5;

      case TicketSize.mm80:
        // 80 mm wide receipt.
        // Height is intentionally large; content determines the real length
        // when printing through a thermal printer.
        return const PdfPageFormat(
          80 * PdfPageFormat.mm,
          297 * PdfPageFormat.mm,
        );

      case TicketSize.mm58:
        return const PdfPageFormat(
          58 * PdfPageFormat.mm,
          297 * PdfPageFormat.mm,
        );
    }
  }

  pw.EdgeInsets _getPageMargin(TicketSize size) {
    switch (size) {
      case TicketSize.a5:
        return const pw.EdgeInsets.all(20);

      case TicketSize.mm80:
        return const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10);

      case TicketSize.mm58:
        return const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 8);
    }
  }

  pw.Widget _buildTicket({
    required TicketSize ticketSize,
    required DateTime date,
  }) {
    final isSmall = ticketSize == TicketSize.mm58;
    final isA5 = ticketSize == TicketSize.a5;

    final fontSize =
        isA5
            ? 10.0
            : isSmall
            ? 7.0
            : 8.0;

    final titleSize =
        isA5
            ? 22.0
            : isSmall
            ? 14.0
            : 17.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // ---------------------------------------------------------
        // HEADER
        // ---------------------------------------------------------
        pw.Center(
          child: pw.Text(
            'TRACORA',
            style: pw.TextStyle(
              fontSize: titleSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.SizedBox(height: 3),

        pw.Center(
          child: pw.Text(
            'POINT OF SALE',
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.SizedBox(height: 8),

        _divider(),

        pw.SizedBox(height: 5),

        // ---------------------------------------------------------
        // TRANSACTION INFORMATION
        // ---------------------------------------------------------
        // _infoRow('Ticket', stockTransaction.id ?? '-', fontSize),
        _infoRow('Date', DateFormat('dd/MM/yyyy HH:mm').format(date), fontSize),

        if (stockTransaction.user != null)
          _infoRow(
            'Customer',
            stockTransaction.user?.firstName ?? '-',
            fontSize,
          ),

        pw.SizedBox(height: 6),

        _divider(),

        pw.SizedBox(height: 8),

        // ---------------------------------------------------------
        // TABLE HEADER
        // ---------------------------------------------------------
        _buildTableHeader(fontSize: fontSize, isSmall: isSmall),

        pw.SizedBox(height: 4),

        // ---------------------------------------------------------
        // PRODUCTS
        // ---------------------------------------------------------
        ...productTransactions.map(
          (pt) => _buildProductRow(pt, fontSize: fontSize, isSmall: isSmall),
        ),

        pw.SizedBox(height: 8),

        _divider(),

        pw.SizedBox(height: 8),

        // ---------------------------------------------------------
        // TOTAL
        // ---------------------------------------------------------
        _totalRow(
          'TOTAL',
          total,
          fontSize:
              isA5
                  ? 16
                  : isSmall
                  ? 11
                  : 13,
        ),

        pw.SizedBox(height: 10),
        _totalRow(
          'ANCIEN SOLDE',
          stockTransaction.credit ?? 0,
          fontSize: fontSize,
        ),

        pw.SizedBox(height: 10),
        _totalRow(
          'Net a payer',
          (stockTransaction.credit ?? 0) + (stockTransaction.total ?? 0),
          fontSize: fontSize,
        ),

        pw.SizedBox(height: 10),

        if (stockTransaction.payment != null)
          _totalRow('Paid', stockTransaction.payment ?? 0, fontSize: fontSize),

        pw.SizedBox(height: 10),
        _totalRow(
          'Reste a payer',
          (stockTransaction.credit ?? 0) +
              (stockTransaction.total ?? 0) -
              (stockTransaction.payment ?? 0),
          fontSize: fontSize,
        ),
        pw.SizedBox(height: 10),

        _divider(),

        pw.SizedBox(height: 10),

        // // ---------------------------------------------------------
        // // FOOTER
        // // ---------------------------------------------------------
        // pw.Center(
        //   child: pw.Text(
        //     'Merci pour votre achat',
        //     style: pw.TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: pw.FontWeight.bold,
        //     ),
        //     textAlign: pw.TextAlign.center,
        //   ),
        // ),

        // pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            'Powered by Tracora',
            style: pw.TextStyle(fontSize: fontSize - 1),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 12),

        if (stockTransaction.id != null) ...[
          pw.Center(
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: stockTransaction.id!,
              width:
                  isA5
                      ? 90
                      : isSmall
                      ? 55
                      : 70,
              height:
                  isA5
                      ? 90
                      : isSmall
                      ? 55
                      : 70,
            ),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildTableHeader({
    required double fontSize,
    required bool isSmall,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: isSmall ? 5 : 6,
          child: pw.Text(
            'Product',
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.Expanded(
          flex: 2,
          child: pw.Text(
            'Qte',
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.Expanded(
          flex: 3,
          child: pw.Text(
            'P.U',
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.Expanded(
          flex: 3,
          child: pw.Text(
            'Total',
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildProductRow(
    ProductTransaction pt, {
    required double fontSize,
    required bool isSmall,
  }) {
    final productName = pt.product?.name ?? '-';
    final quantity = pt.qte ?? 0;
    final price = pt.price ?? 0;
    final lineTotal = quantity * price;

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: isSmall ? 5 : 6,
            child: pw.Text(
              productName,
              style: pw.TextStyle(fontSize: fontSize),
            ),
          ),

          pw.Expanded(
            flex: 2,
            child: pw.Text(
              _formatNumber(quantity),
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: fontSize),
            ),
          ),

          pw.Expanded(
            flex: 3,
            child: pw.Text(
              _formatMoney(price),
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: fontSize),
            ),
          ),

          pw.Expanded(
            flex: 3,
            child: pw.Text(
              _formatMoney(lineTotal),
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _infoRow(String label, String value, double fontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(
            '$label:',
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(width: 5),

          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(fontSize: fontSize)),
          ),
        ],
      ),
    );
  }

  pw.Widget _totalRow(String label, double value, {required double fontSize}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          _formatMoney(value),
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _divider() {
    return pw.Divider(thickness: 0.7);
  }

  String _formatMoney(double value) {
    return NumberFormat('#,##0.00').format(value);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return NumberFormat('#,##0.##').format(value);
  }

  void approve() async {}
}

enum TicketSize { a5, mm80, mm58 }
