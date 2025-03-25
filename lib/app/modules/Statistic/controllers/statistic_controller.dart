import 'package:get/get.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/statistic_model.dart';
import 'package:tracora/app/data/repositories/statistics_repository.dart';

class StatisticController extends GetxController {
  final _statistics = StatisticModel().obs;
  StatisticModel get statistics => this._statistics.value;
  set statistics(StatisticModel value) => this._statistics.value = value;

  final _from = 0.obs;
  int get from => this._from.value;
  set from(int value) => this._from.value = value;

  final _to = DateTime.now().millisecondsSinceEpoch.obs;
  int get to => this._to.value;
  set to(int value) => this._to.value = value;

  @override
  void onInit() {
    loadStatistics();
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

  loadStatistics() async {
    try {
      statistics = await StatisticsRepository().getStatistic(
        from: from,
        to: to,
      );
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
