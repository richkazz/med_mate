import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/add_med/cubit/search_cubit.dart';
import 'package:med_mate/add_med/view/add_med_search.dart';
import 'package:med_mate/add_med/view/drug_intake_order_form.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const AddMedication());
  }

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  @override
  Widget build(BuildContext context) {
    return DrugNameForm(
      drug: Drug.empty,
    );
  }
}

//1
class DrugNameForm extends StatelessWidget {
  const DrugNameForm({required this.drug, super.key});
  static MaterialPageRoute<void> route(Drug drug) {
    return MaterialPageRoute(builder: (_) => DrugNameForm(drug: drug));
  }

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          UIConstants.commonDrugsInNigeria,
          initialValue: drug.name,
          addMedicationFormType: AddMedicationFormType.search,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        formList: UIConstants.commonDrugsInNigeria,
        initialValue: drug.name,
        selectedDrugName: null,
        onPreviousButtonPressed: () {},
        onAppBarBackButtonPressed: () => Navigator.pop(context),
        title: l10n.addMedicationQuestion,
        subTitle: l10n.enterMedication,
        stepNumber: 1,
        stepTotalCount: 7,
        onNextClicked: (value) {
          Navigator.of(context).push(
            SlidePageRoute<DrugAdministrationMethodForm>(
              page: DrugAdministrationMethodForm(
                drug:
                    drug.copyWith(name: value as String, doseTimeAndCount: []),
              ),
            ),
          );
        },
        icon: Assets.icons.firstAidKit.svg(package: 'app_ui'),
        child: const AddMedicationSteps(),
      ),
    );
  }
}

//4
class DrugIntakeFrequencyForm extends StatelessWidget {
  const DrugIntakeFrequencyForm({required this.drug, super.key});

  static MaterialPageRoute<void> route(Drug drug) {
    return MaterialPageRoute(
      builder: (_) => DrugIntakeFrequencyForm(drug: drug),
    );
  }

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          UIConstants.drugIntakeIntervals,
          initialValue: drug.drugIntakeFrequency,
          addMedicationFormType: AddMedicationFormType.selectOne,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        selectedDrugName: drug.name,
        isSearchTextFieldVisible: false,
        onAppBarBackButtonPressed: () {
          Navigator.pop(context);
        },
        onPreviousButtonPressed: () {
          Navigator.pop(context);
        },
        title: l10n.medicationFrequencyQuestion,
        subTitle: l10n.enterMedicationFrequency,
        stepNumber: 4,
        stepTotalCount: 7,
        onNextClicked: (value) {
          Navigator.of(context).push(
            SlidePageRoute<DrugIntakeIntervalForm>(
              page: DrugIntakeIntervalForm(
                drug: drug.copyWith(drugIntakeFrequency: value as String),
              ),
            ),
          );
        },
        icon: Assets.icons.calendar03.svg(package: 'app_ui'),
        formList: UIConstants.drugIntakeIntervals,
        initialValue: drug.drugIntakeFrequency,
        child: const AddMedicationSteps(),
      ),
    );
  }
}

//6
class DrugDoseTimeForm extends StatelessWidget {
  const DrugDoseTimeForm({
    required this.drug,
    required this.doseNumber,
    super.key,
  });

  final Drug drug;

  /// the number that determine if this is the first or second or third drug
  final int doseNumber;

  @override
  Widget build(BuildContext context) {
    final doseNumberAsString = NumberToWordConverter.convert(doseNumber);
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          [],
          initialValue: drug.drugIntakeFrequency,
          addMedicationFormType: AddMedicationFormType.timePicker,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        selectedDrugName: drug.name,
        isSearchTextFieldVisible: false,
        onAppBarBackButtonPressed: () {
          Navigator.pop(context);
        },
        onPreviousButtonPressed: () {
          Navigator.pop(context);
        },
        title: 'What time do you need to take the $doseNumberAsString dose',
        subTitle: 'Enter the specific amount and time you are required'
            ' to take the $doseNumberAsString dose of the medication.',
        stepNumber: 6,
        stepTotalCount: 7,
        onNextClicked: (value) {
          final drugResult = drug;
          final result = value as (TimeOfDay, int);

          //Due to the possibility of navigating back to this page
          //and the way list works, we need to check if a DosageTimeAndCount
          //as been added for this particular [[doseNumber]
          if (drugResult.doseTimeAndCount.length >= doseNumber) {
            drugResult.doseTimeAndCount[doseNumber - 1] = DosageTimeAndCount(
              dosageTimeToBeTaken: result.$1,
              dosageCount: result.$2,
            );
          } else {
            drugResult.doseTimeAndCount.add(
              DosageTimeAndCount(
                dosageTimeToBeTaken: result.$1,
                dosageCount: result.$2,
              ),
            );
          }

          if (doseNumber == 2) {
            Navigator.of(context).push(
              SlidePageRoute<DrugIntakeOrderForm>(
                page: DrugIntakeOrderForm(
                  key: ValueKey<int>(doseNumber),
                  drug: drugResult,
                ),
              ),
            );
            return;
          }

          Navigator.of(context).push(
            SlidePageRoute<DrugDoseTimeForm>(
              page: DrugDoseTimeForm(
                key: ValueKey<int>(doseNumber),
                doseNumber: 2,
                drug: drugResult,
              ),
            ),
          );
        },
        icon: Assets.icons.alarmClock.svg(package: 'app_ui'),
        formList: UIConstants.drugIntakeIntervals,
        initialValue: drug.drugIntakeFrequency,
        child: const AddMedicationSteps(),
      ),
    );
  }
}

//5
class DrugIntakeIntervalForm extends StatelessWidget {
  const DrugIntakeIntervalForm({required this.drug, super.key});

  static MaterialPageRoute<void> route(Drug drug) {
    return MaterialPageRoute(
      builder: (_) => DrugIntakeIntervalForm(drug: drug),
    );
  }

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          [],
          addMedicationFormType: AddMedicationFormType.datePicker,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        selectedDrugName: drug.name,
        isSearchTextFieldVisible: false,
        onAppBarBackButtonPressed: () {
          Navigator.pop(context);
        },
        onPreviousButtonPressed: () {
          Navigator.pop(context);
        },
        title: 'How long are you supposed to take the medication.',
        subTitle: 'Enter the duration you are to take the medication for'
            ' as specified my the professional',
        stepNumber: 5,
        stepTotalCount: 7,
        onNextClicked: (value) {
          Navigator.of(context).push(
            SlidePageRoute<DrugDoseTimeForm>(
              page: DrugDoseTimeForm(
                doseNumber: 1,
                drug: value as Drug,
              ),
            ),
          );
        },
        icon: Assets.icons.calendar03.svg(package: 'app_ui'),
        formList: UIConstants.drugIntakeIntervals,
        initialValue: '',
        child: const AddMedicationSteps(),
      ),
    );
  }
}

//2
class DrugAdministrationMethodForm extends StatelessWidget {
  const DrugAdministrationMethodForm({required this.drug, super.key});

  static MaterialPageRoute<void> route(Drug drug) {
    return MaterialPageRoute(
      builder: (_) => DrugAdministrationMethodForm(drug: drug),
    );
  }

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          UIConstants.drugAdministrationMethods,
          initialValue: drug.intakeForm,
          addMedicationFormType: AddMedicationFormType.search,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        formList: UIConstants.drugAdministrationMethods,
        initialValue: drug.intakeForm,
        selectedDrugName: drug.name,
        onAppBarBackButtonPressed: () {
          Navigator.pop(context);
        },
        onPreviousButtonPressed: () {
          Navigator.pop(context);
        },
        title: l10n.medicationFormQuestion,
        subTitle: l10n.enterMedicationForm,
        stepNumber: 2,
        stepTotalCount: 7,
        onNextClicked: (value) {
          Navigator.of(context).push(
            SlidePageRoute<DrugReasonsForTakingDrugForm>(
              page: DrugReasonsForTakingDrugForm(
                drug: drug.copyWith(intakeForm: value as String),
              ),
            ),
          );
        },
        icon: Assets.icons.pill.svg(package: 'app_ui'),
        child: const AddMedicationSteps(),
      ),
    );
  }
}

//3
class DrugReasonsForTakingDrugForm extends StatelessWidget {
  const DrugReasonsForTakingDrugForm({required this.drug, super.key});

  static MaterialPageRoute<void> route(Drug drug) {
    return MaterialPageRoute(
      builder: (_) => DrugReasonsForTakingDrugForm(drug: drug),
    );
  }

  final Drug drug;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => AddMedicationCubit()
        ..onOpened(
          UIConstants.reasonsForTakingDrugs,
          initialValue: drug.reasonForDrug,
          addMedicationFormType: AddMedicationFormType.search,
        ),
      child: AddMedicationInheritedWidget(
        drug: drug,
        formList: UIConstants.reasonsForTakingDrugs,
        initialValue: drug.reasonForDrug,
        selectedDrugName: drug.name,
        onAppBarBackButtonPressed: () {
          Navigator.pop(context);
        },
        onPreviousButtonPressed: () {
          Navigator.pop(context);
        },
        title: l10n.medicationPurposeQuestion,
        subTitle: l10n.enterMedicalCondition,
        stepNumber: 3,
        stepTotalCount: 7,
        onNextClicked: (value) {
          Navigator.of(context).push(
            SlidePageRoute<DrugIntakeFrequencyForm>(
              page: DrugIntakeFrequencyForm(
                drug: drug.copyWith(reasonForDrug: value as String),
              ),
            ),
          );
        },
        icon: Assets.icons.pill.svg(package: 'app_ui'),
        child: const AddMedicationSteps(),
      ),
    );
  }
}

class NumberToWordConverter {
  static String convert(int number) {
    if (number < 1 || number > 10) {
      throw ArgumentError('Number should be between 1 and 10.');
    }

    // Add more cases as needed
    switch (number) {
      case 1:
        return 'first';
      case 2:
        return 'second';
      case 3:
        return 'third';
      case 4:
        return 'fourth';
      case 5:
        return 'fifth';
      case 6:
        return 'sixth';
      case 7:
        return 'seventh';
      case 8:
        return 'eighth';
      case 9:
        return 'ninth';
      case 10:
        return 'tenth';
      default:
        throw ArgumentError('Unexpected number: $number');
    }
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.message,
    required this.onPositivePressed,
    required this.onNegativePressed,
    super.key,
  });

  final String message;
  final VoidCallback onPositivePressed;
  final VoidCallback onNegativePressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconWithRoundedBackground(
              color: AppColors.iconSuccessBackgroundColor,
              icon: Assets.icons.taskDone01.svg(package: 'app_ui'),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 90,
                  height: 35,
                  child: AppButton.primary(
                    borderRadius: 5,
                    onPressed: onPositivePressed,
                    child: Text(
                      'Add another',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 35,
                  child: AppButton.primaryOutlined(
                    borderRadius: 5,
                    onPressed: onNegativePressed,
                    child: Text(
                      "That's all",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
