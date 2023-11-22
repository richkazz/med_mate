import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/widget/widgets.dart';
import 'package:med_mate/widgets/widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drugs = context
        .select<LandingPageCubit, List<Drug>>((value) => value.state.drugs);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.outlineLight,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Michael',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 15,
              ),
            ),
          ],
        ),
        actions: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Nov'),
                IconButton(
                  onPressed: () {
                    context.read<LandingPageCubit>().showCalenderToSelect();
                  },
                  icon: Assets.icons.calendar03.svg(
                    height: 20,
                    width: 20,
                    package: 'app_ui',
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(172, 172, 172, 1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Assets.icons.notification02.svg(package: 'app_ui'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: AppColors.dividerColor,
            ),
            const DateSelector(),
            if (drugs.isEmpty)
              const NoMedicationAvailable(
                key: ValueKey('NoMedicationAvailable'),
              )
            else
              const MedicationAvailable(
                key: ValueKey('MedicationAvailable'),
              ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            AddMedicationButton(l10n: context.l10n),
            const SizedBox(
              height: AppSpacing.lg,
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationAvailable extends StatelessWidget {
  const MedicationAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 30,
        ),
        const MedicationAvailableSectionOne(),
        const SizedBox(
          height: 60,
        ),
        BlocSelector<LandingPageCubit, LandingPageState, int>(
          selector: (state) => state.drugs.length,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.md,
                children: [
                  ...context.read<LandingPageCubit>().state.sortedDrugs.map(
                        (e) => DrugDetailInherited(
                          drug: e,
                          child: DrugDetailItem(theme: theme),
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class DrugDetailInherited extends InheritedWidget {
  const DrugDetailInherited({
    required super.child,
    required this.drug,
    super.key,
  });
  final Drug drug;
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
    Future<void> _showDialog(BuildContext context, Drug drug) async {
      await showDialog<void>(
        context: context,
        builder: (context) => DrugDetailPopUp(
          theme: theme,
          drug: drug,
        ),
      );
    }

    final drug = DrugDetailInherited.of(context).drug;
    return InkWell(
      onTap: () => _showDialog(context, drug),
      child: DecoratedBoxWithPrimaryBorder(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 90,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
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
                          'Dose: ${drug.doseTimeAndCount.first.dosageCount}',
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            drug.orderOfDrugIntake,
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w300,
                              color: AppColors.textDullColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.md,
                        ),
                        Text(
                          drug.doseTimeAndCount.first.dosageTimeToBeTaken
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
          ),
        ),
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
    super.key,
  });

  final ThemeData theme;
  final Drug drug;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.fieldFillColor,
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
                backgroundColor: AppColors.fieldFillColor,
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
                '${drug.doseTimeAndCount.first.dosageTimeToBeTaken.formatTime}',
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
              if (value == 1) {
                _showConfirmDrugIntakeDialog(context, drug, theme);
              }
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

Future<void> _showConfirmDrugIntakeDialog(
    BuildContext context, Drug drug, ThemeData theme) async {
  await showDialog<void>(
    context: context,
    builder: (context) => ConfirmDrugIntakeDialog(
      theme: theme,
      drug: drug,
    ),
  );
}

class ConfirmDrugIntakeDialog extends StatelessWidget {
  const ConfirmDrugIntakeDialog({
    required this.theme,
    required this.drug,
    super.key,
  });

  final ThemeData theme;
  final Drug drug;
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
            IconWithRoundedBackground(
                color: AppColors.icon2BackgroundColor,
                icon: Assets.icons.pill.svg(package: 'app_ui')),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              'You are about to take one dose of ${drug.name}',
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
    return BottomNavigationBar(
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.transparent,
      selectedLabelStyle: ContentTextStyle.labelSmall,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.close),
          icon: Icon(Icons.close),
          label: 'Skip',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.check_circle,
            size: 30,
          ),
          icon: Icon(Icons.check_circle_outline),
          label: 'Take now',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.alarm_rounded),
          icon: Icon(Icons.alarm),
          label: 'Reschedule',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (val) {
        setState(() {
          currentIndex = val;
        });
        widget.onTap(val);
      },
    );
  }
}

class MedicationAvailableSectionOne extends StatelessWidget {
  const MedicationAvailableSectionOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        color: AppColors.bottomNavBarColor,
        radius: 100,
      ),
      child: CustomPaint(
        painter:
            CirclePainter(color: AppColors.white, radius: 90, filled: true),
        child: CustomPaint(
          painter: CirclePainter(
            color: AppColors.primaryColor,
            radius: 86,
            filled: true,
          ),
          child: Column(
            children: [
              Text(
                'Next dose in',
                style: ContentTextStyle.bodyText2.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Text(
                '3 hours',
                style: ContentTextStyle.headline5.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              SizedBox(
                width: 90,
                height: 35,
                child: AppButton.primaryFilledWhite(
                  borderRadius: 25,
                  child: Text(
                    'Take now',
                    style: ContentTextStyle.labelSmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.radius,
    required this.color,
    this.filled = false,
  });
  final double radius;
  final bool filled;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = filled ? 0 : 4.0;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
