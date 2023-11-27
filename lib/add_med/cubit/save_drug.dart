// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

/// Handles the state and logic for saving a new drug.
class SaveDrugCubit extends Cubit<SaveDrugState> {
  final DrugRepository _drugRepository;
  final NotificationService _notificationService;

  SaveDrugCubit(
    this._drugRepository, {
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(SaveDrugState(drug: Drug.empty));

  /// Saves a newly added drug and schedules notifications.
  Future<void> saveNewDrugAdded(Drug drug, int userId) async {
    try {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.inProgress,
        ),
      );

      // Create the drug using the repository
      final result = await _drugRepository.createDrug(drug, userId);

      if (result.isSuccessful) {
        // Schedule notifications for the drug
        await scheduleNotification(result.data!);

        // Update the state with the successful result
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.successful,
            drug: result.data,
          ),
        );
        return;
      }

      // Handle server failure
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: result.errorMessage,
        ),
      );
    } catch (e) {
      // Handle general failure
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: 'Error scheduling drugs',
        ),
      );
    }
  }

  /// Schedules notifications for the drug based on its dosage times
  ///  and date range.
  Future<void> scheduleNotification(Drug drug) async {
    await schedule(
      drug,
      startDate: drug.drugIntakeIntervalStart!,
      endDate: drug.drugIntakeIntervalEnd!,
    );
  }

  /// Schedules notifications for each dosage time within
  ///  the specified date range.
  Future<void> schedule(
    Drug drug, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Ensure the start date is before the end date
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date cannot be after end date');
    }

    // Add one day to the end date for correct iteration
    final newEndDate = endDate.add(const Duration(days: 1));

    // Iterate through each day from the start date to the end date
    var currentDate = startDate;
    while (currentDate.isBefore(newEndDate)) {
      for (final element in drug.doseTimeAndCount) {
        // Create a scheduled time based on the drug's dosage time
        final scheduledTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          element.dosageTimeToBeTaken.hour,
          element.dosageTimeToBeTaken.minute,
        );

        // Schedule the notification for the drug
        await _notificationService.scheduleNotificationWithActions(
          drug,
          0,
          element.id,
          scheduledTime,
        );

        // Move to the next day
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }
}

/// Represents the state for the SaveDrugCubit.
class SaveDrugState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  final Drug drug;

  SaveDrugState({
    required this.drug,
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  /// Creates a new instance of SaveDrugState with optional changes.
  SaveDrugState copyWith({
    FormSubmissionStateEnum? submissionStateEnum,
    String? errorMessage,
    Drug? drug,
  }) {
    return SaveDrugState(
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
      drug: drug ?? this.drug,
    );
  }
}
