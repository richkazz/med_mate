// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

class SaveDrugCubit extends Cubit<SaveDrugState> {
  final DrugRepository _drugRepository;
  final NotificationService _notificationService;
  SaveDrugCubit(
    this._drugRepository, {
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(SaveDrugState(drug: Drug.empty));
  Future<void> saveNewDrugAdded(Drug drug, int userId) async {
    try {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.inProgress,
        ),
      );
      final result = await _drugRepository.createDrug(drug, userId);
      if (result.isSuccessful) {
        await scheduleNotification(result.data!);
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.successful,
            drug: result.data,
          ),
        );

        return;
      }
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: result.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: 'Error scheduling drugs',
        ),
      );
      return;
    }
  }

  Future<void> scheduleNotification(Drug drug) async {
    await schedule(drug,
        startDate: drug.drugIntakeIntervalStart!,
        endDate: drug.drugIntakeIntervalEnd!);
  }

  /// Populates the report data map based on drug data and date range.
  Future<void> schedule(
    Drug drug, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Ensure the start date is before the end date
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date cannot be after end date');
    }
    final newEndDate = endDate.add(const Duration(days: 1));
    // Iterate through each day from the start date to the end date
    var currentDate = startDate;
    while (currentDate.isBefore(newEndDate)) {
      for (final element in drug.doseTimeAndCount) {
        final scheduledTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          element.dosageTimeToBeTaken.hour,
          element.dosageTimeToBeTaken.minute,
        );
        await _notificationService.scheduleNotificationWithActions(
          drug,
          0,
          element.id,
          scheduledTime,
        );
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }
}

class SaveDrugState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  final Drug drug;
  SaveDrugState({
    required this.drug,
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

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
