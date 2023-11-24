import 'dart:convert';

import 'package:flutter/material.dart';

@immutable

/// Represents a specific dosage time and count for a drug.
@immutable

/// Represents a specific dosage time and count for a drug.
class DosageTimeAndCount {
  /// Constructs a [DosageTimeAndCount] with the given parameters.
  const DosageTimeAndCount({
    required this.dosageTimeToBeTaken,
    required this.dosageCount,
  });

  /// Creates a [DosageTimeAndCount] from a map.
  factory DosageTimeAndCount.fromMap(Map<String, dynamic> map) {
    return DosageTimeAndCount(
      dosageTimeToBeTaken: TimeOfDay.now(),
      dosageCount: map['dosageCount'] as int,
    );
  }

  /// Creates a [DosageTimeAndCount] from a JSON string.
  factory DosageTimeAndCount.fromJson(String source) =>
      DosageTimeAndCount.fromMap(json.decode(source) as Map<String, dynamic>);

  /// The time at which the drug should be taken.
  final TimeOfDay dosageTimeToBeTaken;

  /// The count or quantity of the drug to be taken at the specified time.
  final int dosageCount;

  /// Creates a copy of this [DosageTimeAndCount] with optional new values.
  DosageTimeAndCount copyWith({
    TimeOfDay? dosageTimeToBeTaken,
    int? dosageCount,
  }) {
    return DosageTimeAndCount(
      dosageTimeToBeTaken: dosageTimeToBeTaken ?? this.dosageTimeToBeTaken,
      dosageCount: dosageCount ?? this.dosageCount,
    );
  }

  /// Converts this [DosageTimeAndCount] to a map for serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dosageTimeToBeTaken': dosageTimeToBeTaken.toString(),
      'dosageCount': dosageCount,
    };
  }

  /// Converts this [DosageTimeAndCount] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'DosageTimeAndCount(dosageTimeToBeTaken: $dosageTimeToBeTaken, dosageCount: $dosageCount)';

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
    this.drugToTakeDailyStatusRecord = const {},
    DateTime? drugIntakeIntervalStart,
    DateTime? drugIntakeIntervalEnd,
  })  : drugIntakeIntervalStart = drugIntakeIntervalStart?.toUtc().toLocal(),
        drugIntakeIntervalEnd = drugIntakeIntervalEnd?.toUtc().toLocal();

  /// Creates a Drug instance from a map.
  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      name: map['name'] as String,
      intakeForm: map['intakeForm'] as String,
      reasonForDrug: map['reasonForDrug'] as String,
      drugIntakeFrequency: map['drugIntakeFrequency'] as String,
      drugIntakeIntervalStart: map['drugIntakeIntervalStart'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['drugIntakeIntervalStart'] as int,
            )
          : null,
      drugIntakeIntervalEnd: map['drugIntakeIntervalEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['drugIntakeIntervalEnd'] as int,
            )
          : null,
      doseTimeAndCount: List<DosageTimeAndCount>.from(
        (map['doseTimeAndCount'] as List<int>).map<DosageTimeAndCount>(
          (x) => DosageTimeAndCount.fromMap(x as Map<String, dynamic>),
        ),
      ),
      orderOfDrugIntake: map['orderOfDrugIntake'] as String,
    );
  }

  /// Creates a Drug instance from a JSON string.
  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

  /// The name of the drug.
  final String name;

  /// The form in which the drug is taken (e.g., tablet, liquid).
  final String intakeForm;

  /// The reason for taking the drug.
  final String reasonForDrug;

  /// The frequency at which the drug should be taken.
  final String drugIntakeFrequency;

  /// The start date and time for the interval during which the drug should be taken.
  final DateTime? drugIntakeIntervalStart;

  /// The end date and time for the interval during which the drug
  ///  should be taken.
  final DateTime? drugIntakeIntervalEnd;

  /// Record of daily drug intake status.
  final Map<int, DrugToTakeDailyStatus> drugToTakeDailyStatusRecord;

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
    Map<int, DrugToTakeDailyStatus>? drugToTakeDailyStatusRecord,
    List<DosageTimeAndCount>? doseTimeAndCount,
    String? orderOfDrugIntake,
  }) {
    return Drug(
      drugToTakeDailyStatusRecord:
          drugToTakeDailyStatusRecord ?? this.drugToTakeDailyStatusRecord,
      name: name ?? this.name,
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

  /// Gets the daily intake status of the drug for today.
  DrugToTakeDailyStatus get drugToTakeDailyStatusRecordForToday =>
      drugToTakeDailyStatusRecord[DateTime.now().day] ??
      DrugToTakeDailyStatus.waitingToBeTaken;

  /// Static instance representing an empty drug.
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

  /// Converts the object to a map for serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'intakeForm': intakeForm,
      'reasonForDrug': reasonForDrug,
      'drugIntakeFrequency': drugIntakeFrequency,
      'drugIntakeIntervalStart':
          drugIntakeIntervalStart?.millisecondsSinceEpoch,
      'drugIntakeIntervalEnd': drugIntakeIntervalEnd?.millisecondsSinceEpoch,
      'doseTimeAndCount': doseTimeAndCount.map((x) => x.toMap()).toList(),
      'orderOfDrugIntake': orderOfDrugIntake,
    };
  }

  /// Converts the object to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Drug(name: $name,drugToTakeDailyStatusRecord: $drugToTakeDailyStatusRecord intakeForm: $intakeForm,'
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
        other.drugToTakeDailyStatusRecordForToday ==
            drugToTakeDailyStatusRecordForToday &&
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
    final drugsForToday = where((drug) =>
        drug.drugIntakeIntervalStart != null &&
        drug.drugIntakeIntervalEnd != null &&
        (todayDate.isAfter(drug.drugIntakeIntervalStart!) ||
            todayDate.isAtSameMomentAs(drug.drugIntakeIntervalStart!)) &&
        (todayDate.isBefore(drug.drugIntakeIntervalEnd!) ||
            todayDate.isAtSameMomentAs(drug.drugIntakeIntervalEnd!)));

    return drugsForToday.toList();
  }
}
