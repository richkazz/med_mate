# Med Mate

Empowering patients to enhance medical adherence by offering a user-friendly platform for tracking their medication intake.

## Table of Contents

- [Background Task for Checking Missed Drugs](#background-task-for-checking-missed-drugs)
- [Save Drug Cubit](#save-drug-cubit)
- [Add Medication Cubit](#add-medication-cubit)
- [Report Cubit](#report-cubit)

## Background Task for Checking Missed Drugs

This class, `BackgroundTaskToCheckMissedDrugs`, is responsible for running a background task to check if the time for taking a drug has passed. It utilizes a timer to periodically check the drugs' dosage times and emits events when a drug is overdue.

### Usage

```dart
// Example usage of BackgroundTaskToCheckMissedDrugs
final backgroundTask = BackgroundTaskToCheckMissedDrugs(drugs);

// Access the event stream
backgroundTask.eventStream.listen((event) {
  // Handle drug overdue event
});

// Dispose the background task when no longer needed
backgroundTask.dispose();
```

## Save Drug Cubit

The `SaveDrugCubit` manages the state and logic for saving a new drug. It interacts with a `DrugRepository` and a `NotificationService` to persist the drug data and schedule notifications.

### Usage

```dart
// Example usage of SaveDrugCubit
final saveDrugCubit = SaveDrugCubit(drugRepository, notificationService);

// Save a new drug
await saveDrugCubit.saveNewDrugAdded(drug, userId);

// Dispose the cubit when no longer needed
saveDrugCubit.close();
```

## Add Medication Cubit

The `AddMedicationCubit` handles the state and logic for the medication addition form. It includes functionalities for searching, selecting, and handling dosage time and date inputs.

### Usage

```dart
// Example usage of AddMedicationCubit
final addMedicationCubit = AddMedicationCubit();

// Open the medication form
addMedicationCubit.onOpened(listToBeSearched, addMedicationFormType, initialValue);

// Handle form interactions
// ...

// Dispose the cubit when no longer needed
addMedicationCubit.close();
```

## Report Cubit

The `ReportCubit` manages the state of the report screen, fetching and displaying reports for different time ranges. It utilizes a `DrugRepository` for data retrieval and processing.

### Usage

```dart
// Example usage of ReportCubit
final reportCubit = ReportCubit(drugRepository);

// Open the report screen
reportCubit.onOpen(userId);

// Fetch and display reports
await reportCubit.showReportThisMonth();
await reportCubit.showReportLastMonth();
await reportCubit.showReportCustomRange(dateTimeRange);

// Dispose the cubit when no longer needed
reportCubit.close();
```
