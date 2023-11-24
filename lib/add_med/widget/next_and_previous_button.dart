import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/add_med/cubit/search_cubit.dart';
import 'package:med_mate/add_med/view/add_med_search.dart';
import 'package:med_mate/l10n/l10n.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    required this.l10n,
    super.key,
  });

  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    final addMed = AddMedicationInheritedWidget.of(context);

    return SizedBox(
      width: 110,
      height: 40,
      child: BlocBuilder<AddMedicationCubit, SearchTextFieldState>(
        builder: (context, state) {
          return AppButton.primary(
            onPressed: state.isItemSelected
                ? () {
                    Drug onDateTimeRangeSubmit() {
                      return addMed.drug.copyWith(
                        drugIntakeIntervalStart:
                            state.dateTimeRangeResult.start,
                        drugIntakeIntervalEnd: state.dateTimeRangeResult.end,
                      );
                    }

                    final formResult = switch (state.addMedicationFormType) {
                      AddMedicationFormType.search => state.selectedSearchValue,
                      AddMedicationFormType.selectOne =>
                        state.selectedSearchValue,
                      AddMedicationFormType.timePicker => (
                          state.dosageTime,
                          state.dosageAmount
                        ),
                      AddMedicationFormType.datePicker =>
                        onDateTimeRangeSubmit(),
                    };
                    addMed.onNextClicked(
                      formResult,
                    );
                  }
                : null,
            borderRadius: 5,
            child: Text(l10n.next),
          );
        },
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    required this.l10n,
    required this.onPressed,
    super.key,
  });
  final VoidCallback onPressed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 40,
      child: AppButton.primary(
        onPressed: onPressed,
        borderRadius: 5,
        child: Text(l10n.previous),
      ),
    );
  }
}
