import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
@immutable
class MedicationRequest {
  final String medicationName;
  final String medicationForm;
  final String medicationPurpose;
  const MedicationRequest({
    required this.medicationName,
    required this.medicationForm,
    required this.medicationPurpose,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'medicationName': medicationName,
      'medicationForm': medicationForm,
      'medicationPurpose': medicationPurpose,
    };
  }

  factory MedicationRequest.fromMap(Map<String, dynamic> map) {
    return MedicationRequest(
      medicationName: map['medicationName'] as String,
      medicationForm: map['medicationForm'] as String,
      medicationPurpose: map['medicationPurpose'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}

@immutable
class MedicationResponse {
  final int id;
  final String medicationName;
  final String medicationForm;
  final String medicationPurpose;
  const MedicationResponse({
    required this.id,
    required this.medicationName,
    required this.medicationForm,
    required this.medicationPurpose,
  });

  MedicationResponse copyWith({
    int? id,
    String? medicationName,
    String? medicationForm,
    String? medicationPurpose,
  }) {
    return MedicationResponse(
      id: id ?? this.id,
      medicationName: medicationName ?? this.medicationName,
      medicationForm: medicationForm ?? this.medicationForm,
      medicationPurpose: medicationPurpose ?? this.medicationPurpose,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medicationName': medicationName,
      'medicationForm': medicationForm,
      'medicationPurpose': medicationPurpose,
    };
  }

  factory MedicationResponse.fromMap(Map<String, dynamic> map) {
    return MedicationResponse(
      id: map['id'] as int,
      medicationName: map['medicationName'] as String,
      medicationForm: map['medicationForm'] as String,
      medicationPurpose: map['medicationPurpose'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationResponse.fromJson(String source) =>
      MedicationResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedicationResponse(id: $id, medicationName: $medicationName,'
        ' medicationForm: $medicationForm,'
        ' medicationPurpose: $medicationPurpose)';
  }

  @override
  bool operator ==(covariant MedicationResponse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.medicationName == medicationName &&
        other.medicationForm == medicationForm &&
        other.medicationPurpose == medicationPurpose;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        medicationName.hashCode ^
        medicationForm.hashCode ^
        medicationPurpose.hashCode;
  }
}

@immutable
class CreateMedicationRequest {
  final String startDate;
  final String endDate;
  final String medicationFrequency;
  final List<MedicationDosageTime> dosageTimes;
  const CreateMedicationRequest({
    required this.startDate,
    required this.endDate,
    required this.medicationFrequency,
    required this.dosageTimes,
  });

  CreateMedicationRequest copyWith({
    String? startDate,
    String? endDate,
    String? medicationFrequency,
    List<MedicationDosageTime>? dosageTimes,
  }) {
    return CreateMedicationRequest(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      medicationFrequency: medicationFrequency ?? this.medicationFrequency,
      dosageTimes: dosageTimes ?? this.dosageTimes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'medicationFrequency': 'ONCE_A_DAY',
      'dosageTimes': dosageTimes.map((x) => x.toMap()).toList(),
    };
  }
// Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'startDate': startDate,
//       'endDate': endDate,
//       'medicationFrequency': medicationFrequency,
//       'dosageTimes': dosageTimes.map((x) => x.toMap()).toList(),
//     };
//   }

  factory CreateMedicationRequest.fromMap(Map<String, dynamic> map) {
    return CreateMedicationRequest(
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      medicationFrequency: map['medicationFrequency'] as String,
      dosageTimes: List<MedicationDosageTime>.from(
        (map['dosageTimes'] as List<int>).map<MedicationDosageTime>(
          (x) => MedicationDosageTime.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMedicationRequest.fromJson(String source) =>
      CreateMedicationRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'CreateMedicationRequest(startDate: $startDate,'
        ' endDate: $endDate, medicationFrequency: $medicationFrequency,'
        ' dosageTimes: $dosageTimes)';
  }

  @override
  bool operator ==(covariant CreateMedicationRequest other) {
    if (identical(this, other)) return true;

    return other.startDate == startDate &&
        other.endDate == endDate &&
        other.medicationFrequency == medicationFrequency &&
        listEquals(other.dosageTimes, dosageTimes);
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        endDate.hashCode ^
        medicationFrequency.hashCode ^
        dosageTimes.hashCode;
  }
}

@immutable
class MedicationDosageTime {
  final String dosageTime;
  final String amountOfPill;
  final String medicationRequirement;
  final int id;
  final bool isTaken;
  const MedicationDosageTime({
    required this.dosageTime,
    required this.amountOfPill,
    required this.id,
    required this.medicationRequirement,
    this.isTaken = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dosageTime': dosageTime,
      'amountOfPill': amountOfPill,
      'medicationRequirement': 'BEFORE_EATING',
    };
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'dosageTime': dosageTime,
  //     'amountOfPill': amountOfPill,
  //     'medicationRequirement': medicationRequirement,
  //   };
  // }

  factory MedicationDosageTime.fromMap(Map<String, dynamic> map) {
    return MedicationDosageTime(
      dosageTime: map['dosageTime'] as String,
      amountOfPill: map['amountOfPill'] as String,
      id: map['id'] as int,
      isTaken: map['isTaken'] as bool,
      medicationRequirement: map['medicationRequirement'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MedicationDosageTime(id: $id, dosageTime: $dosageTime,'
      ' amountOfPill: $amountOfPill,'
      ' medicationRequirement: $medicationRequirement)';

  @override
  bool operator ==(covariant MedicationDosageTime other) {
    if (identical(this, other)) return true;

    return other.dosageTime == dosageTime &&
        other.amountOfPill == amountOfPill &&
        other.medicationRequirement == medicationRequirement;
  }

  @override
  int get hashCode =>
      dosageTime.hashCode ^
      amountOfPill.hashCode ^
      medicationRequirement.hashCode;
}

@immutable
class AddMedicationResponse {
  final int userId;
  final int id;
  final MedicationResponse medication;
  final String frequency;
  final String startDate;
  final String endDate;
  final List<MedicationDosageTime> dosageTimes;
  const AddMedicationResponse({
    required this.userId,
    required this.id,
    required this.medication,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.dosageTimes,
  });

  AddMedicationResponse copyWith({
    int? userId,
    int? id,
    MedicationResponse? medication,
    String? frequency,
    String? startDate,
    String? endDate,
    List<MedicationDosageTime>? dosageTimes,
  }) {
    return AddMedicationResponse(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      medication: medication ?? this.medication,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dosageTimes: dosageTimes ?? this.dosageTimes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'medication': medication.toMap(),
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'dosageTimes': dosageTimes.map((x) => x.toMap()).toList(),
    };
  }

  factory AddMedicationResponse.fromMap(Map<String, dynamic> map) {
    return AddMedicationResponse(
      userId: map['userId'] as int,
      id: map['id'] as int,
      medication:
          MedicationResponse.fromMap(map['medication'] as Map<String, dynamic>),
      frequency: map['frequency'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      dosageTimes: List<MedicationDosageTime>.from(
        (map['dosageTimes'] as List<dynamic>).map<MedicationDosageTime>(
          (x) => MedicationDosageTime.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddMedicationResponse.fromJson(String source) =>
      AddMedicationResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddMedicationResponse(userId: $userId, id: $id,'
        ' medication: $medication, frequency: $frequency,'
        ' startDate: $startDate, endDate: $endDate, dosageTimes: $dosageTimes)';
  }

  @override
  bool operator ==(covariant AddMedicationResponse other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.id == id &&
        other.medication == medication &&
        other.frequency == frequency &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.dosageTimes, dosageTimes);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        id.hashCode ^
        medication.hashCode ^
        frequency.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        dosageTimes.hashCode;
  }
}
