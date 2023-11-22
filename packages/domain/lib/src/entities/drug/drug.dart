// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
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

@immutable
class Drug {
  final String name;
  final String intakeForm;
  final String reasonForDrug;
  final String drugIntakeFrequency;
  final DateTime? drugIntakeIntervalStart;
  final DateTime? drugIntakeIntervalEnd;
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
    this.drugIntakeIntervalStart,
    this.drugIntakeIntervalEnd,
  });

  Drug copyWith({
    String? name,
    String? intakeForm,
    String? reasonForDrug,
    String? drugIntakeFrequency,
    DateTime? drugIntakeIntervalStart,
    DateTime? drugIntakeIntervalEnd,
    List<DosageTimeAndCount>? doseTimeAndCount,
    String? orderOfDrugIntake,
  }) {
    return Drug(
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
              map['drugIntakeIntervalStart'] as int)
          : null,
      drugIntakeIntervalEnd: map['drugIntakeIntervalEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['drugIntakeIntervalEnd'] as int)
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
    return 'Drug(name: $name, intakeForm: $intakeForm, reasonForDrug: $reasonForDrug, drugIntakeFrequency: $drugIntakeFrequency, drugIntakeIntervalStart: $drugIntakeIntervalStart, drugIntakeIntervalEnd: $drugIntakeIntervalEnd, doseTimeAndCount: $doseTimeAndCount, orderOfDrugIntake: $orderOfDrugIntake)';
  }

  @override
  bool operator ==(covariant Drug other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.intakeForm == intakeForm &&
        other.reasonForDrug == reasonForDrug &&
        other.drugIntakeFrequency == drugIntakeFrequency &&
        other.drugIntakeIntervalStart == drugIntakeIntervalStart &&
        other.drugIntakeIntervalEnd == drugIntakeIntervalEnd &&
        listEquals(other.doseTimeAndCount, doseTimeAndCount) &&
        other.orderOfDrugIntake == orderOfDrugIntake;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        intakeForm.hashCode ^
        reasonForDrug.hashCode ^
        drugIntakeFrequency.hashCode ^
        drugIntakeIntervalStart.hashCode ^
        drugIntakeIntervalEnd.hashCode ^
        doseTimeAndCount.hashCode ^
        orderOfDrugIntake.hashCode;
  }
}

int compareDrugs(Drug a, Drug b) {
  // Get the current date and time
  final now = DateTime.now();

  // Calculate the scores for each drug based on proximity to current date and time
  final scoreA = _calculateScore(a, now);
  final scoreB = _calculateScore(b, now);

  // Compare the scores
  return scoreA.compareTo(scoreB);
}

int _calculateScore(Drug drug, DateTime now) {
  // Calculate the score based on drugIntakeIntervalStart, drugIntakeIntervalEnd,
  // and the time difference between the doseTimeAndCount and the current time.

  var score = 0;

  // If drugIntakeIntervalStart is available, calculate the difference in days
  if (drug.drugIntakeIntervalStart != null) {
    final daysDifference = now.difference(drug.drugIntakeIntervalStart!).inDays;
    score += min(0, daysDifference); // Negative score for past dates
  }

  // If drugIntakeIntervalEnd is available, calculate the difference in days
  if (drug.drugIntakeIntervalEnd != null) {
    final daysDifference = now.difference(drug.drugIntakeIntervalEnd!).inDays;
    score += min(0, daysDifference); // Negative score for past dates
  }

  // Calculate the difference in minutes between each doseTimeAndCount and the current time
  for (var dosage in drug.doseTimeAndCount) {
    final minutesDifference = now
        .difference(_combineDateAndTime(now, dosage.dosageTimeToBeTaken))
        .inMinutes;
    score += min(0, minutesDifference); // Negative score for past times
  }

  return score;
}

DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
