import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/add_med/view/add_med.dart';
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

class AddMedicationButton extends StatelessWidget {
  const AddMedicationButton({
    required this.l10n,
    super.key,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
        child: AppButton.primary(
          onPressed: () => Navigator.push(context, AddMedication.route()),
          borderRadius: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
              ),
              Text(
                l10n.addMedication,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
