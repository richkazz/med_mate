import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/doctor/doctor.dart';
import 'package:med_mate/help/help.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingView();
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: AppColors.dividerColor,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePictureAndNameWithEmailSection(),
              SizedBox(
                height: AppSpacing.xxlg,
              ),
              GeneralSettingSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralSettingSection extends StatelessWidget {
  const GeneralSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.textDullColor,
              ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        DecoratedBoxWithPrimaryBorder(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              0,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                GeneralSettingActionItem(
                  actionText: l10n.doctors,
                  icon: Assets.icons.stethoscope.svg(package: 'app_ui'),
                  onPressed: () {
                    Navigator.of(context).push(
                      SlidePageRoute<DoctorPage>(
                        page: const DoctorPage(
                          key: ValueKey<String>('DoctorPage'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GeneralSettingActionItem(
                  actionText: l10n.helpAndSupport,
                  icon: Assets.icons.messageQuestion.svg(package: 'app_ui'),
                  onPressed: () {
                    Navigator.of(context).push(
                      SlidePageRoute<HelpPage>(
                        page: const HelpPage(
                          key: ValueKey<String>('HelpPage'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                GeneralSettingActionItem(
                  actionText: 'Logout',
                  icon: Assets.icons.logout02.svg(
                    package: 'app_ui',
                    colorFilter: const ColorFilter.mode(
                      AppColors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    context.read<AppBloc>().add(const AppLogoutRequested());
                  },
                  isDividerVisible: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GeneralSettingActionItem extends StatelessWidget {
  const GeneralSettingActionItem({
    required this.icon,
    required this.actionText,
    required this.onPressed,
    this.isDividerVisible = true,
    super.key,
  });
  final Widget icon;
  final String actionText;
  final VoidCallback onPressed;
  final bool isDividerVisible;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: AppSpacing.md,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actionText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                if (isDividerVisible)
                  Container(
                    width: MediaQuery.sizeOf(context).width - 80,
                    height: 1,
                    color: AppColors.dividerColor,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePictureAndNameWithEmailSection extends StatelessWidget {
  const ProfilePictureAndNameWithEmailSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          child: Icon(Icons.account_balance_outlined),
        ),
        const SizedBox(
          width: AppSpacing.sm,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                context.read<AppBloc>().state.user.displayName ?? 'Anonymous',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                context.read<AppBloc>().state.user.email ?? 'Anonymous',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppColors.textDullColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
