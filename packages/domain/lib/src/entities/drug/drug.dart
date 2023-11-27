import 'package:flutter/material.dart';

///A List of to test
final globalTestDrugList = <Drug>[];

/// Represents a specific dosage time and count for a drug.
@immutable
class DosageTimeAndCount {
  /// Constructs a [DosageTimeAndCount] with the given parameters.
  const DosageTimeAndCount({
    required this.dosageTimeToBeTaken,
    required this.dosageCount,
    this.id = -1,
    this.drugToTakeDailyStatusRecord = const {},
  });

  /// Gets the daily intake status of the drug for today.
  DrugToTakeDailyStatus get drugToTakeDailyStatusRecordForToday =>
      drugToTakeDailyStatusRecord[todayAsMicrosecondsSinceEpochWithOutTime] ??
      DrugToTakeDailyStatus.waitingToBeTaken;

  ///Today data as microsecondsSinceEpoch without the time factor
  static int get todayAsMicrosecondsSinceEpochWithOutTime {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day)
        .toUtc()
        .microsecondsSinceEpoch;
  }

  ///The id for this instance and the value should only be updated from the
  ///web db
  final int id;

  /// The time at which the drug should be taken.
  final TimeOfDay dosageTimeToBeTaken;

  /// The count or quantity of the drug to be taken at the specified time.
  final int dosageCount;

  /// Record of daily drug intake status.
  final Map<int, DrugToTakeDailyStatus> drugToTakeDailyStatusRecord;

  /// Creates a copy of this [DosageTimeAndCount] with optional new values.
  DosageTimeAndCount copyWith({
    TimeOfDay? dosageTimeToBeTaken,
    int? dosageCount,
    int? id,
    Map<int, DrugToTakeDailyStatus>? drugToTakeDailyStatusRecord,
  }) {
    return DosageTimeAndCount(
      dosageTimeToBeTaken: dosageTimeToBeTaken ?? this.dosageTimeToBeTaken,
      dosageCount: dosageCount ?? this.dosageCount,
      id: id ?? this.id,
      drugToTakeDailyStatusRecord:
          drugToTakeDailyStatusRecord ?? this.drugToTakeDailyStatusRecord,
    );
  }

  @override
  String toString() =>
      'DosageTimeAndCount(dosageTimeToBeTaken: $dosageTimeToBeTaken,'
      ' dosageCount: $dosageCount)';

  @override
  bool operator ==(covariant DosageTimeAndCount other) {
    if (identical(this, other)) return true;

    return other.dosageTimeToBeTaken == dosageTimeToBeTaken &&
        other.dosageCount == dosageCount;
  }

  @override
  int get hashCode => dosageTimeToBeTaken.hashCode ^ dosageCount.hashCode;
}

/// Enum representing the daily status of drug intake.
enum DrugToTakeDailyStatus {
  /// The drug is waiting to be taken.
  waitingToBeTaken,

  /// The drug has been taken.
  taken,

  /// The drug was missed.
  missed,

  /// The drug was skipped.
  skipped;

  /// Checks if the drug has been taken.
  bool get isTaken => DrugToTakeDailyStatus.taken == this;

  /// Checks if the drug was skipped.
  bool get isSkipped => DrugToTakeDailyStatus.skipped == this;

  /// Checks if the drug is waiting to be taken.
  bool get isWaitingToBeTaken => DrugToTakeDailyStatus.waitingToBeTaken == this;
}

/// Represents information about a drug.
@immutable
class Drug {
  /// Constructor for Drug.
  Drug({
    required this.name,
    required this.intakeForm,
    required this.reasonForDrug,
    required this.drugIntakeFrequency,
    required this.doseTimeAndCount,
    required this.orderOfDrugIntake,
    this.scheduleId = -1,
    DateTime? drugIntakeIntervalStart,
    DateTime? drugIntakeIntervalEnd,
  })  : drugIntakeIntervalStart = drugIntakeIntervalStart?.toUtc().toLocal(),
        drugIntakeIntervalEnd = drugIntakeIntervalEnd?.toUtc().toLocal();

  /// The name of the drug.
  final String name;

  ///the schedule id from db
  final int scheduleId;

  /// The form in which the drug is taken (e.g., tablet, liquid).
  final String intakeForm;

  /// The reason for taking the drug.
  final String reasonForDrug;

  /// The frequency at which the drug should be taken.
  final String drugIntakeFrequency;

  /// The start date and time for the interval during which the
  /// drug should be taken.
  final DateTime? drugIntakeIntervalStart;

  /// The end date and time for the interval during which the drug
  ///  should be taken.
  final DateTime? drugIntakeIntervalEnd;

  /// List of dosage times and counts for the drug.
  final List<DosageTimeAndCount> doseTimeAndCount;

  /// Order of drug intake.
  final String orderOfDrugIntake;

  /// Creates a copy of the instance with optional changes.
  Drug copyWith({
    String? name,
    String? intakeForm,
    String? reasonForDrug,
    String? drugIntakeFrequency,
    DateTime? drugIntakeIntervalStart,
    DateTime? drugIntakeIntervalEnd,
    List<DosageTimeAndCount>? doseTimeAndCount,
    String? orderOfDrugIntake,
    int? scheduleId,
  }) {
    return Drug(
      name: name ?? this.name,
      scheduleId: scheduleId ?? this.scheduleId,
      intakeForm: intakeForm ?? this.intakeForm,
      reasonForDrug: reasonForDrug ?? this.reasonForDrug,
      drugIntakeFrequency: drugIntakeFrequency ?? this.drugIntakeFrequency,
      drugIntakeIntervalStart:
          drugIntakeIntervalStart ?? this.drugIntakeIntervalStart,
      drugIntakeIntervalEnd:
          drugIntakeIntervalEnd ?? this.drugIntakeIntervalEnd,
      doseTimeAndCount: doseTimeAndCount ?? this.doseTimeAndCount,
      orderOfDrugIntake: orderOfDrugIntake ?? this.orderOfDrugIntake,
    );
  }

  ///An empty drug
  static Drug empty = Drug(
    drugIntakeFrequency: '',
    drugIntakeIntervalEnd: DateTime.now(),
    drugIntakeIntervalStart: DateTime.now(),
    doseTimeAndCount: const [],
    intakeForm: '',
    name: '',
    orderOfDrugIntake: '',
    reasonForDrug: '',
  );

  @override
  String toString() {
    return 'Drug(name: $name, intakeForm: $intakeForm,'
        ' reasonForDrug: $reasonForDrug,'
        ' drugIntakeFrequency: $drugIntakeFrequency,'
        ' drugIntakeIntervalStart: $drugIntakeIntervalStart,'
        ' drugIntakeIntervalEnd: $drugIntakeIntervalEnd,'
        ' doseTimeAndCount: $doseTimeAndCount, '
        'orderOfDrugIntake: $orderOfDrugIntake)';
  }

  /// Checks if two drugs are equal.
  bool isEqual(Drug other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.intakeForm == intakeForm &&
        other.reasonForDrug == reasonForDrug &&
        other.doseTimeAndCount.firstOrNull?.dosageTimeToBeTaken ==
            doseTimeAndCount.firstOrNull?.dosageTimeToBeTaken &&
        other.drugIntakeFrequency == drugIntakeFrequency &&
        other.drugIntakeIntervalStart == drugIntakeIntervalStart &&
        other.drugIntakeIntervalEnd == drugIntakeIntervalEnd &&
        other.orderOfDrugIntake == orderOfDrugIntake;
  }
}

/// Extension on List<Drug> providing additional functionality.
extension ListOfDrugsEx on List<Drug> {
  /// Filters drugs based on the current date.
  List<Drug> get getDrugsForToday {
    // Get today's date without considering time
    final today = DateTime.now().toUtc().toLocal();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Filter drugs based on today's date
    final drugsForToday = where(
      (drug) =>
          drug.drugIntakeIntervalStart != null &&
          drug.drugIntakeIntervalEnd != null &&
          (todayDate.isAfter(drug.drugIntakeIntervalStart!) ||
              todayDate.isAtSameMomentAs(drug.drugIntakeIntervalStart!)) &&
          (todayDate.isBefore(drug.drugIntakeIntervalEnd!) ||
              todayDate.isAtSameMomentAs(drug.drugIntakeIntervalEnd!)),
    );

    return drugsForToday.toList();
  }
}
