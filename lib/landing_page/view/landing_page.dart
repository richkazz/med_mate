import 'dart:math';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/add_med/add_med.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/widget/widgets.dart';
import 'package:med_mate/widgets/widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        Wrap(
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
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final drug = DrugDetailInherited.of(context).drug;
    return DecoratedBoxWithPrimaryBorder(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 90),
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
                      Text(
                        drug.name,
                        softWrap: true,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Dose: ${drug.doseTimeAndCount.first.dosageCount}',
                        style: theme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        drug.orderOfDrugIntake,
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColors.textDullColor,
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
