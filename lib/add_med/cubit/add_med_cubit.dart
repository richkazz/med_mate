import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// Represents different types of medication form input fields.
enum AddMedicationFormType { search, selectOne, timePicker, datePicker }

/// Extension methods for AddMedicationFormType to check its type.
extension AddMedicationFormTypeExtension on AddMedicationFormType {
  bool get isSearch => this == AddMedicationFormType.search;
  bool get isSelectOne => this == AddMedicationFormType.selectOne;
  bool get isTimePicker => this == AddMedicationFormType.timePicker;
  bool get isDatePicker => this == AddMedicationFormType.datePicker;
}

/// Handles state and logic for the medication addition form.
class AddMedicationCubit extends Cubit<SearchTextFieldState> {
  AddMedicationCubit()
      : super(
          SearchTextFieldState(
            list: const [],
            dosageTime: TimeOfDay.now(),
            dateTimeRangeResult:
                DateTimeRange(start: DateTime.now(), end: DateTime.now()),
          ),
        );

  List<String> _list = [];

  /// Handles the opening of the medication form based on the form type.
  ///
  /// [listToBeSearched] is the list to be searched during selection.
  /// [addMedicationFormType] is the type of the form field.
  /// [initialValue] is the initial value of the form field.
  void onOpened(
    List<String> listToBeSearched, {
    required AddMedicationFormType addMedicationFormType,
    String? initialValue,
  }) {
    if (addMedicationFormType.isDatePicker) {
      emit(state.copyWith(addMedicationFormType: addMedicationFormType));
      return;
    }

    if (addMedicationFormType.isTimePicker) {
      emit(state.copyWith(addMedicationFormType: addMedicationFormType));
      return;
    }

    _list = listToBeSearched;

    if (initialValue.isNullOrWhiteSpace) {
      if (addMedicationFormType.isSelectOne) {
        emit(
          state.copyWith(
            list: _list,
            addMedicationFormType: addMedicationFormType,
          ),
        );
      }
      return;
    }

    var selectedIndex = -1;
    if (addMedicationFormType.isSelectOne) {
      emit(
        state.copyWith(
          list: _list,
          addMedicationFormType: addMedicationFormType,
        ),
      );
      selectedIndex = _list.indexOf(initialValue!);
    } else {
      search(initialValue!);
      selectedIndex = state.list.indexOf(initialValue);
    }

    emit(
      state.copyWith(
        selectedIndex: selectedIndex,
        initialValue: initialValue,
        addMedicationFormType: addMedicationFormType,
      ),
    );
  }

  /// Searches for a value in the list.
  void search(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(list: [], selectedIndex: -1));
      return;
    }
    final list = _list
        .where((element) => element.toLowerCase().contains(value.toLowerCase()))
        .toList();
    emit(state.copyWith(list: list, selectedIndex: -1));
  }

  /// Handles the selection of an item in the search list.
  void onSearchItemSelected(int selectedIndex) {
    final isUnSelect = selectedIndex == state.selectedIndex;
    emit(state.copyWith(selectedIndex: isUnSelect ? -1 : selectedIndex));
  }

  /// Handles the selection of a date and time.
  void onDateTimeSelected(DateTimeRange dateTimeRange) {
    emit(state.copyWith(selectedIndex: 0, dateTimeRangeResult: dateTimeRange));
  }

  /// Handles the selection of a dosage time.
  void onDosageTimeSelected(TimeOfDay dosageTime) {
    emit(state.copyWith(selectedIndex: 0, dosageTime: dosageTime));
  }

  /// Handles the change in dosage amount.
  void onDosageAmountChange(String amount) {
    final dosageAmount = int.tryParse(amount);
    if (dosageAmount.isNull) {
      return;
    }
    emit(state.copyWith(dosageAmount: dosageAmount));
  }
}

/// Represents the state of the medication form.
class SearchTextFieldState extends Equatable {
  const SearchTextFieldState({
    required this.list,
    required this.dosageTime,
    required this.dateTimeRangeResult,
    this.selectedIndex = -1,
    this.dosageAmount = 1,
    this.initialValue = '',
    this.addMedicationFormType = AddMedicationFormType.search,
  });

  final int selectedIndex;
  final String initialValue;
  final DateTimeRange dateTimeRangeResult;
  final TimeOfDay dosageTime;
  final int dosageAmount;
  final List<String> list;
  final AddMedicationFormType addMedicationFormType;

  @override
  List<Object> get props => [
        ...list,
        selectedIndex,
        initialValue,
        dosageTime,
        addMedicationFormType,
        dateTimeRangeResult,
        dosageAmount,
      ];

  bool get isItemSelected => selectedIndex != -1;

  String get selectedSearchValue => selectedIndex == -1
      ? throw Exception('Value not selected in search list')
      : list[selectedIndex];

  /// Creates a new instance of [SearchTextFieldState] with optional changes.
  SearchTextFieldState copyWith({
    List<String>? list,
    int? selectedIndex,
    int? dosageAmount,
    String? initialValue,
    TimeOfDay? dosageTime,
    DateTimeRange? dateTimeRangeResult,
    AddMedicationFormType? addMedicationFormType,
  }) {
    return SearchTextFieldState(
      list: list ?? this.list,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      dosageTime: dosageTime ?? this.dosageTime,
      dateTimeRangeResult: dateTimeRangeResult ?? this.dateTimeRangeResult,
      initialValue: initialValue ?? this.initialValue,
      addMedicationFormType:
          addMedicationFormType ?? this.addMedicationFormType,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
