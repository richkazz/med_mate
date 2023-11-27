// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';

/// Background task for checking missed drugs.
class BackgroundTaskToCheckMissedDrugs {
  BackgroundTaskToCheckMissedDrugs(this.drugs) {
    _timer =
        Timer.periodic(const Duration(minutes: 3), _checkIfDrugTimeHasPassed);
    _checkIfDrugTimeHasPassed(drugs);
  }

  final List<Drug> drugs;
  final StreamController<(Drug, int)> _eventStreamController =
      StreamController<(Drug, int)>();
  Timer? _timer;

  /// Disposes the background task.
  void dispose() {
    _timer?.cancel();
    _eventStreamController.close();
  }

  /// Stream of drugs events.
  Stream<(Drug, int)> get eventStream => _eventStreamController.stream;

  /// Checks if the time for taking a drug has passed.
  void _checkIfDrugTimeHasPassed(_) {
    final isAnyWaitingToBeTaken = drugs.any(
      (element) => element.doseTimeAndCount.any(
        (dosageTimeAndCount) => dosageTimeAndCount
            .drugToTakeDailyStatusRecordForToday.isWaitingToBeTaken,
      ),
    );
    if (!isAnyWaitingToBeTaken) {
      dispose();
    }
    final now = DateTime.now();
    for (final drug in drugs) {
      for (var i = 0; i < drug.doseTimeAndCount.length; i++) {
        if (drug.doseTimeAndCount[i].dosageTimeToBeTaken.combineDateAndTime
                .isBefore(now) &&
            drug.doseTimeAndCount[i].drugToTakeDailyStatusRecordForToday
                .isWaitingToBeTaken) {
          _eventStreamController.add((drug, i));
        }
      }
    }
  }
}
