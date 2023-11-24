// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class DosageTimeAndCount {
  final TimeOfDay dosageTimeToBeTaken;
  final int dosageCount;
  DosageTimeAndCount({
    required this.dosageTimeToBeTaken,
    required this.dosageCount,
  });

  DosageTimeAndCount copyWith({
    TimeOfDay? dosageTimeToBeTaken,
    int? dosageCount,
  }) {
    return DosageTimeAndCount(
      dosageTimeToBeTaken: dosageTimeToBeTaken ?? this.dosageTimeToBeTaken,
      dosageCount: dosageCount ?? this.dosageCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dosageTimeToBeTaken': dosageTimeToBeTaken.toString(),
      'dosageCount': dosageCount,
    };
  }

  factory DosageTimeAndCount.fromMap(Map<String, dynamic> map) {
    return DosageTimeAndCount(
      dosageTimeToBeTaken: TimeOfDay.now(),
      dosageCount: map['dosageCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DosageTimeAndCount.fromJson(String source) =>
      DosageTimeAndCount.fromMap(json.decode(source) as Map<String, dynamic>);

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

enum DrugToTakeDailyStatus {
  waitingToBeTaken,
  taken,
  missed,
  skipped;

  bool get isTaken => DrugToTakeDailyStatus.taken == this;
  bool get isSkipped => DrugToTakeDailyStatus.skipped == this;
  bool get isWaitingToBeTaken => DrugToTakeDailyStatus.waitingToBeTaken == this;
}

@immutable
class Drug {
  final String name;
  final String intakeForm;
  final String reasonForDrug;
  final String drugIntakeFrequency;
  final DateTime? drugIntakeIntervalStart;
  final DateTime? drugIntakeIntervalEnd;

  ///
  final Map<int, DrugToTakeDailyStatus> drugToTakeDailyStatusRecord;
  final List<DosageTimeAndCount> doseTimeAndCount;

  ///Can be before or after eating or something related
  final String orderOfDrugIntake;
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

  DrugToTakeDailyStatus get drugToTakeDailyStatusRecordForToday =>
      drugToTakeDailyStatusRecord[DateTime.now().day] ??
      DrugToTakeDailyStatus.waitingToBeTaken;
  static Drug empty = Drug(
    drugIntakeFrequency: '',
    drugIntakeIntervalEnd: DateTime.now(),
    drugIntakeIntervalStart: DateTime.now(),
    doseTimeAndCount: [],
    intakeForm: '',
    name: '',
    orderOfDrugIntake: '',
    reasonForDrug: '',
  );
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

  String toJson() => json.encode(toMap());

  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

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

extension ListOfDrugsEx on List<Drug> {
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
