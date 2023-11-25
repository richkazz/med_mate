import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/widgets/widget.dart';

class DrugDetailInherited extends InheritedWidget {
  const DrugDetailInherited({
    required super.child,
    required this.drug,
    required this.indexOfDrugDosageTime,
    super.key,
  });
  final Drug drug;
  final int indexOfDrugDosageTime;
  static DrugDetailInherited? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DrugDetailInherited>();
  }

  static DrugDetailInherited of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No DrugDetailInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class DrugDetailItem extends StatelessWidget {
  const DrugDetailItem({
    required this.theme,
    super.key,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    Future<void> showDialogForDrugDetailPopUp(
      BuildContext context,
      Drug drug,
      int indexOfDosageTime,
    ) async {
      await showDialog<void>(
        context: context,
        builder: (ctx) => DrugDetailPopUp(
          theme: theme,
          drug: drug,
          indexOfDosageTime: indexOfDosageTime,
          landingPageCubit: context.read<LandingPageCubit>(),
        ),
      );
    }

    final drugDetailInherited = DrugDetailInherited.of(context);
    final drug = drugDetailInherited.drug;
    final indexOfDosageTime = drugDetailInherited.indexOfDrugDosageTime;
    final record = (
      drug.doseTimeAndCount[indexOfDosageTime]
          .drugToTakeDailyStatusRecordForToday,
      drug.doseTimeAndCount[indexOfDosageTime].dosageTimeToBeTaken
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 90,
      ),
      child: InkWell(
        onTap: () =>
            showDialogForDrugDetailPopUp(context, drug, indexOfDosageTime),
        child: switch (record) {
          (DrugToTakeDailyStatus.taken, _) => DecoratedBoxWithSuccessBorder(
              child: DrugDetailItemContent(
                theme: theme,
                reducePadding: 5,
              ),
            ),
          (DrugToTakeDailyStatus.missed, _) => DecoratedBoxWithFailureBorder(
              child: DrugDetailItemContent(
                theme: theme,
                reducePadding: 5,
              ),
            ),
          (DrugToTakeDailyStatus.waitingToBeTaken, _) => Padding(
              padding: const EdgeInsets.only(right: 5, top: 5),
              child: DecoratedBoxWithPrimaryBorder(
                child: DrugDetailItemContent(
                  theme: theme,
                  reducePadding: 5,
                ),
              ),
            ),
          (DrugToTakeDailyStatus.skipped, _) => DecoratedBoxWithSkippedBorder(
              child: DrugDetailItemContent(
                theme: theme,
                reducePadding: 5,
              ),
            ),
        },
      ),
    );
  }
}

class DrugDetailItemContent extends StatelessWidget {
  const DrugDetailItemContent({
    required this.theme,
    required this.reducePadding,
    super.key,
  });

  final ThemeData theme;
  final double reducePadding;

  @override
  Widget build(BuildContext context) {
    final drugDetailInherited = DrugDetailInherited.of(context);
    final drug = drugDetailInherited.drug;
    final indexOfDosageTime = drugDetailInherited.indexOfDrugDosageTime;
    final (status, statusColor) = switch (drug
        .doseTimeAndCount[indexOfDosageTime]
        .drugToTakeDailyStatusRecordForToday) {
      (DrugToTakeDailyStatus.taken) => ('Taken', AppColors.green),
      (DrugToTakeDailyStatus.missed) => ('Missed', AppColors.red),
      (DrugToTakeDailyStatus.skipped) => ('Skipped', AppColors.orange),
      (DrugToTakeDailyStatus.waitingToBeTaken) => (
          drug.orderOfDrugIntake,
          AppColors.textDullColor
        ),
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg - reducePadding,
        AppSpacing.lg - reducePadding,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.icons.pill.svg(package: 'app_ui'),
                  SizedBox(
                    width: 90,
                    child: Text(
                      drug.name,
                      softWrap: true,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Dose: ${drug.doseTimeAndCount[indexOfDosageTime].dosageCount}',
                    style: theme.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      status,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w300,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Text(
                    drug.doseTimeAndCount[indexOfDosageTime].dosageTimeToBeTaken
                        .formatTime,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SizeDependentWidget extends StatelessWidget {
  const SizeDependentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Use the width of the text widget to set the size of this widget
        final width = constraints.maxWidth;

        // Use the width to set the size of the widget
        return SizedBox(
          width: width,
          child: const Divider(
            color: AppColors.dividerColor,
          ),
        );
      },
    );
  }
}

class DrugDetailPopUp extends StatelessWidget {
  const DrugDetailPopUp({
    required this.theme,
    required this.drug,
    required this.landingPageCubit,
    required this.indexOfDosageTime,
    super.key,
  });
  final LandingPageCubit landingPageCubit;
  final ThemeData theme;
  final Drug drug;
  final int indexOfDosageTime;
  @override
  Widget build(BuildContext context) {
    final detailController = DrugDetailController(
      context: context,
      drug: drug,
      indexOfDosageTime: indexOfDosageTime,
    );
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.textFieldFillColor,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Text(
                  'Details',
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.textFieldFillColor,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline_sharp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.dividerColor,
          ),
          Assets.icons.pill.svg(package: 'app_ui'),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                drug.name,
                softWrap: true,
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizeDependentWidget(),
            ],
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.calendar03
                  .svg(package: 'app_ui', width: 20, height: 20),
              const SizedBox(
                width: AppSpacing.sm,
              ),
              Text(
                'Scheduled for '
                '${drug.doseTimeAndCount[indexOfDosageTime].dosageTimeToBeTaken.formatTime}',
                softWrap: true,
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.taskDaily02
                  .svg(package: 'app_ui', width: 20, height: 20),
              const SizedBox(
                width: AppSpacing.xs,
              ),
              Text(
                drug.orderOfDrugIntake,
                softWrap: true,
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          DrugsDetailPopUpActions(
            onTap: (value) {
              Navigator.pop(context);
              final isSkipButtonClicked = value == 0;
              final isDoneButtonClicked = value == 1;
              final isRescheduleButtonClicked = value == 2;
              if (isSkipButtonClicked) {
                detailController.onSkippedButtonClicked(
                  landingPageCubit,
                  theme,
                );
              } else if (isDoneButtonClicked) {
                detailController.onDoneButtonClicked(
                  landingPageCubit,
                  theme,
                );
              } else if (isRescheduleButtonClicked) {}
            },
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
        ],
      ),
    );
  }
}

class DrugDetailController {
  DrugDetailController({
    required this.context,
    required this.drug,
    required this.indexOfDosageTime,
  });
  final Drug drug;
  final int indexOfDosageTime;
  final BuildContext context;
  Future<void> onSkippedButtonClicked(
    LandingPageCubit landingPageCubit,
    ThemeData theme,
  ) async {
    await _showConfirmActionDrugIntakeDialog(
      context,
      theme,
      onCancelClicked: () {},
      onConfirmClicked: () {
        landingPageCubit.changeDrugStatusForToday(
          drug,
          DrugToTakeDailyStatus.skipped,
          indexOfDosageTime,
        );
      },
      actionStatement: 'You are about to skip'
          ' ${drug.doseTimeAndCount[indexOfDosageTime].dosageCount} '
          'dose of ${drug.name}',
      icon: IconWithRoundedBackground(
        color: AppColors.icon2BackgroundColor,
        icon: Assets.icons.pill.svg(package: 'app_ui'),
      ),
    );
  }

  Future<void> onDoneButtonClicked(
    LandingPageCubit landingPageCubit,
    ThemeData theme,
  ) async {
    await _showConfirmActionDrugIntakeDialog(
      context,
      theme,
      actionStatement: 'You are about to take'
          ' ${drug.doseTimeAndCount[indexOfDosageTime].dosageCount} '
          'dose of ${drug.name}',
      onCancelClicked: () {},
      onConfirmClicked: () {
        landingPageCubit.changeDrugStatusForToday(
          drug,
          DrugToTakeDailyStatus.taken,
          indexOfDosageTime,
        );
      },
      icon: IconWithRoundedBackground(
        color: AppColors.icon2BackgroundColor,
        icon: Assets.icons.pill.svg(package: 'app_ui'),
      ),
    );
  }

  Future<void> onRescheduleButtonClicked(
    Drug drug,
    LandingPageCubit landingPageCubit,
    ThemeData theme,
  ) async {}
}

Future<void> _showConfirmActionDrugIntakeDialog(
  BuildContext context,
  ThemeData theme, {
  required String actionStatement,
  required VoidCallback onCancelClicked,
  required VoidCallback onConfirmClicked,
  required Widget icon,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => ConfirmDrugIntakeDialog(
      theme: theme,
      icon: icon,
      onCancelClicked: onCancelClicked,
      onConfirmClicked: onConfirmClicked,
      actionStatement: actionStatement,
    ),
  );
}

class ConfirmDrugIntakeDialog extends StatelessWidget {
  const ConfirmDrugIntakeDialog({
    required this.theme,
    required this.onCancelClicked,
    required this.onConfirmClicked,
    required this.actionStatement,
    required this.icon,
    super.key,
  });

  final ThemeData theme;
  final VoidCallback onCancelClicked;
  final VoidCallback onConfirmClicked;
  final String actionStatement;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              actionStatement,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 90,
                  height: 35,
                  child: AppButton.primaryOutlined(
                    borderRadius: 5,
                    onPressed: () {
                      Navigator.pop(context);
                      onCancelClicked();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 35,
                  child: AppButton.primary(
                    borderRadius: 5,
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmClicked();
                    },
                    child: const Text('Confirm'),
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

class DrugsDetailPopUpActions extends StatefulWidget {
  const DrugsDetailPopUpActions({
    required this.onTap,
    super.key,
  });
  final ValueChanged<int> onTap;
  @override
  State<DrugsDetailPopUpActions> createState() =>
      _DrugsDetailPopUpActionsState();
}

class _DrugsDetailPopUpActionsState extends State<DrugsDetailPopUpActions> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DrugDetailPopUpActionButton(
          label: 'Skip',
          onTap: () {
            widget.onTap(0);
          },
          icon: CustomPaint(
            painter: CirclePainter(
              color: AppColors.primaryColor,
              radius: 13,
              strokeWidth: 2,
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        DrugDetailPopUpActionButton(
          label: 'Take now',
          onTap: () {
            widget.onTap(1);
          },
          icon: CustomPaint(
            painter: CirclePainter(
              filled: true,
              color: AppColors.primaryColor,
              radius: 18,
              strokeWidth: 2,
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.white,
            ),
          ),
        ),
        DrugDetailPopUpActionButton(
          label: 'Reschedule',
          onTap: () {
            widget.onTap(2);
          },
          icon: const Icon(
            Icons.alarm,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class DrugDetailPopUpActionButton extends StatelessWidget {
  const DrugDetailPopUpActionButton({
    required this.onTap,
    required this.label,
    required this.icon,
    super.key,
  });
  final VoidCallback onTap;
  final String label;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: icon,
            ),
          ],
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
        ),
      ],
    );
  }
}
