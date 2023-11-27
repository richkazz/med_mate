// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/application/model/auth_response.dart';

/// Repository responsible for managing drug-related data.
class DrugRepository {
  final HttpService _httpService;
  final ResultService _resultService;

  /// Constructor for [DrugRepository].
  ///
  /// [_httpService] is used for making HTTP requests, and [_resultService] is used for handling result responses.
  DrugRepository(
    this._httpService, {
    required ResultService resultService,
  }) : _resultService = resultService;

  /// Creates a new drug for the given patient.
  ///
  /// The drug creation involves creating medications and adding medication details.
  Future<Result<Drug>> createDrug(Drug drug, int patientId) async {
    final medicationResponseResult = await createMedications(drug);

    // Handle medication creation failure.
    if (!medicationResponseResult.isSuccessful) {
      return _resultService.error('Error creating Drug');
    }

    final addMedicationResponse =
        await addMedication(drug, medicationResponseResult.data!.id, patientId);

    // Handle medication details addition failure.
    if (!addMedicationResponse.isSuccessful) {
      return _resultService.error('Error creating Drug');
    }

    final dosageTimeAndCount = _getDosageTimeAndCountFromMedicationDosageTime(
      addMedicationResponse.data!.dosageTimes,
    );
    final resultDrug = drug.copyWith(
      scheduleId: addMedicationResponse.data!.id,
      doseTimeAndCount: dosageTimeAndCount,
    );

    return _resultService.successful<Drug>(resultDrug);
  }

  /// Converts [MedicationDosageTime] instances to [DosageTimeAndCount].
  List<DosageTimeAndCount> _getDosageTimeAndCountFromMedicationDosageTime(
    List<MedicationDosageTime> dosageTimes,
  ) {
    return dosageTimes
        .map(
          (e) => DosageTimeAndCount(
            dosageCount: int.tryParse(e.amountOfPill) ?? 1,
            id: e.id,
            dosageTimeToBeTaken: _getTimeOfDayFromDateTimeString(e.dosageTime),
          ),
        )
        .toList();
  }

  /// Converts a date-time string to [TimeOfDay].
  TimeOfDay _getTimeOfDayFromDateTimeString(String dateTimeString) {
    var dateTime = DateTime.tryParse(dateTimeString)?.toLocal();

    // Handle null or invalid date-time strings.
    if (dateTime == null) {
      return TimeOfDay.now();
    }

    // Adjust for timezone.
    dateTime = dateTime.add(const Duration(hours: 1));

    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  /// Updates an existing drug.
  Future<Result<Drug>> updateDrug(Drug drug, int drugId) async {
    final indexOfDrug = globalTestDrugList.indexWhere((element) {
      return element.isEqual(drug);
    });

    // Handle drug not found.
    if (indexOfDrug == -1) {
      return _resultService
          .error<Drug>('Could not find drug with the particular id');
    }

    // Update the drug in the global list.
    globalTestDrugList[indexOfDrug] = drug;
    return _resultService.successful<Drug>(drug);
  }

  /// Retrieves a list of drugs for a given user.
  Future<Result<List<Drug>>> getDrugsByUserId(int userId) async {
    try {
      final response = await _httpService.get(
        'medicationschedule/$userId',
      );
      final addMedicationResponse = (response as List<dynamic>)
          .map((e) => AddMedicationResponse.fromMap(e as DynamicMap))
          .toList();
      final drugs =
          addMedicationResponse.map(fromAddMedicationResponseToDrug).toList();
      return _resultService.successful(drugs);
    } on NetWorkFailure catch (_) {
      return _resultService
          .error('Check your internet connection and try again');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on DioException catch (e) {
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }

  /// Converts [AddMedicationResponse] to [Drug].
  Drug fromAddMedicationResponseToDrug(
      AddMedicationResponse addMedicationResponse) {
    return Drug(
      drugIntakeIntervalStart:
          DateTime.tryParse(addMedicationResponse.startDate) ?? DateTime.now(),
      drugIntakeIntervalEnd:
          DateTime.tryParse(addMedicationResponse.endDate) ?? DateTime.now(),
      name: addMedicationResponse.medication.medicationName,
      intakeForm: addMedicationResponse.medication.medicationForm,
      reasonForDrug: addMedicationResponse.medication.medicationPurpose,
      drugIntakeFrequency: addMedicationResponse.frequency,
      doseTimeAndCount: _getDosageTimeAndCountFromMedicationDosageTime(
          addMedicationResponse.dosageTimes),
      orderOfDrugIntake: addMedicationResponse.dosageTimes.isEmpty
          ? ''
          : addMedicationResponse.dosageTimes.first.medicationRequirement,
    );
  }

  /// Adds a medication for a given drug and patient.
  Future<Result<AddMedicationResponse>> addMedication(
    Drug drug,
    int medicationId,
    int patientId,
  ) async {
    try {
      final createMedicationRequest = CreateMedicationRequest(
        startDate:
            drug.drugIntakeIntervalStart!.toUtc().toLocal().toIso8601String(),
        endDate:
            drug.drugIntakeIntervalEnd!.toUtc().toLocal().toIso8601String(),
        medicationFrequency: drug.drugIntakeFrequency,
        dosageTimes: drug.doseTimeAndCount
            .map<MedicationDosageTime>(
              (e) => MedicationDosageTime(
                id: 0,
                dosageTime: e.dosageTimeToBeTaken.combineDateAndTime
                    .toUtc()
                    .toIso8601String(),
                amountOfPill: e.dosageCount.toString(),
                medicationRequirement: drug.orderOfDrugIntake,
              ),
            )
            .toList(),
      );
      final response = await _httpService.post(
        'medications/addMedication/$medicationId/$patientId/',
        data: createMedicationRequest.toJson(),
      );
      final addMedicationResponse =
          AddMedicationResponse.fromMap(response as DynamicMap);

      return _resultService.successful(addMedicationResponse);
    } on NetWorkFailure catch (_) {
      return _resultService
          .error('Check your internet connection and try again');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on DioException catch (e) {
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }

  /// Creates medications for a given drug.
  Future<Result<MedicationResponse>> createMedications(Drug drug) async {
    try {
      final medicationRequest = MedicationRequest(
        medicationName: drug.name,
        medicationForm: drug.intakeForm,
        medicationPurpose: drug.reasonForDrug,
      );

      final response = await _httpService.post(
        'medications/createMedications',
        data: medicationRequest.toJson(),
      );
      final apiResponse = ApiResponse.fromMap(response as DynamicMap);
      final medicationResponse =
          MedicationResponse.fromMap(apiResponse.medication as DynamicMap);

      return _resultService.successful(medicationResponse);
    } on NetWorkFailure catch (_) {
      return _resultService
          .error('Check your internet connection and try again');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on DioException catch (_) {
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }
}
