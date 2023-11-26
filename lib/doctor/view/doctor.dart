import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/doctor/view/add_doctor.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const DoctorPage());
  }

  @override
  Widget build(BuildContext context) {
    return const DoctorView();
  }
}

class DoctorView extends StatelessWidget {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitleText(title: context.l10n.doctors),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const SizedBox(
                  height: AppSpacing.xxlg,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 250, maxHeight: 37),
                  child: AppButton.primary(
                    borderRadius: 25,
                    onPressed: () {
                      Navigator.of(context).push(
                        SlidePageRoute<AddDoctorPage>(
                          page: const AddDoctorPage(
                            key: ValueKey<String>('AddDoctorPage'),
                          ),
                        ),
                      );
                    },
                    child: AppButtonText(
                      color: AppColors.white,
                      text: context.l10n.addProfessional,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xxxlg,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                  ),
                  child: Text(
                    context.l10n.addMedicalProfessional,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.textDullColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
