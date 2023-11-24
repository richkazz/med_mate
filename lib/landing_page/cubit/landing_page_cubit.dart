import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  LandingPageCubit() : super(const LandingPageState());
  BackgroundTaskToCheckMissedDrugs? _checkMissedDrugs;

  /// Saves a new drug that has been added.
  void saveNewDrugAdded(Drug drug) {
    final newListOfDrugs = [...state.drugs, drug];
    emit(state.copyWith(drugs: _sortedDrugs(newListOfDrugs)));
    initiateBackgroundTask();
  }

  /// Initiates the background task for checking missed drugs.
  void initiateBackgroundTask() {
    _disposeBackgroundTaskIfNotNull();

    _checkMissedDrugs = BackgroundTaskToCheckMissedDrugs(state.drugs);

    _checkMissedDrugs?.eventStream.listen((drug) {
      changeDrugStatusForToday(drug, DrugToTakeDailyStatus.missed);
    });
  }

  /// Changes the daily status of a drug.
  void changeDrugStatusForToday(Drug drug, DrugToTakeDailyStatus status) {
    final indexOfDrug = state.drugs.indexWhere(
      (element) {
        return element.isEqual(drug);
      },
    );
    final newSetOfDrugTakenRecord = {...drug.drugToTakeDailyStatusRecord};
    newSetOfDrugTakenRecord[DateTime.now().day] = status;
    final newDrug =
        drug.copyWith(drugToTakeDailyStatusRecord: newSetOfDrugTakenRecord);
    final newListOfDrug = [...state.drugs];
    newListOfDrug[indexOfDrug] = newDrug;
    emit(state.copyWith(drugs: newListOfDrug));
    initiateBackgroundTask();
  }

  /// Shows the calendar for drug selection.
  void showCalenderToSelect() {
    emit(state.copyWith(landingPageEnum: LandingPageEnum.calenderSelect));
    emit(state.copyWith(landingPageEnum: LandingPageEnum.initial));
  }

  /// Sorts the drugs based on the dose time.
  List<Drug> _sortedDrugs(List<Drug> drugs) {
    final newDrug = <Drug>[];
    for (final element in drugs) {
      for (final drg in element.doseTimeAndCount) {
        newDrug.add(element.copyWith(doseTimeAndCount: [drg]));
      }
    }
    return newDrug.getDrugsForToday;
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
  final StreamController<Drug> _eventStreamController =
      StreamController<Drug>();
  Timer? _timer;

  /// Disposes the background task.
  void dispose() {
    _timer?.cancel();
    _eventStreamController.close();
  }

  /// Stream of drugs events.
  Stream<Drug> get eventStream => _eventStreamController.stream;

  /// Checks if the time for taking a drug has passed.
  void _checkIfDrugTimeHasPassed(_) {
    final isAnyWaitingToBeTaken = drugs.any(
      (element) =>
          element.drugToTakeDailyStatusRecordForToday.isWaitingToBeTaken,
    );
    if (!isAnyWaitingToBeTaken) {
      dispose();
    }
    final now = DateTime.now();
    for (final drug in drugs) {
      if (drug.doseTimeAndCount.first.dosageTimeToBeTaken.combineDateAndTime
              .isBefore(now) &&
          drug.drugToTakeDailyStatusRecordForToday.isWaitingToBeTaken) {
        _eventStreamController.add(drug);
      }
    }
  }
}
