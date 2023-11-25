import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/l10n/l10n.dart';

class NoMedicationAvailable extends StatelessWidget {
  const NoMedicationAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.images.landingPageToDoIcon.image(package: 'app_ui'),
        const SizedBox(
          height: AppSpacing.md,
        ),
        Text(
          l10n.trackMedicationSchedule,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 230),
            child: Text(
              l10n.medsTakenInstruction,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall!.copyWith(
                color: AppColors.textDullColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
