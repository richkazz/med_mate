import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

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
  LandingPageCubit(this._drugRepository) : super(const LandingPageState());
  final DrugRepository _drugRepository;
  BackgroundTaskToCheckMissedDrugs? _checkMissedDrugs;

  /// Saves a new drug that has been added.
  Future<void> saveNewDrugAdded(Drug drug) async {
    final result = await _drugRepository.createDrug(drug);
    final newListOfDrugs = [...state.drugs, result.data!];
    emit(state.copyWith(drugs: _sortedDrugs(newListOfDrugs)));
    initiateBackgroundTask();
  }

  /// Initiates the background task for checking missed drugs.
  void initiateBackgroundTask() {
    _disposeBackgroundTaskIfNotNull();

    _checkMissedDrugs = BackgroundTaskToCheckMissedDrugs(state.drugs);

    _checkMissedDrugs?.eventStream.listen((value) {
      changeDrugStatusForToday(
        value.$1,
        DrugToTakeDailyStatus.missed,
        value.$2,
      );
    });
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
    await _drugRepository.updateDrug(drug, 0);
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

    // Emit a new state with the updated list of drugs
    emit(state.copyWith(drugs: newListOfDrug));

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
  }

  @override
  Future<void> close() {
    _disposeBackgroundTaskIfNotNull();
    return super.close();
  }
}

/// Represents the state of the landing page.
class LandingPageState extends Equatable {
  const LandingPageState({
    this.drugs = const [],
    this.landingPageEnum = LandingPageEnum.initial,
  });
  final List<Drug> drugs;
  final LandingPageEnum landingPageEnum;

  /// Creates a copy of the state with optional new values.
  LandingPageState copyWith({
    List<Drug>? drugs,
    LandingPageEnum? landingPageEnum,
  }) {
    return LandingPageState(
      drugs: drugs ?? this.drugs,
      landingPageEnum: landingPageEnum ?? this.landingPageEnum,
    );
  }

  @override
  List<Object?> get props => [...drugs, landingPageEnum, drugs.length];
}

/// Background task for checking missed drugs.
class BackgroundTaskToCheckMissedDrugs {
  BackgroundTaskToCheckMissedDrugs(this.drugs) {
    _timer =
        Timer.periodic(const Duration(minutes: 3), _checkIfDrugTimeHasPassed);
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
