// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:math';
import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';

/// Background task for checking missed drugs.
class BackgroundTaskToCheckRemainingTime {
  // Constructor initializes the background task and triggers
  // the first execution.
  BackgroundTaskToCheckRemainingTime(this.drugs) {
    _timer = Timer.periodic(const Duration(minutes: 3), _task);
    //_task(drugs);
  }

  final List<Drug> drugs;
  final StreamController<(Duration, Drug, int)> _eventStreamController =
      StreamController<(Duration, Drug, int)>();
  Timer? _timer;

  /// Disposes the background task.
  void dispose() {
    _timer?.cancel();
    _eventStreamController.close();
  }

  /// Stream of drugs events.
  Stream<(Duration, Drug, int)> get eventStream =>
      _eventStreamController.stream;

  // Task executed periodically to find and report the next dosage time.
  void _task(_) {
    final result = findNextDosageTime(drugs);
    _eventStreamController.add(result);
    if (result.$3 == -1) {
      dispose();
    }
  }

  // Finds the next dosage time among the given list of drugs.
  (Duration, Drug, int) findNextDosageTime(List<Drug> drugs) {
    var timeClosestToNow = DateTime(4000).microsecondsSinceEpoch;
    var resultDrug = (Drug.empty, -1);
    final now = DateTime.now();

    for (final drug in drugs) {
      for (var i = 0; i < drug.doseTimeAndCount.length; i++) {
        final dosageTimeToBeTakenAsDateTime =
            drug.doseTimeAndCount[i].dosageTimeToBeTaken.combineDateAndTime;
        if (dosageTimeToBeTakenAsDateTime.isAfter(now)) {
          timeClosestToNow = min(
            timeClosestToNow,
            dosageTimeToBeTakenAsDateTime.microsecondsSinceEpoch,
          );
          if (timeClosestToNow ==
              dosageTimeToBeTakenAsDateTime.microsecondsSinceEpoch) {
            resultDrug = (drug, i);
          }
        }
      }
    }

    final remainingTime = _calculateRemainingTime(
      DateTime.fromMicrosecondsSinceEpoch(timeClosestToNow),
    );
    return (remainingTime, resultDrug.$1, resultDrug.$2);
  }

  // Calculates the remaining time until the target date and time.
  Duration _calculateRemainingTime(DateTime targetDateTime) {
    // Get the current date and time
    final now = DateTime.now();

    // Calculate the time difference between the target date and
    // time and the current time
    final timeDifference = targetDateTime.difference(now);

    // Ensure the time difference is positive (in the future)
    if (timeDifference.isNegative) {
      return Duration.zero;
    }

    // Handle different time units based on the magnitude of the time difference
    if (timeDifference.inHours < 1) {
      return Duration(minutes: timeDifference.inMinutes);
    } else if (timeDifference.inDays < 1) {
      return Duration(hours: timeDifference.inHours);
    } else {
      return Duration(days: timeDifference.inDays);
    }
  }
}
