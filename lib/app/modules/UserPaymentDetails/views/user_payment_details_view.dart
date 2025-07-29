import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracora/app/helper/extensions.dart';
import 'package:tracora/app/modules/UserPaymentDetails/controllers/user_payment_details_controller.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:tracora/app/widgets/qr_code.dart';

class UserPaymentDetailsView<T>
    extends GetView<UserPaymentDetailsController<T>> {
  const UserPaymentDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Obx(
        () =>
            controller.moneyTransaction.id == null
                ? Scaffold()
                : Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    title: Text(
                      ((controller.moneyTransaction.dateTime ??
                                  controller.moneyTransaction.createdAt)
                              ?.formatDate() ??
                          ''),
                    ),
                    backgroundColor:
                        Get.find<HomeController>()
                            .dark
                            .colorScheme
                            .primaryContainer,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () =>
                              controller.moneyTransaction.status == 1
                                  ? SizedBox()
                                  : ElevatedButton.icon(
                                    onPressed: () {
                                      controller.approve();
                                    },
                                    label: Text("approve".tr),
                                  ),
                        ),
                      ),
                    ],
                  ),

                  body: Obx(
                    () =>
                        controller.loading
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),

                                      child: Obx(
                                        () => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                gradient: LinearGradient(
                                                  colors:
                                                      controller
                                                                  .moneyTransaction
                                                                  .status ==
                                                              1
                                                          ? [
                                                            Color(0xFF56ab2f),
                                                            Color(0xFFa8e063),
                                                          ] // Vert validé
                                                          : [
                                                            Color(0xFFd31027),
                                                            Color(0xFFea384d),
                                                          ], // Rouge non validé
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // ✅ Header avec utilisateur et statut
                                                  Row(
                                                    children: [
                                                      controller
                                                              .moneyTransaction
                                                              .user
                                                              ?.circleAvatar(
                                                                radius: 20,
                                                              ) ??
                                                          SizedBox(),
                                                      SizedBox(width: 12),
                                                      Text(
                                                        controller
                                                                .moneyTransaction
                                                                .user
                                                                ?.firstName ??
                                                            '',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        controller
                                                                    .moneyTransaction
                                                                    .status ==
                                                                1
                                                            ? Icons.check_circle
                                                            : Icons
                                                                .warning_amber_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        controller
                                                                    .moneyTransaction
                                                                    .status ==
                                                                1
                                                            ? 'Validée'
                                                            : 'Non validée',
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16),

                                                  // 💸 Infos de paiement
                                                  Row(
                                                    children: [
                                                      // Icon for payments
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                            ),
                                                        child: Icon(
                                                          Icons.payment,
                                                          color: Colors.white,
                                                          size: 28,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),

                                                      // Total payment value
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // Total Payment label
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Total versé',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                          0.85,
                                                                        ),
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${controller.moneyTransaction.amount.formatNumber()} DA',
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Ancien crédit',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                          0.85,
                                                                        ),
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${controller.moneyTransaction.credit.formatNumber()} DA',
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
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
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.print_outlined),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor:
                                              Get.find<HomeController>()
                                                  .dark
                                                  .colorScheme
                                                  .primaryContainer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.print,
                                        label: Text('print_ticket'.tr),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.edit),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.edit,
                                        label: Text('edit_sale'.tr),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.delete_outline),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: controller.delete,
                                        label: Text('delete_sale'.tr),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                  ),
                ),
      ),
    );
  }
}
