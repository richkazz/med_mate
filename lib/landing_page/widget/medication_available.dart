import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/cubit/landing_page_state.dart';
import 'package:med_mate/landing_page/widget/drug_detail.dart';
import 'package:med_mate/landing_page/widget/medication_available_section_one.dart';

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
            return Wrap(
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
            );
          },
        ),
      ],
    );
  }
}
