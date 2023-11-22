import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Drug {
  final String name;
  final String intakeForm;
  final String reasonForDrug;
  final String drugIntakeFrequency;
  final DateTime? drugIntakeIntervalStart;
  final DateTime? drugIntakeIntervalEnd;
  final DateTime firstDoseTime;
  final DateTime secondDoseTime;

  ///Can be before or after eating or something related
  final String orderOfDrugIntake;
  Drug({
    required this.name,
    required this.intakeForm,
    required this.reasonForDrug,
    required this.drugIntakeFrequency,
    required this.drugIntakeIntervalStart,
    required this.drugIntakeIntervalEnd,
    required this.firstDoseTime,
    required this.secondDoseTime,
    required this.orderOfDrugIntake,
  });

  Drug copyWith({
    String? name,
    String? intakeForm,
    String? reasonForDrug,
    String? drugIntakeFrequency,
    DateTime? drugIntakeIntervalStart,
    DateTime? drugIntakeIntervalEnd,
    DateTime? firstDoseTime,
    DateTime? secondDoseTime,
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
      firstDoseTime: firstDoseTime ?? this.firstDoseTime,
      secondDoseTime: secondDoseTime ?? this.secondDoseTime,
      orderOfDrugIntake: orderOfDrugIntake ?? this.orderOfDrugIntake,
    );
  }

  static Drug empty = Drug(
    drugIntakeFrequency: '',
    drugIntakeIntervalEnd: DateTime.now(),
    drugIntakeIntervalStart: DateTime.now(),
    firstDoseTime: DateTime.now(),
    intakeForm: '',
    name: '',
    orderOfDrugIntake: '',
    reasonForDrug: '',
    secondDoseTime: DateTime.now(),
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
      'firstDoseTime': firstDoseTime,
      'secondDoseTime': secondDoseTime,
      'orderOfDrugIntake': orderOfDrugIntake,
    };
  }

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      name: map['name'] as String,
      intakeForm: map['intakeForm'] as String,
      reasonForDrug: map['reasonForDrug'] as String,
      drugIntakeFrequency: map['drugIntakeFrequency'] as String,
      drugIntakeIntervalStart: DateTime.fromMillisecondsSinceEpoch(
        map['drugIntakeIntervalStart'] as int,
      ),
      drugIntakeIntervalEnd: DateTime.fromMillisecondsSinceEpoch(
        map['drugIntakeIntervalEnd'] as int,
      ),
      firstDoseTime: map['firstDoseTime'] as DateTime,
      secondDoseTime: map['secondDoseTime'] as DateTime,
      orderOfDrugIntake: map['orderOfDrugIntake'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Drug(name: $name, intakeForm: $intakeForm, reasonForDrug: $reasonForDrug, drugIntakeFrequency: $drugIntakeFrequency, drugIntakeIntervalStart: $drugIntakeIntervalStart, drugIntakeIntervalEnd: $drugIntakeIntervalEnd, firstDoseTime: $firstDoseTime, secondDoseTime: $secondDoseTime, orderOfDrugIntake: $orderOfDrugIntake)';
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
        other.firstDoseTime == firstDoseTime &&
        other.secondDoseTime == secondDoseTime &&
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
        firstDoseTime.hashCode ^
        secondDoseTime.hashCode ^
        orderOfDrugIntake.hashCode;
  }
}
