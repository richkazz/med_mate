import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_mate/application/application.dart';

/// Enum representing different states of the report screen.
enum ReportEnum {
  initial,
  reportForThisMonth,
  reportForLastMonth,
  reportForChooseASpecificTime,
}

/// Data structure representing a report entry.
class ReportData {
  ReportData({
    required this.date,
    required this.numberOfDrugTaken,
    required this.numberOfDrugWaitingToBeTaken,
    required this.numberOfDrugSkipped,
    required this.numberOfDrugMissed,
  });

  final DateTime date;
  final int numberOfDrugTaken;
  final int numberOfDrugSkipped;
  final int numberOfDrugMissed;
  final int numberOfDrugWaitingToBeTaken;
}

/// Extension on ReportEnum to simplify state checking.
extension ReportEnumExtension on ReportEnum {
  bool get isInitial => this == ReportEnum.initial;
  bool get isReportForThisMonth => this == ReportEnum.reportForThisMonth;
  bool get isReportForLastMonth => this == ReportEnum.reportForLastMonth;
  bool get isReportForChooseASpecificTime =>
      this == ReportEnum.reportForChooseASpecificTime;
}

/// Cubit responsible for managing the state of the report screen.
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._drugRepository) : super(const ReportState());
  final DrugRepository _drugRepository;
  int _userId = -1;
  void onOpen(int userId) {
    _userId = userId;
  }

  /// Fetches and displays the report for the current month.
  Future<void> showReportThisMonth() async {
    final result = await _drugRepository.getDrugsByUserId(_userId);
    if (!result.isSuccessful) {
      //todo: What happens when an error occurs
      emit(state.copyWith());
    }

    final monthDate = DateTime.now();
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month);

    // Calculate the last day of the month
    final lastDayOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0)
        .add(const Duration(days: 1));
    emit(
      state.copyWith(
        reportEnum: ReportEnum.reportForThisMonth,
        reportDataList: _generateReport(
          result.data!,
          startDate: firstDayOfMonth,
          endDate: lastDayOfMonth,
        ),
      ),
    );
  }

  /// Fetches and displays the report for the last month.
  Future<void> showReportLastMonth() async {
    final result = await _drugRepository.getDrugsByUserId(_userId);
    if (!result.isSuccessful) {
      //todo: What happens when an error occurs
      emit(state.copyWith());
    }

    final monthDate = _getPreviousMonth(DateTime.now());
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month);

    // Calculate the last day of the month
    final lastDayOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0)
        .add(const Duration(days: 1));
    emit(
      state.copyWith(
        reportEnum: ReportEnum.reportForThisMonth,
        reportDataList: _generateReport(
          result.data!,
          startDate: firstDayOfMonth,
          endDate: lastDayOfMonth,
        ),
      ),
    );
  }

  /// Fetches and displays the report for a custom date range.
  Future<void> showReportCustomRange(DateTimeRange dateTimeRange) async {
    final result = await _drugRepository.getDrugsByUserId(_userId);
    if (!result.isSuccessful) {
      //todo: What happens when an error occurs
      emit(state.copyWith());
    }

    emit(
      state.copyWith(
        reportEnum: ReportEnum.reportForThisMonth,
        reportDataList: _generateReport(
          result.data!,
          startDate: dateTimeRange.start,
          endDate: dateTimeRange.end.add(const Duration(days: 1)),
        ),
      ),
    );
  }

  /// Retrieves the date of the previous month.
  DateTime _getPreviousMonth(DateTime currentDate) {
    // Handle the special case of December, where the previous
    // month is November of the previous year
    if (currentDate.month == 12) {
      return DateTime(currentDate.year - 1, 11);
    }

    // For other months, simply subtract one from the month value
    return DateTime(
      currentDate.year,
      currentDate.month - 1,
    );
  }

  /// Generates a report based on the given drugs and date range.
  List<ReportData> _generateReport(
    List<Drug> drugs, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final reportDataMap = <int, ReportData>{};

    for (final drug in drugs) {
      populateTheReportDataMap(
        drug,
        reportDataMap,
        startDate: startDate,
        endDate: endDate,
      );
    }
    final result = reportDataMap.values.toList()
      ..sort(
        (a, b) => a.date.microsecondsSinceEpoch
            .compareTo(b.date.microsecondsSinceEpoch),
      );
    return result;
  }

  /// Populates the report data map based on drug data and date range.
  void populateTheReportDataMap(
    Drug drug,
    Map<int, ReportData> reportDataMap, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Ensure the start date is before the end date
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date cannot be after end date');
    }

    // Iterate through each day from the start date to the end date
    var currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      final cur = currentDate.microsecondsSinceEpoch;
      for (final element in drug.doseTimeAndCount) {
        if (element.drugToTakeDailyStatusRecord[cur].isNull) {
          if (reportDataMap[cur].isNotNull) {
            continue;
          }
          reportDataMap[cur] = ReportData(
            date: currentDate,
            numberOfDrugTaken: 0,
            numberOfDrugSkipped: 0,
            numberOfDrugMissed: 0,
            numberOfDrugWaitingToBeTaken: 0,
          );
          continue;
        }
        final (taken, missed, skipped, waitingToBeTaken) =
            switch (element.drugToTakeDailyStatusRecord[cur]!) {
          DrugToTakeDailyStatus.waitingToBeTaken => (0, 0, 0, 1),
          DrugToTakeDailyStatus.taken => (1, 0, 0, 0),
          DrugToTakeDailyStatus.missed => (0, 1, 0, 0),
          DrugToTakeDailyStatus.skipped => (0, 0, 1, 0),
        };
        if (reportDataMap.containsKey(cur)) {
          final reportData = reportDataMap[cur]!;

          reportDataMap[cur] = ReportData(
            date: currentDate,
            numberOfDrugTaken: reportData.numberOfDrugTaken + taken,
            numberOfDrugSkipped: reportData.numberOfDrugSkipped + skipped,
            numberOfDrugMissed: reportData.numberOfDrugMissed + missed,
            numberOfDrugWaitingToBeTaken:
                reportData.numberOfDrugWaitingToBeTaken + waitingToBeTaken,
          );
          continue;
        }
        reportDataMap[cur] = ReportData(
          date: currentDate,
          numberOfDrugTaken: taken,
          numberOfDrugSkipped: skipped,
          numberOfDrugMissed: missed,
          numberOfDrugWaitingToBeTaken: waitingToBeTaken,
        );
      }
      // Move to the next day
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }
}

/// Represents the state of the report screen.
class ReportState extends Equatable {
  const ReportState({
    this.reportEnum = ReportEnum.initial,
    this.reportDataList = const [],
  });
  final ReportEnum reportEnum;
  final List<ReportData> reportDataList;
  @override
  List<Object> get props => [reportEnum, reportDataList];

  ReportState copyWith({
    ReportEnum? reportEnum,
    List<ReportData>? reportDataList,
  }) {
    return ReportState(
      reportEnum: reportEnum ?? this.reportEnum,
      reportDataList: reportDataList ?? this.reportDataList,
    );
  }
}
