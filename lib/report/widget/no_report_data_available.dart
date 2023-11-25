import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class NoReportAvailable extends StatelessWidget {
  const NoReportAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        children: [
          Assets.images.medicineCuate1.image(package: 'app_ui'),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Text(
                l10n.medicalReportsVisibility,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: AppColors.textDullColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          const SizedBox(
            height: AppSpacing.xxxlg,
          ),
          const AddMedicationButton(),
        ],
      ),
    );
  }
}
