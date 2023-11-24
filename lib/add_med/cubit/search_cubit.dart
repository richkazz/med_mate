import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AddMedicationFormType { search, selectOne, timePicker, datePicker }

extension AddMedicationFormTypeExtension on AddMedicationFormType {
  bool get isSearch => this == AddMedicationFormType.search;
  bool get isSelectOne => this == AddMedicationFormType.selectOne;
  bool get isTimePicker => this == AddMedicationFormType.timePicker;
  bool get isDatePicker => this == AddMedicationFormType.datePicker;
}

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

  void onSearchItemSelected(int selectedIndex) {
    final isUnSelect = selectedIndex == state.selectedIndex;
    emit(state.copyWith(selectedIndex: isUnSelect ? -1 : selectedIndex));
  }

  void onDateTimeSelected(DateTimeRange dateTimeRange) {
    emit(state.copyWith(selectedIndex: 0, dateTimeRangeResult: dateTimeRange));
  }

  void onDosageTimeSelected(TimeOfDay dosageTime) {
    emit(state.copyWith(selectedIndex: 0, dosageTime: dosageTime));
  }

  void onDosageAmountChange(String amount) {
    final dosageAmount = int.tryParse(amount);
    if (dosageAmount.isNull) {
      return;
    }
    emit(state.copyWith(dosageAmount: dosageAmount));
  }
}

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
