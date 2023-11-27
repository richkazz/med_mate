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
  calenderSelect,
  drugListChanged;

  /// Returns `true` if the landing page state is 'calenderSelect'.
  bool get isCalenderSelect => this == LandingPageEnum.calenderSelect;
}

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc(this._drugRepository)
      : super(
          LandingPageState(nextDosageTime: (Duration.zero, Drug.empty, -1)),
        ) {
    on<LandingPageEvent>((event, emit) {});
    on<GetDrugsByUserId>(
      (event, emit) async {
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.inProgress,
          ),
        );
        final result = await _drugRepository.getDrugsByUserId(event.userId);
        if (!result.isSuccessful) {
          emit(
            state.copyWith(
              submissionStateEnum: FormSubmissionStateEnum.serverFailure,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.successful,
          ),
        );
        drugs = _sortedDrugs(result.data!);
        emit(
          state.copyWith(),
        );
        initiateBackgroundTask();
      },
    );
    on<UpdatedTimeFromBackground>(
      (event, emit) async {
        emit(state.copyWith(nextDosageTime: event.value));
      },
    );
    on<SaveNewDrugAdded>(
      (event, emit) async {
        final newListOfDrugs = [...drugs, event.drug];
        drugs = newListOfDrugs;
        emit(
          state.copyWith(
            landingPageEnum: LandingPageEnum.drugListChanged,
          ),
        );
        initiateBackgroundTask();
        emit(
          state.copyWith(
            landingPageEnum: LandingPageEnum.initial,
          ),
        );
      },
    );
    on<ChangeDrugStatusForToday>(
      (event, emit) async {
        final (
          drug,
          status,
          index,
        ) = event.value;
        // Find the index of the drug in the current state
        final indexOfDrug = drugs.indexWhere((element) {
          return element.isEqual(drug);
        });

        // Create a new set of drug taken records for the specified dose
        final newSetOfDrugTakenRecord = {
          ...drug.doseTimeAndCount[index].drugToTakeDailyStatusRecord,
        };

        // Update the status for the current day in the set of drug taken records
        newSetOfDrugTakenRecord[DosageTimeAndCount
            .todayAsMicrosecondsSinceEpochWithOutTime] = status;

        // Create a new list of dose time and count for the drug with the updated record
        final newDoseTimeAndCount = [...drug.doseTimeAndCount];
        newDoseTimeAndCount[index] = newDoseTimeAndCount[index].copyWith(
          drugToTakeDailyStatusRecord: newSetOfDrugTakenRecord,
        );

        // Create a new drug with the updated dose time and count
        final newDrug = drug.copyWith(doseTimeAndCount: newDoseTimeAndCount);

        // Create a new list of drugs with the updated drug
        final newListOfDrug = [...drugs];
        newListOfDrug[indexOfDrug] = newDrug;
        await _drugRepository.updateDrug(newDrug, 0);
        // Emit a new state with the updated list of drugs
        emit(
          state.copyWith(
            landingPageEnum: LandingPageEnum.drugListChanged,
          ),
        );

        // Initiate the background task to check for missed drugs
        initiateBackgroundTask();
        emit(
          state.copyWith(
            landingPageEnum: LandingPageEnum.initial,
          ),
        );
      },
    );
  }

  final DrugRepository _drugRepository;
  BackgroundTaskToCheckMissedDrugs? _checkMissedDrugs;
  BackgroundTaskToCheckRemainingTime? _remainingTime;
  List<Drug> drugs = [];

  /// Initiates the background task for checking missed drugs.
  void initiateBackgroundTask() {
    _disposeBackgroundTaskIfNotNull();

    _checkMissedDrugs = BackgroundTaskToCheckMissedDrugs(drugs);
    _remainingTime = BackgroundTaskToCheckRemainingTime(drugs);

    _checkMissedDrugs?.eventStream.listen((value) {
      add(
        ChangeDrugStatusForToday(
          value: (
            value.$1,
            DrugToTakeDailyStatus.missed,
            value.$2,
          ),
        ),
      );
    });
    _remainingTime?.eventStream.listen(
      (event) {
        add(UpdatedTimeFromBackground(value: event));
      },
    );
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

abstract class LandingPageEvent {}

class GetDrugsByUserId extends LandingPageEvent {
  GetDrugsByUserId({required this.userId});

  final int userId;
}

class SaveNewDrugAdded extends LandingPageEvent {
  SaveNewDrugAdded({required this.drug});

  final Drug drug;
}

class UpdatedTimeFromBackground extends LandingPageEvent {
  UpdatedTimeFromBackground({required this.value});

  final (Duration, Drug, int) value;
}

class ChangeDrugStatusForToday extends LandingPageEvent {
  ChangeDrugStatusForToday({required this.value});

  final (Drug, DrugToTakeDailyStatus, int) value;
}
