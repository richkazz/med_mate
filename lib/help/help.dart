import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/l10n/l10n.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const HelpPage());
  }

  @override
  Widget build(BuildContext context) {
    return const HelpView();
  }
}

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.helpAndSupport,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.black,
                        ),
                    text: '${context.l10n.whatIs} ',
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColors.primaryColor,
                            ),
                        text: context.l10n.medMateQuestion,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  context.l10n.medMateDescription,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                Text(
                  context.l10n.medicalProfessionalsAccess,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  context.l10n.medMateDataControlDescription,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
