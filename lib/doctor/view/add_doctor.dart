import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class AddDoctorPage extends StatelessWidget {
  const AddDoctorPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const AddDoctorPage());
  }

  @override
  Widget build(BuildContext context) {
    return const AddDoctorView();
  }
}

class AddDoctorView extends StatelessWidget {
  const AddDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.addDoctor,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: AppColors.dividerColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CircleAvatar(
            backgroundColor: AppColors.textFieldFillColor,
            child: Assets.icons.arrowDown02Sharp.svg(package: 'app_ui'),
          ),
        ),
      ),
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
                const AppTextFieldOutlined(),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 200, maxHeight: 37),
                  child: AppButton.primary(
                    borderRadius: 25,
                    onPressed: () {},
                    child: AppButtonText(
                      color: AppColors.white,
                      text: context.l10n.addProfessional,
                    ),
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
