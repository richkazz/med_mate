import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/add_med/cubit/save_drug.dart';
import 'package:med_mate/add_med/cubit/search_cubit.dart';
import 'package:med_mate/add_med/view/add_med.dart';
import 'package:med_mate/add_med/view/add_med_search.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';

class DrugIntakeOrderForm extends StatelessWidget {
  const DrugIntakeOrderForm({required this.drug, super.key});
  final Drug drug;
  Future<void> _showDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => CustomDialog(
        message: 'You have added ${drug.name} successfully',
        onPositivePressed: () {
          Navigator.pop(context);
          Navigator.push(context, AddMedication.route());
        },
        onNegativePressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddMedicationCubit()
            ..onOpened(
              UIConstants.drugIntakeOrder,
              initialValue: drug.orderOfDrugIntake,
              addMedicationFormType: AddMedicationFormType.selectOne,
            ),
        ),
        BlocProvider(
          create: (context) => SaveDrugCubit(
            context.read<DrugRepository>(),
            notificationService: context.read<NotificationService>(),
          ),
        ),
      ],
      child: BlocListener<SaveDrugCubit, SaveDrugState>(
        listener: (context, state) {
          if (state.submissionStateEnum.isSuccessful) {
            AppNotify.dismissNotify();
            context
                .read<LandingPageBloc>()
                .add(SaveNewDrugAdded(drug: state.drug));
            _showDialog(context);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state.submissionStateEnum.isServerFailure) {
            AppNotify.showError(errorMessage: state.errorMessage);
          } else if (state.submissionStateEnum.isInProgress) {
            AppNotify.showLoading();
          }
        },
        child: DrugIntakeOrderFormView(
          drug: drug,
        ),
      ),
    );
  }
}

class DrugIntakeOrderFormView extends StatelessWidget {
  const DrugIntakeOrderFormView({required this.drug, super.key});

  final Drug drug;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AddMedicationInheritedWidget(
      drug: drug,
      selectedDrugName: drug.name,
      isSearchTextFieldVisible: false,
      onAppBarBackButtonPressed: () {
        Navigator.pop(context);
      },
      onPreviousButtonPressed: () {
        Navigator.pop(context);
      },
      title: l10n.almostDone,
      subTitle: l10n.takeMedicationInstruction,
      stepNumber: 7,
      stepTotalCount: 7,
      onNextClicked: (value) {
        context.read<SaveDrugCubit>().saveNewDrugAdded(
              drug.copyWith(orderOfDrugIntake: value as String),
              context.read<AppBloc>().state.user.uid,
            );
      },
      icon: Assets.icons.calendar03.svg(package: 'app_ui'),
      formList: UIConstants.drugIntakeIntervals,
      initialValue: drug.drugIntakeFrequency,
      child: const AddMedicationSteps(),
    );
  }
}
