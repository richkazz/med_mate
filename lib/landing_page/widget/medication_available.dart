import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/widget/drug_detail.dart';
import 'package:med_mate/widgets/widget.dart';

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
        BlocSelector<LandingPageCubit, LandingPageState, List<Drug>>(
          selector: (state) => state.drugs,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  ...context.read<LandingPageCubit>().state.drugs.map(
                        (drug) => Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: List.generate(
                            drug.doseTimeAndCount.length,
                            (index) => DrugDetailInherited(
                              drug: drug,
                              indexOfDrugDosageTime: index,
                              child: DrugDetailItem(theme: theme),
                            ),
                          ),
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
