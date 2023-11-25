// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_mate/application/application.dart';

import 'package:med_mate/landing_page/cubit/background_task_to_check_missed_drugs.dart';
import 'package:med_mate/landing_page/cubit/background_task_to_check_remaining_time.dart';
import 'package:med_mate/landing_page/cubit/landing_page_state.dart';

/// Enum representing different states of the landing page.
enum LandingPageEnum {
  initial,
  calenderSelect;

  /// Returns `true` if the landing page state is 'calenderSelect'.
  bool get isCalenderSelect => this == LandingPageEnum.calenderSelect;
}

/// Cubit managing the state for the landing page.
class LandingPageCubit extends Cubit<LandingPageState> {
  /// Constructor for LandingPageCubit.
  LandingPageCubit(this._drugRepository)
      : super(
          LandingPageState(nextDosageTime: (Duration.zero, Drug.empty, -1)),
        );
  final DrugRepository _drugRepository;
  BackgroundTaskToCheckMissedDrugs? _checkMissedDrugs;
  BackgroundTaskToCheckRemainingTime? _remainingTime;

  /// Saves a new drug that has been added.
  Future<void> saveNewDrugAdded(Drug drug) async {
    final result = await _drugRepository.createDrug(drug);
    final newListOfDrugs = [...state.drugs, result.data!];
    emit(
      state.copyWith(
        drugs: _sortedDrugs(newListOfDrugs),
      ),
    );
    initiateBackgroundTask();
  }

  /// Initiates the background task for checking missed drugs.
  void initiateBackgroundTask() {
    _disposeBackgroundTaskIfNotNull();

    _checkMissedDrugs = BackgroundTaskToCheckMissedDrugs(state.drugs);
    _remainingTime = BackgroundTaskToCheckRemainingTime(state.drugs);

    _checkMissedDrugs?.eventStream.listen((value) {
      changeDrugStatusForToday(
        value.$1,
        DrugToTakeDailyStatus.missed,
        value.$2,
      );
    });
    _remainingTime?.eventStream.listen(_emitUpdatedTime);
  }

  void _emitUpdatedTime((Duration, Drug, int) re) {
    emit(state.copyWith(nextDosageTime: re));
  }

  /// Change the daily status of a specific dose of a drug for the current day.
  ///
  /// Given a [drug], [status], and [index] representing the index of the dose
  /// in the drug's list of dose times, this method updates the drug's status
  /// for the current day. It finds the drug in the state, updates the status
  /// for the specified dose, and emits a new state with the updated drug list.
  ///
  /// Parameters:
  /// - [drug]: The drug whose dose status needs to be updated.
  /// - [status]: The new status to set for the specified dose.
  /// - [index]: The index of the dose in the drug's list of dose times.
  ///
  Future<void> changeDrugStatusForToday(
    Drug drug,
    DrugToTakeDailyStatus status,
    int index,
  ) async {
    // Find the index of the drug in the current state
    final indexOfDrug = state.drugs.indexWhere((element) {
      return element.isEqual(drug);
    });

    // Create a new set of drug taken records for the specified dose
    final newSetOfDrugTakenRecord = {
      ...drug.doseTimeAndCount[index].drugToTakeDailyStatusRecord,
    };

    // Update the status for the current day in the set of drug taken records
    newSetOfDrugTakenRecord[
        DosageTimeAndCount.todayAsMicrosecondsSinceEpochWithOutTime] = status;

    // Create a new list of dose time and count for the drug with the updated record
    final newDoseTimeAndCount = [...drug.doseTimeAndCount];
    newDoseTimeAndCount[index] = newDoseTimeAndCount[index].copyWith(
      drugToTakeDailyStatusRecord: newSetOfDrugTakenRecord,
    );

    // Create a new drug with the updated dose time and count
    final newDrug = drug.copyWith(doseTimeAndCount: newDoseTimeAndCount);

    // Create a new list of drugs with the updated drug
    final newListOfDrug = [...state.drugs];
    newListOfDrug[indexOfDrug] = newDrug;
    await _drugRepository.updateDrug(newDrug, 0);
    // Emit a new state with the updated list of drugs
    emit(
      state.copyWith(
        drugs: newListOfDrug,
      ),
    );

    // Initiate the background task to check for missed drugs
    initiateBackgroundTask();
  }

  /// Shows the calendar for drug selection.
  void showCalenderToSelect() {
    emit(state.copyWith(landingPageEnum: LandingPageEnum.calenderSelect));
    emit(state.copyWith(landingPageEnum: LandingPageEnum.initial));
  }

  /// Sorts the drugs based on the dose time.
  List<Drug> _sortedDrugs(List<Drug> drugs) {
    return drugs.getDrugsForToday;
  }

  /// Disposes the background task if not null.
  void _disposeBackgroundTaskIfNotNull() {
    if (_checkMissedDrugs.isNotNull) {
      _checkMissedDrugs!.dispose();
    }
    if (_remainingTime.isNotNull) {
      _remainingTime!.dispose();
    }
  }

  @override
  Future<void> close() {
    _disposeBackgroundTaskIfNotNull();
    return super.close();
  }
}
